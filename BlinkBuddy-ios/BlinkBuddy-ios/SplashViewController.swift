//
//  SplashViewController.swift
//  BlinkBuddy-ios
//
//  Created by Thayallan Srinathan on 2019-01-26.
//  Copyright © 2019 BlinkBuddy. All rights reserved.
//

import UIKit
import EasyPeasy

class SplashViewController: UIViewController {
    
    private let logo = UIImageView().then {
        $0.image = UIImage(named: "whiteLogo")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UI.Colors.swishBlue
        
        layoutViews()
    }
}

extension SplashViewController {
    func layoutViews() {
        view.addSubview(logo)
        logo.easy.layout(Width(330), Height(55), CenterX(), CenterY(-100))
    }
}
