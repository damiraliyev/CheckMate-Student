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
        
        let absenceReasonVC = AbsenceReasonViewController()
        absenceReasonVC.tabBarItem = UITabBarItem(title: "Compose", image: UIImage(systemName: "message"), tag: 1)
        
        let absenceReasonNC = UINavigationController(rootViewController: absenceReasonVC)
        
        viewControllers = [homeVC, absenceReasonNC]
        
        loadAllControllers()
    }
    
    func loadAllControllers() {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let navVC = viewController as? UINavigationController {
                    print("true")
                    let _ = navVC.viewControllers.first?.view
                }
               
            }
        }
    }

}
