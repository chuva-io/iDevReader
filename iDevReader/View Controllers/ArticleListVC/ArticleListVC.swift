//
//  ArticleListVC.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/25/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import MWFeedParser
import SafariServices

class ArticleListVC: UIViewController {
    
    fileprivate static let cellIdentifier = "cell_identifier"
    
    fileprivate let parser: MWFeedParser
    
    let feed: Feed
    var articles: [MWFeedItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    init(feed: Feed) {
        self.feed = feed
        self.parser = MWFeedParser(feedURL: feed.url)!
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ArticleListVC.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        parser.delegate = self
        parser.connectionType = ConnectionTypeAsynchronously
        parser.parse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
    }
    
}

extension ArticleListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        
        let webVC = SFSafariViewController(url: URL(string: article.link)!)
        webVC.dismissButtonStyle = .close
        webVC.delegate = self
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(webVC, animated: true)
    }
}

extension ArticleListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListVC.cellIdentifier, for: indexPath)
        let article = articles[indexPath.row]
        
        cell.textLabel?.text = article.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Articles"
    }
    
}

extension ArticleListVC: MWFeedParserDelegate {
    
    func feedParserDidStart(_ parser: MWFeedParser!) {
        print("\n\(#function)")
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) { }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        articles.append(item)
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        print("\n\(#function)")
        
        tableView.reloadData()
    }
    
    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        print("\n\(#function)")
    }
    
}

extension ArticleListVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigationController?.popViewController(animated: true)
    }
}
