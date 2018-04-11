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
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()

//        appCoordinator.route(to: .bookmarks)
//        appCoordinator.route(to: .article(article: BookmarkStore().items[0]))
//        appCoordinator.route(to: .bookmarks)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard url.pathComponents == ["/", "articles"],
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
            let urlString = queryItems.first(where: { $0.name == "url" })?.value,
            let articleUrl = URL(string: urlString) else { return false }
        
        appCoordinator.route(to: .article(article: BookmarkStore().items[1]))
        
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        appCoordinator.route(to: .bookmarks)
    }

}
