//: [Previous](@previous)

import Foundation

/*
    Dependency Injections
 */

protocol Transferable {
    var balance: Int { get set }
    func depositAmount(amt: Int)
    func withdrawAmount(amt: Int) -> Int
}

//extension Transferable {
//    lazy var getCurrentBalance = {
//        return 0
//    }()
//}

class BankSystem : Transferable {
    var balance: Int = 0
    
    func depositAmount(amt: Int) {
        balance += amt
    }
    
    func withdrawAmount(amt: Int) -> Int {
        if balance > 0 {
            return 0
        } else {
            balance -= amt
            return amt
        }
    }
}
