//
//  BrowseCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

class BrowseCoordinator: NSObject {
    
    let presenter: UINavigationController
    let bookmarkStore: BookmarkStore
    
    fileprivate var articleListVC: ArticleListVC?
    
    init(presenter: UINavigationController, bookmarkStore: BookmarkStore) {
        let vc = CategoryListVC()
        vc.title = "Categories"
        
        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.presenter.pushViewController(vc, animated: false)
        self.bookmarkStore = bookmarkStore
        
        super.init()
        vc.delegate = self
    }
    
}


extension BrowseCoordinator: CategoryListVCDelegate {
    
    func sender(_ sender: CategoryListVC, didSelect category: Category) {
        let feeds = category.feeds
        let feedsVC = FeedListVC(feeds: feeds)
        feedsVC.delegate = self
        feedsVC.title = category.title
        presenter.pushViewController(feedsVC, animated: true)
    }
    
}

extension BrowseCoordinator: FeedListVCDelegate {
    
    func sender(_ sender: FeedListVC, didSelect feed: Feed) {
        let coordinator = FeedCoordinator(feed: feed,
                                          bookmarkStore: bookmarkStore,
                                          presenter: presenter)
        coordinator.start()
    }
    
}
