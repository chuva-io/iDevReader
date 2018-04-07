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
    
    enum Configuration {
        case normal, bookmarks
    }
    
    fileprivate static let cellIdentifier = "cell_identifier"
    
    fileprivate let parser: MWFeedParser?
    
    let feed: Feed?
    let configuration: Configuration
    var articles: [MWFeedItem] = []
    fileprivate var expandedIndexPaths: Set<IndexPath> = []
    
    fileprivate lazy var emptyView: EmptyState = {
        return EmptyState(frame: tableView.bounds)
    }()
    
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: ArticleListVC.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    init(feed: Feed) {
        self.feed = feed
        self.configuration = .normal
        self.parser = MWFeedParser(feedURL: feed.url)!
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(articles: [MWFeedItem] = [], configuration: Configuration = .normal) {
        self.articles = articles
        self.configuration = configuration
        self.parser = nil
        self.feed = nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser?.delegate = self
        parser?.connectionType = ConnectionTypeAsynchronously
        parser?.parse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if configuration == .bookmarks {
            articles = BookmarkStore().items
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Selectors

    @objc fileprivate func showMoreButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        guard let tap = event.touches(for: sender)?.first,
            let indexpath = tableView.indexPathForRow(at: tap.location(in: tableView)),
            let cell = tableView.cellForRow(at: indexpath) as? ArticleTableViewCell else {
                return
        }
        
        if expandedIndexPaths.contains(indexpath) { // collapse
            cell.descriptionLabel.numberOfLines = 4
            cell.showMoreButton.setTitle(ArticleTableViewCell.showMoreText, for: .normal)
            expandedIndexPaths.remove(indexpath)
        }
        else {  // expand
            cell.descriptionLabel.numberOfLines = 0
            cell.showMoreButton.setTitle(ArticleTableViewCell.showLessText, for: .normal)
            expandedIndexPaths.insert(indexpath)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexpath, at: .top, animated: true)
    }
    
}

extension ArticleListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        let articleVC = ArticleVC(article: article)
        articleVC.delegate = self
        
        if let navVC = navigationController,
            UIDevice.current.userInterfaceIdiom == .phone {
            navVC.pushViewController(articleVC, animated: true)
        }
        else {
            let navVC = UINavigationController(rootViewController: articleVC)
            articleVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                         target: self,
                                                                         action: #selector(dismissArticleVC))
            
            navVC.modalPresentationStyle = .pageSheet
            present(navVC, animated: true)
        }
    }
    
    @objc fileprivate func dismissArticleVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = (articles.count == 0) ? emptyView : nil
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListVC.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.descriptionLabel.text = article.summary.convertingHTMLToPlainText()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let dateString = formatter.string(from: article.date)
        
        cell.dateLabel.text = dateString
        cell.showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(_:forEvent:)), for: .touchUpInside)
        
        if expandedIndexPaths.contains(indexPath) { // collapse
            cell.descriptionLabel.numberOfLines = 0
            cell.showMoreButton.setTitle(ArticleTableViewCell.showLessText, for: .normal)
        }
        else {  // expand
            cell.descriptionLabel.numberOfLines = 4
            cell.showMoreButton.setTitle(ArticleTableViewCell.showMoreText, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return configuration == .bookmarks ? true : false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let store = BookmarkStore()
        let item = articles.remove(at: indexPath.row)
        store.remove(item: item)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  (articles.count == 0) ? nil : "Articles"
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

extension ArticleListVC: ArticleVCDelegate {
    func didChangeBookmarkState(of article: MWFeedItem) {
        let store = BookmarkStore()
        article.isBookmarked ? store.remove(item: article) : store.insert(item: article)
    }
}
