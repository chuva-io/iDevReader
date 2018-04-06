//
//  AppDelegate.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/25/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        let browseNavVC = UINavigationController(rootViewController: CategoryListVC())
        let bookmarkVC = ArticleListVC(configuration: .bookmarks)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [browseNavVC, bookmarkVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        // Apply Theme
        window?.tintColor = Theme.Colors.tintColor
        Theme.applyAppearance()
        Theme.configureTabBar(tabBarController: tabBarController)
        
        return true
    }
}
