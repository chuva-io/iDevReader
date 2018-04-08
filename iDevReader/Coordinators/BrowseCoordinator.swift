//
//  BrowseCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

class BrowseCoordinator {
    
    let presenter: UINavigationController
    
    fileprivate let bookmarkStore = BookmarkStore()
    
    init(presenter: UINavigationController) {
        let vc = CategoryListVC()
        vc.title = "Categories"
        
        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.presenter.pushViewController(vc, animated: false)
        
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
        let articleListVC = ArticleListVC()
        articleListVC.delegate = self
        articleListVC.title = feed.author
        articleListVC.load(feed: feed)
        presenter.pushViewController(articleListVC, animated: true)
    }
    
}

extension BrowseCoordinator: ArticleListVCDelegate {
    
    func sender(_ sender: ArticleListVC, didSelect article: MWFeedItem) {
        let articleVC = ArticleVC(article: article)
        articleVC.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let navVC = UINavigationController(rootViewController: articleVC)
            articleVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                         target: self,
                                                                         action: #selector(dismissArticleVC))
            
            navVC.modalPresentationStyle = .pageSheet
            presenter.present(navVC, animated: true)
        }
        else {
            presenter.pushViewController(articleVC, animated: true)
        }
    }
    
    @objc fileprivate func dismissArticleVC() {
        presenter.dismiss(animated: true, completion: nil)
    }
    
}

extension BrowseCoordinator: ArticleVCDelegate {

    func sender(_ sender: ArticleVC, didChangeBookmarkStateOf article: MWFeedItem) {
        article.isBookmarked ? bookmarkStore.remove(item: article) : bookmarkStore.insert(item: article)
    }
    
}
