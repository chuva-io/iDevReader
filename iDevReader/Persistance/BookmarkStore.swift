//
//  BookmarkStore.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/28/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation
import MWFeedParser.MWFeedItem

extension FileManager {
    var documentsDirectory: URL {
        return urls(for: .documentDirectory, in: .userDomainMask).last!
    }
}

extension MWFeedItem {
    var isBookmarked: Bool {
        let store = BookmarkStore()
        return store.items.first(where: { $0.identifier == identifier }) != nil
    }
}

struct BookmarkStore {
 
    fileprivate let path = FileManager.default.documentsDirectory.appendingPathComponent("bookmarks.data")
    
    var items: [MWFeedItem] {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: path.path) as? [MWFeedItem]) ?? []
    }
    
    func insert(item: MWFeedItem) {
        var bookmarks = items
        if let duplicateIndex = bookmarks.index(where: { $0.identifier == item.identifier }) {
            bookmarks.remove(at: duplicateIndex)
        }
        
        bookmarks.append(item)
        NSKeyedArchiver.archiveRootObject(bookmarks, toFile: path.path)
    }
    
    func remove(item: MWFeedItem) {
        var bookmarks = items
        if let foundIndex = bookmarks.index(where: { $0.identifier == item.identifier }) {
            bookmarks.remove(at: foundIndex)
            NSKeyedArchiver.archiveRootObject(bookmarks, toFile: path.path)
        }
    }

}
