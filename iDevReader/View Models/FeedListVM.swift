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
    
    var delegate: FeedListVMDelegate?

    let feeds: [Feed]
    
    init(feeds: [Feed]) {
        self.feeds = feeds
    }
    
    func selectItem(at index: Int) {
        delegate?.sender(self, didSelect: feeds[index])
    }
    
}
