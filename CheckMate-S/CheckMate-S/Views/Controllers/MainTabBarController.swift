//
//  MainTabBarController.swift
//  CheckMate-S
//
//  Created by Damir Aliyev on 17.04.2023.
//

import UIKit

class MainTabBarControlller: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        
        viewControllers = [homeVC]
    }
}