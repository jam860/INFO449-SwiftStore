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

class ItemWeight: Item {
    var weight : Double;
    
    init(name: String, priceEach: Int, weight : Double) {
        self.weight = weight
        super.init(name: name, priceEach: priceEach)
    }
    
    override func price() -> Int {
        let price = Double(itemPrice) * weight
        let roundedPrice = price.rounded()
        return Int(roundedPrice)
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
    
//    func useCoupon(itemName : String, discount : Double) {
//        var newCoupon = Coupon(name: itemName, percentage: discount)
//    }
    
    func output() -> String {
        var receipt = "Receipt:\n"
        for item in allItems {
            receipt += "\(item.name): $\(Double(item.price())/100.00)\n"
        }
        receipt += "------------------\nTOTAL: $\(Double(priceTotal)/100.00)"
        return receipt
    }
}

//class Coupon {
//    var name : String;
//    var percentage : Double;
//    
//    init(name: String, percentage: Double) {
//        self.name = name
//        self.percentage = percentage
//    }
//}

class ThreeForTwoPricingScheme {
    var item: Item
    var quantity: Int
    
    init() {
        self.item = Item(name : "", priceEach: 0)
        self.quantity = 0
    }
    
    init(itemName: Item) {
        self.item = itemName
        self.quantity = 0
    }
    
    func getName() -> String {
       return item.name
    }
    
    func getQuantity() -> Int {
        return quantity
    }
    
    func setQuantity(num : Int) {
        self.quantity = num + self.quantity
    }
    
    func checkScheme(item: Item) -> Bool {
        if self.item.name == item.name {
                setQuantity(num: 1);
                if getQuantity() % 3 == 0 {
                    return true;
                }
        }
        return false;
    }
}

class GroupPricingScheme {
    var requiredItems: [Item]
    var currentItems: [Item]
    var discount: Double
    var flagCouponApplied : Bool
    
    init() {
        self.requiredItems = [];
        self.currentItems = [];
        discount = 0;
        self.flagCouponApplied = false;
    }
    
    init(requiredItems: [Item], discount: Double) {
        self.requiredItems = requiredItems
        self.currentItems = [];
        self.discount = discount
        self.flagCouponApplied = false;
    }
    
    func getRequiredItemNames() -> [String] {
        var newItemList : [String] = [];
        for item in requiredItems {
            newItemList.append(item.name);
        }
        return newItemList;
    }
    
    func applyGroupPricing() -> Bool {
        var currentRequiredItemsSet = Set<String>();
        var currentItemsSet = Set<String>();
        
        for item in requiredItems {
            currentRequiredItemsSet.insert(item.name)
        }
        
        for item in self.currentItems {
            currentItemsSet.insert(item.name);
        }
        
        
        if currentRequiredItemsSet.count == currentItemsSet.count && currentRequiredItemsSet == currentItemsSet {
            return true
        } else {
            return false;
        }
    }
    
    
}


class Register {
    var receipt = Receipt();
    var threeForTwoPricing : ThreeForTwoPricingScheme;
    var groupPricing : GroupPricingScheme;
    var flagGroupPricing : Bool;
    var currentTotal : Int;
    
    init() {
        currentTotal = 0;
        threeForTwoPricing = ThreeForTwoPricingScheme();
        groupPricing = GroupPricingScheme();
        flagGroupPricing = false;
    }
    
    func newThreeforTwoPricingScheme(itemName: Item) {
        threeForTwoPricing = ThreeForTwoPricingScheme(itemName: itemName)
    }
    
    func newGroupPricing(itemNames: [Item], discount: Double) {
        groupPricing = GroupPricingScheme(requiredItems: itemNames, discount: discount);
    }
    
    func scan(_ SKU : Item) {
        currentTotal += SKU.price()
        receipt.allItems.append(SKU);
        if groupPricing.requiredItems.count > 0 {
            groupPricing.currentItems.append(SKU);
        }
        
        if threeForTwoPricing.getName() != "" && threeForTwoPricing.checkScheme(item: SKU) {
            currentTotal -= SKU.itemPrice;
            SKU.itemPrice = 0;
        }
        
        //Check Grouping scheme if available, only allow 1 at a time because store policy
        if groupPricing.getRequiredItemNames().contains(SKU.name) && flagGroupPricing == false {
            groupPricing.requiredItems.append(SKU)
            if groupPricing.applyGroupPricing() {
                for i in 0...receipt.allItems.count - 1 {
                    if groupPricing.getRequiredItemNames().contains(receipt.allItems[i].name) {
                        let discountedPrice = Double(receipt.allItems[i].itemPrice) * groupPricing.discount;
                        currentTotal = currentTotal - Int(discountedPrice.rounded())
                        receipt.allItems[i].itemPrice = (Int(Double(receipt.allItems[i].itemPrice) - discountedPrice))
                    }
                }
                flagGroupPricing = true;
            }
        } else if groupPricing.getRequiredItemNames().contains(SKU.name) && flagGroupPricing {
            let discountedPrice = Double(SKU.itemPrice) * Double(groupPricing.discount);
            SKU.itemPrice = Int((Double(SKU.itemPrice) - discountedPrice).rounded());
            currentTotal = currentTotal - Int(discountedPrice.rounded())
        }
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

