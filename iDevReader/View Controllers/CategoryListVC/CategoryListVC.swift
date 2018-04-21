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
    
    let vm: CategoryListVM
    
    init(viewModel: CategoryListVM) {
        vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: CategoryListVC.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.loadCategories { [unowned self] in
            self.tableView.reloadData()
        }
    }

}

extension CategoryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vm.selectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListVC.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        let category = vm.categories[indexPath.row]

        cell.titleLabel.text = category.title
        cell.descriptionLabel.text = category.description
        
        return cell
    }
}
