//
//  FeedListVC.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/25/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class FeedListVC: UIViewController {

    fileprivate static let cellIdentifier = "cell_identifier"

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "FeedTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: FeedListVC.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    let feeds: [Feed]

    init(feeds: [Feed]) {
        self.feeds = feeds

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

}

extension FeedListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let feed = feeds[indexPath.row]
        let articleListVC = ArticleListVC(feed: feed)
        navigationController?.pushViewController(articleListVC, animated: true)
        
    }
}

extension FeedListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedListVC.cellIdentifier, for: indexPath) as! FeedTableViewCell
        let feed = feeds[indexPath.row]

        cell.titleLabel.text = feed.title
        cell.authorLabel.text = feed.author
        cell.twitterButton.isHidden = feed.twitter == nil

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Feeds"
    }

}
