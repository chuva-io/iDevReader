//
//  CategoryListVMTests.swift
//  iDevReaderTests
//
//  Created by Nilson Nascimento on 4/18/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import XCTest
@testable import iDevReader

class CategoryListVMTests: XCTestCase {
    
    var vm: CategoryListVM!
    
    override func setUp() {
        super.setUp()

        vm = CategoryListVM()
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testLoadCategories() {
        XCTAssert(vm.categories.count == 0)
        
        let promise = expectation(description: "expected completion")
        vm.loadCategories {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(vm.categories.count > 0)
    }
    
}
