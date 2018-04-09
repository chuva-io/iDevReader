//
//  AppRouter.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

enum AppRoute {
    case feed
    //    case bookmarks
}

class AppRouter {
    let coordinator: AppCoordinator
    
    var feedCoordinator: FeedCoordinator?
    
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
        }
    }
    
    @objc fileprivate func dismissFeedCoordinator() {
        feedCoordinator?.presenter.dismiss(animated: true, completion: nil)
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
}
