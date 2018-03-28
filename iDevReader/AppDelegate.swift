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
        browseNavVC.title = "Browse"
        
        let bookmarkNavVC = UINavigationController(rootViewController: ArticleListVC(configuration: .bookmarks))
        bookmarkNavVC.title = "Bookmarks"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [browseNavVC, bookmarkNavVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

}
