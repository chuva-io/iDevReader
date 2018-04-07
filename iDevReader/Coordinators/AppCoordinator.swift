//
//  AppCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

struct AppCoordinator {
    
    let window: UIWindow
    fileprivate let tabBarController = UITabBarController()
    fileprivate let browseCoordinator: BrowseCoordinator
    fileprivate let bookmarkCoordinator: BookmarkCoordinator
    
    init(window: UIWindow) {
        self.window = window
        
        browseCoordinator = BrowseCoordinator()
        bookmarkCoordinator = BookmarkCoordinator()
        
        tabBarController.viewControllers = [browseCoordinator.rootVC,
                                            bookmarkCoordinator.rootVC]
        
        self.window.tintColor = Theme.Colors.tintColor
        Theme.applyAppearance()
        Theme.configureTabBar(tabBarController: tabBarController)
    }
    
    func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
}



