//
//  CategoryListVC.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/25/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class CategoryListVC: UIViewController {
    
    fileprivate static let cellIdentifier = "cell_identifier"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: CategoryListVC.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Categories"
        
        URLSession.shared.dataTask(with: URL(string: "https://raw.githubusercontent.com/daveverwer/iOSDevDirectory/master/content.json")!) { data, response, error in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]],
                let english = json.first(where: { item in
                    guard let language = item["language"] as? String else { return false }
                    return language == "en"
                }) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.categories = (try? JSONDecoder().decode([Category].self, from: JSONSerialization.data(withJSONObject: english["categories"] as Any, options: []))) ?? []
            }
            }.resume()
    }

}

extension CategoryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let feeds = categories[indexPath.row].feeds
        let feedsVC = FeedListVC(feeds: feeds)
        feedsVC.title = categories[indexPath.row].title
        navigationController?.pushViewController(feedsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListVC.cellIdentifier, for: indexPath) as! CategoryTableViewCell
        let category = categories[indexPath.row]

        cell.titleLabel.text = category.title
        cell.descriptionLabel.text = category.description
        
        return cell
    }
}
