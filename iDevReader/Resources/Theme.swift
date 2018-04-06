//
//  Theme.swift
//  iDevReader
//
//  Created by Ivan Corchado Ruiz on 4/5/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

struct Theme {
    struct Colors {
        static let tintColor = UIColor(red:1.00, green:0.51, blue:0.00, alpha:1.0)
    }
    
    static func applyAppearance() {
        UINavigationBar.appearance().tintColor = Theme.Colors.tintColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Theme.Colors.tintColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: Theme.Colors.tintColor]
    }
    
    static func configureTabBar(tabBarController: UITabBarController) {
        let browseTab = tabBarController.tabBar.items?.first
        let bookmarkTab = tabBarController.tabBar.items?.last
        browseTab?.image = UIImage(named: "browseOn")
        bookmarkTab?.image = UIImage(named: "bookmarkOn")
        browseTab?.title = "Browse"
        bookmarkTab?.title = "Bookmarks"
    }
}



