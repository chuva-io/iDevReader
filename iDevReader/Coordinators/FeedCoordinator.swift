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
    
    let feed: Feed
    let presenter: UINavigationController
    let bookmarkStore: BookmarkStore
    fileprivate var feedParser: MWFeedParser?
    
    fileprivate let articleListVC: ArticleListVC
    
    init(feed: Feed, bookmarkStore: BookmarkStore, presenter: UINavigationController) {
        articleListVC = ArticleListVC()

        self.feed = feed
        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.bookmarkStore = bookmarkStore
        
        super.init()
        articleListVC.delegate = self
    }
    
    func start() {
        presenter.pushViewController(articleListVC, animated: true)
        load(feed: feed)
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

extension FeedCoordinator: MWFeedParserDelegate {
    
    func feedParserDidStart(_ parser: MWFeedParser!) {
        print("\n\(#function)")
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        articleListVC.insert(item)
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        feedParser = nil
        print("")
    }
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print("\n\(#function)")
    }
    
}
