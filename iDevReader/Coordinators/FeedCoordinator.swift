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
    var articleCoordinator: ArticleCoordinator?  // retain for target-action
    
    init(feed: Feed, bookmarkStore: BookmarkStore, presenter: UINavigationController) {
        let vm = ArticleListVM(bookmarkStore: bookmarkStore)
        articleListVC = ArticleListVC(viewModel: vm)
        articleListVC.allowsExpansion = true
        articleListVC.descriptionLineCount = 4
        articleListVC.title = "Articles"
        
        self.feed = feed
        self.presenter = presenter
        self.presenter.navigationBar.prefersLargeTitles = true
        self.bookmarkStore = bookmarkStore
        
        super.init()
        vm.delegate = self
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

extension FeedCoordinator: ArticleListVMDelegate {
    
    func sender(_ sender: ArticleListVM, set articles: [MWFeedItem]) { }
    
    func sender(_ sender: ArticleListVM, inserted article: MWFeedItem, at index: Int) {
        articleListVC.insertItem(at: index)
    }
    
    func sender(_ sender: ArticleListVM, deleted article: MWFeedItem, at index: Int) { }
    
    func sender(_ sender: ArticleListVM, selected article: MWFeedItem) {
        articleCoordinator = ArticleCoordinator(article: article,
                                                bookmarkStore: bookmarkStore,
                                                presenter: presenter)
        articleCoordinator!.start()
    }
    
}

extension FeedCoordinator: MWFeedParserDelegate {
    
    func feedParserDidStart(_ parser: MWFeedParser!) {
        print("\n\(#function)")
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        articleListVC.vm.insert(item, at: articleListVC.vm.articles.count)
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        feedParser = nil
        print("")
    }
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print("\n\(#function)")
    }
    
}
