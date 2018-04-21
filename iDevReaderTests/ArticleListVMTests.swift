//
//  ArticleListVMTests.swift
//  iDevReaderTests
//
//  Created by Nilson Nascimento on 4/20/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import XCTest
@testable import iDevReader

class ArticleListVMTests: XCTestCase {
    
    var vm: ArticleListVM!
    var bookmarkStore: BookmarkStore!
    
    override func setUp() {
        super.setUp()
        
        bookmarkStore = BookmarkStore()
        vm = ArticleListVM(bookmarkStore: bookmarkStore)
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    
}
