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
    let bookmarkStore: BookmarkStore
    
    fileprivate var articleListVC: ArticleListVC?
    fileprivate var articleCoordinator: ArticleCoordinator? // retain for target-action
    
    func updateBookmarks() {
        articleListVC?.set(articles: bookmarkStore.items)
    }
    
    init(bookmarkStore: BookmarkStore) {
        self.bookmarkStore = bookmarkStore
        self.articleListVC = ArticleListVC(articles: bookmarkStore.items, allowsEditing: true)
        self.rootVC = articleListVC!
        self.articleListVC!.delegate = self
    }
    
}

extension BookmarkCoordinator: ArticleListVCDelegate {
    
    func sender(_ sender: ArticleListVC, didSelect article: MWFeedItem) {
        let navController = UINavigationController()
        articleCoordinator = ArticleCoordinator(article: article, bookmarkStore: bookmarkStore, presenter: navController)
        articleCoordinator!.delegate = self
        articleCoordinator!.start()
        
        navController
            .viewControllers[0]
            .navigationItem
            .leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                 target: self,
                                                 action: #selector(dismissArticleCoordinator))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            articleCoordinator!.presenter.modalPresentationStyle = .pageSheet
        }
        
        rootVC.present(navController, animated: true)
    }
    
    func sender(_ sender: ArticleListVC, didDelete article: MWFeedItem) {
        bookmarkStore.remove(item: article)
    }
    
    @objc fileprivate func dismissArticleCoordinator() {
        rootVC.dismiss(animated: true, completion: nil)
    }
    
}

extension BookmarkCoordinator: ArticleCoordinatorDelegate {
    
    func sender(_ sender: ArticleCoordinator, didChangeBookmarkStateOf article: MWFeedItem) {
        // Add bookmark
        if article.isBookmarked {
            articleListVC?.insert(article)
        }
        // Remove bookmark
        else {
            guard let index = articleListVC?.articles.index(where: { $0.identifier == article.identifier }) else {
                return
            }
            articleListVC?.delete(article, at: index)
        }
        
    }
    
}
