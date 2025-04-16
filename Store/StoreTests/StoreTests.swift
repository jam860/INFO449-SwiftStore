//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //extra credit tests
    
    func testOneWeightItem() {
        register.scan(ItemWeight(name: "Wagyu Beef", priceEach: 1899, weight: 2.0))
        XCTAssertEqual(3798, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(3798, receipt.total())
        let expectedReceipt = """
Receipt:
Wagyu Beef: $37.98
------------------
TOTAL: $37.98
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testTwoWeightItem() {
        register.scan(ItemWeight(name: "Wagyu Beef", priceEach: 1899, weight: 2.0))
        register.scan(ItemWeight(name: "Bananas", priceEach: 99, weight: 1.2))
        XCTAssertEqual(3917, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(3917, receipt.total())
        let expectedReceipt = """
Receipt:
Wagyu Beef: $37.98
Bananas: $1.19
------------------
TOTAL: $39.17
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeForTwo() {
        register.newThreeforTwoPricingScheme(itemName: Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(398, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(398, receipt.total())
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $0.0
------------------
TOTAL: $3.98
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeForTwoMoreItems() {
        register.newThreeforTwoPricingScheme(itemName: Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))

        XCTAssertEqual(796, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(796, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $0.0
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
------------------
TOTAL: $7.96
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeForTwoTwoTimes() {
        register.newThreeforTwoPricingScheme(itemName: Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(796, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(796, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $0.0
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $0.0
------------------
TOTAL: $7.96
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testGroupsOfThree() {
        let item1 = Item(name: "Beans", priceEach: 199)
        let item2 = Item(name: "Fries", priceEach: 299)
        let item3 = Item(name: "Ice Cream", priceEach: 499)
        let items = [item1, item2, item3];
        
        register.newGroupPricing(itemNames: items, discount: 0.10)
        register.scan(Item(name: "Beans", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Fries", priceEach: 299))
        XCTAssertEqual(498, register.subtotal()) //nothing should be discounted yet

        
        register.scan(Item(name: "Ice Cream", priceEach: 499))
        XCTAssertEqual(897, register.subtotal()) //everything should be discounted now
        
        register.scan(Item(name: "Ice Cream", priceEach: 499))
        XCTAssertEqual(1346, register.subtotal()) //still should be discounted
        
        register.scan(Item(name: "Ryuji Sakamoto", priceEach: 999))
        XCTAssertEqual(2345, register.subtotal()) //this should not be discounted
        

        let receipt = register.total()
        XCTAssertEqual(2345, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans: $1.79
Fries: $2.69
Ice Cream: $4.49
Ice Cream: $4.49
Ryuji Sakamoto: $9.99
------------------
TOTAL: $23.45
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    
}
