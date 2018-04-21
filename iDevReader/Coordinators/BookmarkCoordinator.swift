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
        articleListVC?.vm.set(articles: bookmarkStore.items)
    }
    
    init(bookmarkStore: BookmarkStore) {
        self.bookmarkStore = bookmarkStore
        let vm = ArticleListVM(articles: bookmarkStore.items, bookmarkStore: bookmarkStore)
        articleListVC = ArticleListVC(viewModel: vm, allowsEditing: true)
        articleListVC!.allowsExpansion = true
        articleListVC!.descriptionLineCount = 4
        articleListVC!.headerTitle = "Articles"
        rootVC = articleListVC!
        articleListVC!.vm.delegate = self
    }
    
}

extension BookmarkCoordinator: ArticleListVMDelegate {
    
    func sender(_ sender: ArticleListVM, set articles: [MWFeedItem]) {
        articleListVC?.reload()
    }
    
    func sender(_ sender: ArticleListVM, selected article: MWFeedItem) {
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
    
    func sender(_ sender: ArticleListVM, inserted article: MWFeedItem, at index: Int) {  }
    
    func sender(_ sender: ArticleListVM, deleted article: MWFeedItem, at index: Int) {
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
            guard let vm = articleListVC?.vm else { return }
            vm.insert(article, at: vm.articles.count)
        }
        // Remove bookmark
        else {
            guard let index = articleListVC?.vm.articles.index(where: { $0.identifier == article.identifier }) else {
                return
            }
            articleListVC?.vm.deleteItem(at: index)
        }
        
    }
    
}
