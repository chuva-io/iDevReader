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
//        case feed
        case article(article: MWFeedItem)
        case bookmarks
    }
    
    func route(to route: Route) {
        switch route {
            
//        case .feed:
//            let navigationController = UINavigationController()
//            feedCoordinator = FeedCoordinator(bookmarkStore: bookmarkStore,
//                                              presenter: navigationController)
//            
//            navigationController
//                .viewControllers[0]
//                .navigationItem
//                .leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
//                                                     target: self,
//                                                     action: #selector(dismissFeedCoordinator))
//            
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                navigationController.modalPresentationStyle = .pageSheet
//            }
//            
//            topViewController().present(navigationController, animated: false)
            
            
        case let .article(article):
            let navigationController = UINavigationController()
            articleCoordinator = ArticleCoordinator(article: article,
                                                    bookmarkStore: bookmarkStore,
                                                    presenter: navigationController)
            
            navigationController
                .viewControllers[0]
                .navigationItem
                .leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                     target: self,
                                                     action: #selector(dismissArticleCoordinator))
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                navigationController.modalPresentationStyle = .pageSheet
            }
            
            topViewController().present(navigationController, animated: false)

            
        case .bookmarks:
            if articleCoordinator == nil,
                feedCoordinator == nil {
                tabBarController.selectedIndex = 1
            }
            else {
                let coordinator = BookmarkCoordinator(bookmarkStore: bookmarkStore)
                let navigationController = UINavigationController(rootViewController: coordinator.rootVC)
                
                coordinator.rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                                      target: self,
                                                                                      action: #selector(dismissTopViewController))

                if UIDevice.current.userInterfaceIdiom == .pad {
                    navigationController.modalPresentationStyle = .pageSheet
                }
                
                topViewController().present(navigationController, animated: false)
            }
            
        }
    }
    
    @objc fileprivate func dismissFeedCoordinator() {
        dismissTopViewController()
        feedCoordinator?.presenter.dismiss(animated: true, completion: nil)
        feedCoordinator = nil
    }
    
    @objc fileprivate func dismissArticleCoordinator() {
        articleCoordinator?.presenter.dismiss(animated: true, completion: nil)
        articleCoordinator = nil
    }
    
    @objc func dismissTopViewController() {
        topViewController().dismiss(animated: true)
    }
    
    fileprivate func topViewController() -> UIViewController {
        var topVC: UIViewController = tabBarController
        while let newTop = topVC.presentedViewController {
            topVC = newTop
        }
        return topVC
    }
    
}

extension AppCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == bookmarkCoordinator.rootVC {
            bookmarkCoordinator.updateBookmarks()
        }
    }
    
}
