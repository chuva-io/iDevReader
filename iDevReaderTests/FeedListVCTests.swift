//
//  FeedListVCTests.swift
//  iDevReaderTests
//
//  Created by Nilson Nascimento on 4/17/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import XCTest
@testable import iDevReader

class FeedListVCTests: XCTestCase {

    var vc: FeedListVC!
    var feeds: [Feed]!
    
    var didSelectFeedCallbackValue: Feed?

    override func setUp() {
        super.setUp()

        let json = [["title": "title",
                    "author": "author",
                    "feed_url": "http://chuva.io",
                    "site_url": "http://chuva.io",
                    "twitter_url": "http://chuva.io"]]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        feeds = try! JSONDecoder().decode([Feed].self, from: data)

        vc = FeedListVC(feeds: feeds)
    }

    override func tearDown() {

        super.tearDown()
    }

    func testInitializer() {
        vc = FeedListVC(feeds: feeds)
        XCTAssertEqual(vc.feeds, feeds)
    }
    
    func testDidSelectDelegate() {
        vc.delegate = self
        vc.tableView(vc.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(didSelectFeedCallbackValue, feeds[0])
    }

}

extension FeedListVCTests: FeedListVCDelegate {
    
    func sender(_ sender: FeedListVC, didSelect feed: Feed) {
        didSelectFeedCallbackValue = feed
    }
    
}

extension Feed: Equatable {
    public static func ==(lhs: Feed, rhs: Feed) -> Bool {
        return lhs.title == rhs.title &&
            lhs.author == rhs.author &&
            lhs.url == rhs.url &&
            lhs.site == rhs.site &&
            lhs.twitter == rhs.twitter
    }


}
