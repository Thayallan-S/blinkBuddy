//
//  MainFlowController.swift
//  BlinkBuddy-ios
//
//  Created by Thayallan Srinathan on 2019-01-26.
//  Copyright © 2019 BlinkBuddy. All rights reserved.
//

import UIKit

class MainFlowController: UIViewController {
    
    private let mainViewController = MainViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        presentMainViewController()
    }
}

extension MainFlowController {
    func presentMainViewController() {
        add(childController: mainViewController)
    }
}
