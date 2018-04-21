//
//  ArticleListVM.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/20/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import MWFeedParser.MWFeedItem

protocol ArticleListVMDelegate: class {
    func sender(_ sender: ArticleListVM, set articles: [MWFeedItem])
    func sender(_ sender: ArticleListVM, selected article: MWFeedItem)
    func sender(_ sender: ArticleListVM, deleted article: MWFeedItem, at index: Int)
    func sender(_ sender: ArticleListVM, inserted article: MWFeedItem, at index: Int)
}

class ArticleListVM {
    
    private(set) var articles: [MWFeedItem]
    let bookmarkStore: BookmarkStore
    weak var delegate: ArticleListVMDelegate?
    
    init(articles: [MWFeedItem] = [], bookmarkStore: BookmarkStore) {
        self.articles = articles
        self.bookmarkStore = bookmarkStore
        delegate?.sender(self, set: articles)
    }
    
    func set(articles: [MWFeedItem]) {
        self.articles = articles
        delegate?.sender(self, set: articles)
    }
    
    func insert(_ article: MWFeedItem, at index: Int) {
        articles.insert(article, at: index)
        delegate?.sender(self, inserted: article, at: index)
    }
    
    func deleteItem(at index: Int) {
        let deleted = articles.remove(at: index)
        delegate?.sender(self, deleted: deleted, at: index)
    }
    
    func selectItem(at index: Int) {
        delegate?.sender(self, selected: articles[index])
    }
    
}
