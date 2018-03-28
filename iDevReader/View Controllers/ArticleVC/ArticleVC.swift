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

class ArticleVC: UIViewController {

    let article: MWFeedItem
    
    @IBOutlet weak var webView: WKWebView!
    
    init(article: MWFeedItem) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Bookmark",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(bookmarkButtonTapped))
        
        webView.load(URLRequest(url: URL(string: article.link)!))
    }

    @objc func bookmarkButtonTapped() {
        let path = documentsDirectory.appendingPathComponent("bookmarks.data")
        
        var bookmarkedArticles = (NSKeyedUnarchiver.unarchiveObject(withFile: path.path) as? [MWFeedItem]) ?? []
        
        if let duplicateIndex = bookmarkedArticles.index(where: { $0.identifier == article.identifier }) {
            bookmarkedArticles.remove(at: duplicateIndex)
        }
        
        bookmarkedArticles.append(article)
        NSKeyedArchiver.archiveRootObject(bookmarkedArticles, toFile: path.path)
    }
    
    var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
}
