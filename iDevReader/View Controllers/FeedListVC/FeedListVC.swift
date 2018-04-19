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

    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "FeedTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: FeedListVC.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }

    let vm: FeedListVM

    init(viewModel: FeedListVM) {
        vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

}

extension FeedListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vm.selectItem(at: indexPath.row)
    }
}

extension FeedListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedListVC.cellIdentifier, for: indexPath) as! FeedTableViewCell
        
        let feed = vm.feeds[indexPath.row]

        cell.titleLabel.text = feed.title
        cell.authorLabel.text = feed.author
        cell.twitterButton.isHidden = feed.twitter == nil

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Feeds"
    }

}
