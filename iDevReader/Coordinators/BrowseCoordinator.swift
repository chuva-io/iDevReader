//
//  BrowseCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class BrowseCoordinator: NSObject {
    
    let presenter: UINavigationController
    let bookmarkStore: BookmarkStore
    
    var feedCoordinator: FeedCoordinator?
    
    init(presenter: UINavigationController, bookmarkStore: BookmarkStore) {
        let vm = CategoryListVM()
        let vc = CategoryListVC(viewModel: vm)
        vc.title = "Categories"
        
        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.presenter.pushViewController(vc, animated: false)
        self.bookmarkStore = bookmarkStore
        
        super.init()
        vm.delegate = self
    }
    
}


extension BrowseCoordinator: CategoryListVMDelegate {
    
    func sender(_ sender: CategoryListVM, didSelect category: Category) {
        let feeds = category.feeds
        let vm = FeedListVM(feeds: feeds)
        vm.delegate = self
        let feedsVC = FeedListVC(viewModel: vm)
        feedsVC.title = category.title
        presenter.pushViewController(feedsVC, animated: true)
    }
    
}

extension BrowseCoordinator: FeedListVMDelegate {
    
    func sender(_ sender: FeedListVM, didSelect feed: Feed) {
        feedCoordinator = FeedCoordinator(feed: feed,
                                          bookmarkStore: bookmarkStore,
                                          presenter: presenter)
        feedCoordinator!.start()
    }
    
}
