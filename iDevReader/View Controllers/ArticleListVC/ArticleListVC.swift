//
//  ArticleListVC.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/25/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

class ArticleListVC: UIViewController {
    
    fileprivate static let cellIdentifier = "cell_identifier"
    
    let vm: ArticleListVM
    let allowsEditing: Bool
    var headerTitle: String?
    var descriptionLineCount = 0
    var allowsExpansion = false
    
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
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        }
    }
    
    init(viewModel: ArticleListVM, allowsEditing: Bool = false) {
        self.vm = viewModel
        self.allowsEditing = allowsEditing
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func reload() {
        tableView.reloadData()
    }

    func insertItem(at index: Int) {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    func deleteItem(at index: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    //MARK: - Selectors

    @objc fileprivate func showMoreButtonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        guard let tap = event.touches(for: sender)?.first,
            let indexpath = tableView.indexPathForRow(at: tap.location(in: tableView)),
            let cell = tableView.cellForRow(at: indexpath) as? ArticleTableViewCell else {
                return
        }
        
        if expandedIndexPaths.contains(indexpath) {
            expandedIndexPaths.remove(indexpath)
        }
        else {
            expandedIndexPaths.insert(indexpath)
        }
        handleExpansion(for: cell, at: indexpath)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexpath, at: .top, animated: true)
    }
    
}

extension ArticleListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vm.selectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = (vm.articles.count == 0) ? emptyView : nil
        return vm.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListVC.cellIdentifier, for: indexPath) as! ArticleTableViewCell
        let article = vm.articles[indexPath.row]
        
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.descriptionLabel.text = article.summary.convertingHTMLToPlainText()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let dateString = formatter.string(from: article.date)
        
        cell.dateLabel.text = dateString
        
        handleExpansion(for: cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return allowsEditing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        vm.deleteItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  (vm.articles.count == 0) ? nil : headerTitle ?? nil
    }
    
}

extension ArticleListVC {
    fileprivate func handleExpansion(`for` cell: ArticleTableViewCell, at indexPath: IndexPath) {
        cell.descriptionLabel.numberOfLines = descriptionLineCount
        
        if allowsExpansion == true &&
            descriptionLineCount > 0 {
            
            if expandedIndexPaths.contains(indexPath) {
                // expand
                cell.descriptionLabel.numberOfLines = 0
                cell.showMoreButton.setTitle(ArticleTableViewCell.showLessText, for: .normal)
            }
            else {
                // collapse
                cell.showMoreButton.setTitle(ArticleTableViewCell.showMoreText, for: .normal)
                
                if cell.descriptionLabel.isTruncated {
                    cell.showMoreButton.setTitle(ArticleTableViewCell.showMoreText, for: .normal)
                    cell.showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(_:forEvent:)), for: .touchUpInside)
                    cell.showMoreButton.isHidden = false
                }
            }
            
        }
    }
}
