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
    
    fileprivate let bookmarkStore = BookmarkStore()
    fileprivate var feedParser: MWFeedParser?
    fileprivate var articleListVC: ArticleListVC?
    
    init(presenter: UINavigationController) {
        let vc = CategoryListVC()
        vc.title = "Categories"
        
        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.presenter.pushViewController(vc, animated: false)
        
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
        articleListVC = ArticleListVC()
        articleListVC!.delegate = self
        articleListVC!.title = feed.author
        load(feed: feed)
        presenter.pushViewController(articleListVC!, animated: true)
    }
    
    fileprivate func load(feed: Feed) {
        if let parser = feedParser,
            parser.isParsing == true {
            parser.stopParsing()
        }
        
        feedParser = MWFeedParser(feedURL: feed.url)!
        feedParser!.delegate = self
        feedParser!.connectionType = ConnectionTypeAsynchronously
        feedParser!.parse()
    }
    
}

extension BrowseCoordinator: MWFeedParserDelegate {
    
    func feedParserDidStart(_ parser: MWFeedParser!) {
        print("\n\(#function)")
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        articleListVC?.insert(item)
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        feedParser = nil
        print("")
    }
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print("\n\(#function)")
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
