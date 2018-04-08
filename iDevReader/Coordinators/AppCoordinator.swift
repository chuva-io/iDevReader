//
//  AppCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject {
    
    let window: UIWindow
    fileprivate let tabBarController = UITabBarController()
    fileprivate let browseCoordinator: BrowseCoordinator
    fileprivate let bookmarkCoordinator: BookmarkCoordinator
    
    fileprivate let bookmarkStore = BookmarkStore()
    
    init(window: UIWindow) {
        self.window = window
        
        browseCoordinator = BrowseCoordinator(presenter: UINavigationController(), bookmarkStore: bookmarkStore)
        bookmarkCoordinator = BookmarkCoordinator(bookmarkStore: bookmarkStore)
        
        tabBarController.viewControllers = [browseCoordinator.presenter,
                                            bookmarkCoordinator.rootVC]
        
        self.window.tintColor = Theme.Colors.tintColor
        Theme.applyAppearance()
        Theme.configureTabBar(tabBarController: tabBarController)
        
        super.init()
        tabBarController.delegate = self
    }
    
    func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
}

extension AppCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == bookmarkCoordinator.rootVC {
            bookmarkCoordinator.updateBookmarks()
        }
    }
    
}
