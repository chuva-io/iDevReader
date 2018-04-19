//
//  FeedListVM.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/18/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

protocol FeedListVMDelegate {
    func sender(_ sender: FeedListVM, didSelect feed: Feed)
}

class FeedListVM {
    
    // Inputs
    let feeds: [Feed]
    func selectItem(at index: Int) {
        let selected = feeds[index]
        selectedFeed = selected
        delegate?.sender(self, didSelect: selected)
    }
    
    // Outputs
    private(set) var selectedFeed: Feed?
    
    var delegate: FeedListVMDelegate?
    
    init(feeds: [Feed]) {
        self.feeds = feeds
    }
    
}
