//
//  GetStartedViewController.swift
//  BlinkBuddy-ios
//
//  Created by Thayallan Srinathan on 2019-01-27.
//  Copyright © 2019 BlinkBuddy. All rights reserved.
//

import UIKit
import EasyPeasy
import Then
import ARKit

protocol GetStartedViewDelegate: class {
    func addAndRemove()
    func openMain()
}

class GetStartedViewController: UIViewController {
    
    weak var delegate: GetStartedViewDelegate?
    
    var mosquitto = MosquittoServer()
    
    var leftCounter = 0
    var rightCounter = 0
    
    var state: Bool = true
    
    
    var previousRawVal = [String]()
    
    let sceneView = ARSCNView()

    private let GetStartedLabel = UILabel().then {
        $0.textColor = UI.Colors.swishBlue
        $0.font = UI.Font.regular(50)
        $0.text = "BlinkBuddy"
    }
    
    private let firstOptionLabel = UILabel().then {
        $0.textColor = UI.Colors.dullGrey
        $0.font = UI.Font.regular(25)
        $0.text = "1) Blink once to open door"
    }
    
    private let secondOptionLabel = UILabel().then {
        $0.textColor = UI.Colors.dullGrey
        $0.font = UI.Font.regular(25)
        $0.text = "2) Blink twice to send a help text"
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UI.Colors.white
        
        
        setupProperties()
        layoutViews()
        
        guard ARFaceTrackingConfiguration.isSupported else { fatalError() }
        sceneView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}


extension GetStartedViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let device = sceneView.device else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        
        node.geometry?.firstMaterial?.transparency = 0.0
        
        //print("\(faceAnchor.blendShapes.)")
        
        
        //identifyBlinking(faceAnchor: faceAnchor)
        
        
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        
        
        faceGeometry.update(from: faceAnchor.geometry)
        for keys in faceAnchor.blendShapes {
            if Double(keys.value) > 0.65 {
                previousRawVal.append(keys.key.rawValue)
                if rawValBool() {
                   
                    
                    //delegate?.openMain()
                }
                else if keys.key.rawValue == "eyeBlink_L" {
                    leftCounter = leftCounter + 1
                    if leftCounter == 4 {
                         previousRawVal.removeAll()
                        
                        print("Starting...")
                        let twilioSID = ""
                        let twilioSecret = ""
                        //Note replace + = %2B , for To and From phone number
                        let fromNumber = "+12898053511"// actual number is +9999999
                        let toNumber = "+16478180429"// actual number is +9999999
                        let message = "HELP, DAVID IS IN TROUBLE"
                        
                        // Build the request
                        let request = NSMutableURLRequest(url: URL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
                        request.httpMethod = "POST"
                        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: .utf8)
                        
                        // Build the completion block and send the request
                        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                            print("Finished")
                            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                                // Success
                                print("Response: \(responseDetails)")
                            } else {
                                // Failure
                                print("Error: \(error)")
                            }
                        }).resume()
                        delegate?.addAndRemove()
                    }
                    
                }
                
                else if keys.key.rawValue == "eyeBlink_R" {
                    rightCounter = rightCounter + 1
                    if rightCounter == 5 {
                        previousRawVal.removeAll()
                        if state {
                            mosquitto.open()
                            delegate?.addAndRemove()
                            state = false

                        }
                        else {
                            mosquitto.close()
                            delegate?.addAndRemove()
                            state = true
                        }
                        rightCounter = 0
                        //mosquitto.open()
                        // delegate?.openMain()
                    }
                }
            }
        }
    }
}
    
    
extension GetStartedViewController {
   
    func rawValBool () -> Bool {
        var leftCount = 0
        var rightCount = 0
        if previousRawVal.count > 8 {
            for string in previousRawVal {
                if string == "eyeBlink_L" {
                    leftCount = leftCount + 1
                }
                if string == "eyeBlink_R" {
                    rightCount = rightCount + 1
                }
            }
            if leftCount == rightCount {
                leftCount = 0
                rightCount = 0
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func setupProperties() {
    
    }
    func layoutViews() {
        view.addSubview(GetStartedLabel)
        GetStartedLabel.easy.layout(CenterX(), Top(80))
        
        view.addSubview(firstOptionLabel)
        firstOptionLabel.easy.layout(Left(30), Top(20).to(GetStartedLabel))
        
        view.addSubview(secondOptionLabel)
        secondOptionLabel.easy.layout(Left(30), Right(30), Top(20).to(firstOptionLabel))
        
        view.addSubview(sceneView)
        sceneView.easy.layout(Width(300), Height(425), Top(40).to(secondOptionLabel), CenterX())
    }
}
