//
//  BookmarkCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

class BookmarkCoordinator {
    let rootVC: UIViewController
    let bookmarkStore = BookmarkStore()
    
    init() {
        let articleListVC = ArticleListVC(articles: bookmarkStore.items, allowsEditing: true)
        rootVC = articleListVC
        articleListVC.delegate = self
    }
    
}

extension BookmarkCoordinator: ArticleListVCDelegate {
    
    func sender(_ sender: ArticleListVC, didSelect article: MWFeedItem) {
        let articleVC = ArticleVC(article: article)
        articleVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: articleVC)
        articleVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                     target: self,
                                                                     action: #selector(dismissArticleVC))
        if UIDevice.current.userInterfaceIdiom == .pad {
            navVC.modalPresentationStyle = .pageSheet
        }
        rootVC.present(navVC, animated: true)
    }
    
    func sender(_ sender: ArticleListVC, didDelete article: MWFeedItem) {
        bookmarkStore.remove(item: article)
    }
    
    @objc fileprivate func dismissArticleVC() {
        rootVC.dismiss(animated: true, completion: nil)
    }
    
}

extension BookmarkCoordinator: ArticleVCDelegate {
    
    func sender(_ sender: ArticleVC, didChangeBookmarkStateOf article: MWFeedItem) {
        article.isBookmarked ? bookmarkStore.remove(item: article) : bookmarkStore.insert(item: article)
    }
    
}
