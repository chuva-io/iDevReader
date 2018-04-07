//
//  BookmarkCoordinator.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/6/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit

struct BookmarkCoordinator {
    let rootVC: UIViewController
    
    init() {
        let store = BookmarkStore()
        rootVC = ArticleListVC(articles: store.items, configuration: .bookmarks)
    }
    
}
