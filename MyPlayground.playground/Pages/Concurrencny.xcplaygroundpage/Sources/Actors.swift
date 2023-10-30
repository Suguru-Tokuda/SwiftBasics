import Foundation

/*
 Actor - iOS 13, 2019, Swift 5.5
 Reference type
 Class - properties, functions, initializers, deinitializers, inheritance, reference type
 Struct - properties, functions, initializers, deinitializers, value type
 Actors - properties, functions, initializers, deinitializers, reference type, does not support inheritance
 Actors will guarantee that it's properties and variables are modified one at a time.
 It is equivalent that that modifying of the properties happen with serial queue.
 They avoid race condition.
 They are reference types.
 Supports Generic
*/

actor BankDetails {
    var balance: Double
    
    init(balance: Double) {
        self.balance = balance
    }

    func deposit(amount: Double) {
        
    }
    
    func withDrawAmt(amt: Double) {
        
    }
}

// Actor types do not support inheritance
//actor CurrentBankDetails : BankDetails {
//}

func actors() {
    let bankDetails = BankDetails(balance: 0.0)
}
