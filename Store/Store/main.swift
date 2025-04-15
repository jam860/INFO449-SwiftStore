//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name : String { get }
    func price() -> Int
}

class Item : SKU {
    var itemPrice : Int
    var name : String
    
    init(name : String, priceEach : Int) {
        self.name = name;
        self.itemPrice = priceEach;
    }
    
    func price() -> Int {
        return itemPrice;
    }
}

class Receipt {
    var allItems : [Item]
    var priceTotal : Int
    
    init() {
        self.allItems = []
        self.priceTotal = 0;
    }
    
    init(items: [Item], total: Int) {
        self.allItems = items
        self.priceTotal = total
    }
    
    func items() -> [Item] {
        return allItems;
    }
    
    func total() -> Int {
        return priceTotal;
    }
    
    func output() -> String {
        var receipt = "Receipt:\n"
        for item in allItems {
            receipt += "\(item.name): $\(Double(item.price())/100.00)\n"
        }
        receipt += "------------------\nTOTAL: $\(Double(priceTotal)/100.00)"
        return receipt
    }
}

class Register {
    var receipt = Receipt();
    var currentTotal : Int;
    
    init() {
        currentTotal = 0;
    }
    
    func scan(_ SKU : Item) {
        currentTotal += SKU.price()
        receipt.allItems.append(SKU);
    }
    
    func subtotal() -> Int {
        return currentTotal;
    }
    
    func total() -> Receipt {
        receipt.priceTotal = currentTotal;
        currentTotal = 0;
        let saveReceipt = receipt;
        receipt = Receipt();
        return saveReceipt;
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

