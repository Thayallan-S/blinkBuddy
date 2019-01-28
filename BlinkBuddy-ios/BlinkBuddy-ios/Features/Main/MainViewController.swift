//
//  MainViewController.swift
//  BlinkBuddy-ios
//
//  Created by Thayallan Srinathan on 2019-01-26.
//  Copyright © 2019 BlinkBuddy. All rights reserved.
//

import UIKit
import EasyPeasy
import Then
import ARKit

class MainViewController: UIViewController {
    
    var letter = [Int]()
    
    var sceneView = ARSCNView()
    
    let features = ["leftEye", "rightEye"]
    
    var previousRawVal = [String]()

    var counter: Int = 0
    var leftCounter = 0
    var rightCounter = 0
    
    private let label = UILabel().then {
        $0.textColor = UI.Colors.swishBlue
        $0.font = UI.Font.regular(40)
        $0.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UI.Colors.white

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

extension MainViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let device = sceneView.device else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        
        node.geometry?.firstMaterial?.transparency = 0.0
        
        //print("\(faceAnchor.blendShapes.)")
        
        
        identifyBlinking(faceAnchor: faceAnchor)
    
       
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        
        identifyBlinking(faceAnchor: faceAnchor)
        
        
        
    }
}

extension MainViewController {
    func layoutViews() {
        view.addSubview(sceneView)
        sceneView.easy.layout(Edges())
        
        view.addSubview(label)
        label.easy.layout(CenterX(), CenterY())
    }
    
    func identifyBlinking(faceAnchor: ARFaceAnchor) {
        for key in faceAnchor.blendShapes {
            if Double(key.value) > 0.7 {
                previousRawVal.append(key.key.rawValue)
                if rawValBool() {
                    let string = identifyLetter()
                    label.text = string
                    letter.removeAll()
                    counter = 0
                    leftCounter = 0
                    rightCounter = 0
                }
                    
                else if key.key.rawValue == "eyeBlink_L" {
                    leftCounter = leftCounter + 1
                    if leftCounter == 2 {
                        previousRawVal.removeAll()
                        letter.append(2)
                    }
                }
                    
                else if key.key.rawValue == "eyeBlink_R" {
                    rightCounter = rightCounter + 1
                    if rightCounter == 2 {
                        previousRawVal.removeAll()
                        letter.append(1)
                        
                    }
                }
            }
        }
    }
    
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
    
    func identifyLetter() -> String{
        return ""
        /*if letter.count == 1 {
            if letter[0] == 1 {
                return "E"
            }
            else {
                return "T"
            }
        }
        else if letter.count == 2 {
            if letter[0] == 1 {
                if letter[1] == 1 {
                    return "I"
                }
                else {
                    return "A"
                }
            }
            else {
                if letter[1] == 1 {
                    return "N"
                }
                else {
                    return "M"
                }
            }
        }
        else if letter.count == 3 {
            if letter[0] == 1 {
                if letter[1] == 1 {
                    if letter[2] == 2 {
                        return "S"
                    }
                    else {
                        return "U"
                    }
                }
                else {
                    if letter[2] == 1{
                        return "R"
                    }
                    else {
                        return "W"
                    }
                }
                
            }
            else {
                if letter[1] == 1 {
                    if letter[2] == 1 {
                        return "D"
                    }
                    else {
                        return "K"
                    }
                    
                }
                else {
                    if letter[2] == 1 {
                        return "G"
                    }
                    else {
                        return "O"
                    }
                }
            }
        }
        
        else if letter.count == 4 {
            if letter[0] == 1 {
                if letter[1] == 1 {
                    if letter[2] == 1 {
                        if letter[3] == 1 {
                            return "H"
                        }
                        else {
                            return "V"
                        }
                    }
                    else {
                        if letter[3] == 1 {
                            return "F"
                        }
                        else {
                            return "OK"
                        }
                        
                    }
                }
                else {
                    if letter[2] == 1 {
                        if letter[3] == 1 {
                            return "L"
                        }
                        else {
                            return "OK"
                        }
                    }
                    else {
                        if letter[3] == 1 {
                            return "P"
                        }
                        else {
                            return "J"
                        }
                        
                    }
                    
                }
            }
            else {
                if letter[1] == 1 {
                    if letter[2] == 1 {
                        if letter[3] == 1 {
                            return "B"
                        }
                        else {
                            return "X"
                        }
                    }
                    else {
                        if letter[3] == 1 {
                            return "C"
                        }
                        else {
                            return "Y"
                        }
                        
                    }
                }
                else {
                    if letter[2] == 1 {
                        if letter[3] == 1 {
                            return "Z"
                        }
                        else {
                            return "Q"
                        }
                    }
                    else {
                        if letter[3] == 1 {
                            return "OK"
                        }
                        else {
                            return "OK"
                        }
                        
                    }
                    
                }
                
            }
        }
        return "OK"*/
    }
}
   
