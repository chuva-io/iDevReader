//
//  ArticleCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/8/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser.MWFeedItem

protocol ArticleCoordinatorDelegate {
    func sender(_ sender: ArticleCoordinator, didChangeBookmarkStateOf article: MWFeedItem)    
}

class ArticleCoordinator: NSObject {
    
    let presenter: UINavigationController
    let bookmarkStore: BookmarkStore
    fileprivate let articleVC: WebVC
    let article: MWFeedItem
    
    var delegate: ArticleCoordinatorDelegate?
    
    init(article: MWFeedItem, bookmarkStore: BookmarkStore, presenter: UINavigationController) {
        self.article = article
        articleVC = WebVC(url: URL(string: article.link)!)
        articleVC.title = article.title

        self.presenter = presenter
        self.bookmarkStore = bookmarkStore
        
        super.init()
    }
    
    func start() {
        presenter.pushViewController(articleVC, animated: true)
        
        articleVC.navigationItem.largeTitleDisplayMode = .never
        articleVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: bookmarkButtonImage,
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(bookmarkButtonTapped))
    }
    
    fileprivate var bookmarkButtonImage: UIImage? {
        return article.isBookmarked ? UIImage(named: "bookmarkOn") : UIImage(named: "bookmarkOff")
    }
    
    @objc fileprivate func bookmarkButtonTapped(sender: UIBarButtonItem) {
        article.isBookmarked ? bookmarkStore.remove(item: article) : bookmarkStore.insert(item: article)
        sender.image = bookmarkButtonImage
        delegate?.sender(self, didChangeBookmarkStateOf: article)
    }
    
}
