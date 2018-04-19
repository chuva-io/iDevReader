//
//  FeedListVMTests.swift
//  iDevReaderTests
//
//  Created by Nilson Nascimento on 4/17/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import XCTest
@testable import iDevReader

class FeedListVMTests: XCTestCase {

    var vm: FeedListVM!
    var feeds: [Feed]!

    override func setUp() {
        super.setUp()

        let json = [["title": "title",
                     "author": "author",
                     "feed_url": "http://chuva.io",
                     "site_url": "http://chuva.io",
                     "twitter_url": "http://chuva.io"],
                    ["title": "title2",
                     "author": "author2",
                     "feed_url": "http://chuva.io",
                     "site_url": "http://chuva.io"]]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        feeds = try! JSONDecoder().decode([Feed].self, from: data)

        vm = FeedListVM(feeds: feeds)
    }

    override func tearDown() {

        super.tearDown()
    }

    func testInitializer() {
        vm = FeedListVM(feeds: feeds)
        XCTAssertEqual(vm.feeds, feeds)
    }
    
    func testItemSelection() {
        XCTAssertNil(vm.selectedFeed)
        
        vm.selectItem(at: 0)
        XCTAssertEqual(vm.selectedFeed, feeds[0])
        
        vm.selectItem(at: 1)
        XCTAssertEqual(vm.selectedFeed, feeds[1])
    }

}
