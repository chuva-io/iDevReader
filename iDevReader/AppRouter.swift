//
//  AppRouter.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

enum AppRoute {
    case feed
    case article(article: MWFeedItem)
}

class AppRouter {
    let coordinator: AppCoordinator
    
    var feedCoordinator: FeedCoordinator?
    var articleCoordinator: ArticleCoordinator?
    
    func route(to route: AppRoute) {
        switch route {
        
        case .feed:
            let navigationController = UINavigationController()
            feedCoordinator = FeedCoordinator(bookmarkStore: coordinator.bookmarkStore, presenter: navigationController)
            
            navigationController
                .viewControllers[0]
                .navigationItem
                .leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                     target: self,
                                                     action: #selector(dismissFeedCoordinator))
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                navigationController.modalPresentationStyle = .pageSheet
            }
            
            coordinator.window.rootViewController?.present(navigationController, animated: true)
         
        case let .article(article):
            let navigationController = UINavigationController()
            articleCoordinator = ArticleCoordinator(article: article,
                                                    bookmarkStore: coordinator.bookmarkStore,
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
            
            coordinator.window.rootViewController?.present(navigationController, animated: true)
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
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
}
