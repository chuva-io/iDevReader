//
//  AppCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

class AppCoordinator: NSObject {
    
    let window: UIWindow
    fileprivate let tabBarController = UITabBarController()
    
    fileprivate let browseCoordinator: BrowseCoordinator
    fileprivate let bookmarkCoordinator: BookmarkCoordinator
    fileprivate var feedCoordinator: FeedCoordinator?
    fileprivate var articleCoordinator: ArticleCoordinator?
    
    let bookmarkStore = BookmarkStore()
    
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

extension AppCoordinator: Routable {
    
    enum Route {
        case article(article: MWFeedItem)
        case bookmarks
    }
    
    func route(to route: Route) {
        switch route {
            
        case let .article(article):
            dismissArticleCoordinator()
            
            let navigationController = UINavigationController()
            navigationController.modalPresentationStyle = .pageSheet
            articleCoordinator = ArticleCoordinator(article: article,
                                                    bookmarkStore: bookmarkStore,
                                                    presenter: navigationController)
            articleCoordinator!.start()
            
            navigationController
                .viewControllers[0]
                .navigationItem
                .leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                     target: self,
                                                     action: #selector(dismissArticleCoordinator))
            
            tabBarController.present(navigationController, animated: false)

            
        case .bookmarks:
            dismissArticleCoordinator()
            dismissFeedCoordinator()
            tabBarController.selectedIndex = 1
        }
    }
    
    @objc fileprivate func dismissFeedCoordinator() {
        feedCoordinator?.presenter.dismiss(animated: true, completion: nil)
        feedCoordinator = nil
    }
    
    @objc fileprivate func dismissArticleCoordinator() {
        articleCoordinator?.presenter.dismiss(animated: true, completion: nil)
        articleCoordinator = nil
    }
        
}

extension AppCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == bookmarkCoordinator.rootVC {
            bookmarkCoordinator.updateBookmarks()
        }
    }
    
}
