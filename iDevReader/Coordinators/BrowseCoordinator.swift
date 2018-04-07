//
//  BrowseCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

struct BrowseCoordinator {
    let rootVC: UIViewController
    
    fileprivate var navigationVC: UINavigationController {
        return rootVC as! UINavigationController
    }
    
    init() {
        let vc = CategoryListVC()
        vc.title = "Categories"
        self.rootVC = UINavigationController(rootViewController: vc)
        
        vc.delegate = self
        navigationVC.navigationBar.prefersLargeTitles = true
    }
    
}


extension BrowseCoordinator: CategoryListVCDelegate {
    
    func sender(_ sender: CategoryListVC, didSelect category: Category) {
        let feeds = category.feeds
        let feedsVC = FeedListVC(feeds: feeds)
        feedsVC.title = category.title
        navigationVC.pushViewController(feedsVC, animated: true)
    }
    
}
