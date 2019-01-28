//
//  AppFlowController.swift
//  BlinkBuddy-ios
//
//  Created by Thayallan Srinathan on 2019-01-26.
//  Copyright © 2019 BlinkBuddy. All rights reserved.
//


import UIKit

class AppFlowController: UIViewController {
    
    private let splashViewController = SplashViewController()
    private let mainFlowController = MainFlowController()
    private let getStartedViewController = GetStartedViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedViewController.delegate = self
    }
    
    func start() {
        presentSplashViewController()
    }
}

// MARK: - Start Child FlowControllers
extension AppFlowController {
    func presentSplashViewController() {
        add(childController: splashViewController)
        
        let deadline = DispatchTime.now() + 3.0
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.dismissSplashViewController()
        })
    }
    
    func dismissSplashViewController() {
        remove(childController: splashViewController)
        
        startGetStarted()
    }
    
    func startGetStarted() {
        add(childController: getStartedViewController)
        
    }
    
    func dismissGetStarted() {
        remove(childController: getStartedViewController)
        
        startMainFlowController()
    }
    
    func startMainFlowController() {
        add(childController: mainFlowController)
    }
}

extension AppFlowController: GetStartedViewDelegate {
    func addAndRemove() {
        remove(childController: getStartedViewController)
        add(childController: getStartedViewController)
    }
    
    func openMain() {
        dismissGetStarted()
    }
}
