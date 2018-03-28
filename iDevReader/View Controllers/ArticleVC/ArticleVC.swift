//
//  ArticleVC.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/27/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import WebKit
import MWFeedParser.MWFeedItem

protocol ArticleVCDelegate {
    func didChangeBookmarkState(of article: MWFeedItem)
}

class ArticleVC: UIViewController {
    
    var delegate: ArticleVCDelegate?

    let article: MWFeedItem
    
    @IBOutlet fileprivate weak var webView: WKWebView!
    
    init(article: MWFeedItem) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: bookmarkButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(bookmarkButtonTapped))
        
        webView.load(URLRequest(url: URL(string: article.link)!))
    }
    
    fileprivate var bookmarkButtonTitle: String {
        return article.isBookmarked ? "Remove" : "Bookmark"
    }

    @objc fileprivate func bookmarkButtonTapped() {
        delegate?.didChangeBookmarkState(of: article)
        navigationItem.rightBarButtonItem?.title = bookmarkButtonTitle
    }
    
}
