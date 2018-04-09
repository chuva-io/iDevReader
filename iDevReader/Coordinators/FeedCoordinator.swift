//
//  FeedCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

class FeedCoordinator: NSObject {
    
    let presenter: UINavigationController
    let bookmarkStore: BookmarkStore
    
    fileprivate var articleListVC: ArticleListVC?
    
    init(bookmarkStore: BookmarkStore, presenter: UINavigationController) {
        let vc = ArticleListVC()
        vc.title = "title"

        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.presenter.pushViewController(vc, animated: false)
        self.bookmarkStore = bookmarkStore
        
        super.init()
        vc.delegate = self
    }
    
}

extension FeedCoordinator: ArticleListVCDelegate {
    
    func sender(_ sender: ArticleListVC, didSelect article: MWFeedItem) {
        let articleVC = ArticleVC(article: article)
        articleVC.delegate = self
        presenter.pushViewController(articleVC, animated: true)
    }
    
}

extension FeedCoordinator: ArticleVCDelegate {
    
    func sender(_ sender: ArticleVC, didChangeBookmarkStateOf article: MWFeedItem) {
        article.isBookmarked ? bookmarkStore.remove(item: article) : bookmarkStore.insert(item: article)
    }
    
}
