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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoryListVC.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        URLSession.shared.dataTask(with: URL(string: "https://raw.githubusercontent.com/daveverwer/iOSDevDirectory/master/content.json")!) { data, response, error in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]],
                let english = json.first(where: { item in
                    guard let language = item["language"] as? String else { return false }
                    return language == "en"
                }) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.categories = (try? JSONDecoder().decode([Category].self, from: JSONSerialization.data(withJSONObject: english["categories"], options: []))) ?? []
            }
            }.resume()
    }

}

extension CategoryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let feeds = categories[indexPath.row].feeds
        let feedsVC = FeedListVC(feeds: feeds)
        navigationController?.pushViewController(feedsVC, animated: true)
    }
}

extension CategoryListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListVC.cellIdentifier, for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.title
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    
}
