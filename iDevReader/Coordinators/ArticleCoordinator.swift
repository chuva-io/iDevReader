//
//  ArticleCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

class ArticleCoordinator: NSObject {
    
    let presenter: UINavigationController
    let bookmarkStore: BookmarkStore
    
    init(article: MWFeedItem, bookmarkStore: BookmarkStore, presenter: UINavigationController) {
        let articleVC = ArticleVC(article: article)
        articleVC.title = article.title
        
        self.presenter = presenter
        self.presenter.pushViewController(articleVC, animated: true)
        self.bookmarkStore = bookmarkStore
        
        super.init()
        articleVC.delegate = self
    }
    
}

extension ArticleCoordinator: ArticleVCDelegate {
    
    func sender(_ sender: ArticleVC, didChangeBookmarkStateOf article: MWFeedItem) {
        article.isBookmarked ? bookmarkStore.remove(item: article) : bookmarkStore.insert(item: article)
    }
    
}


