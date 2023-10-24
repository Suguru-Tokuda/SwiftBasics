//: [Previous](@previous)

import Foundation

/*
 Extension
 
 will allow us to add more meaning/functionality to existing types or we can use them for protocol confirmance
 */

extension Int {
    func square() -> Int {
        return self * self
    }
    
    // varialbes need to be a Computed Varialbe
    var isNumberEven: Bool {
        return self % 2 == 0
    }
}

let i1: Int = 5
let result = i1.square()
print("Square - \(i1) is \(result)")

//extension String {
//    func myOwnPrint() -> {
//        
//    }
//}

class Temperature {
    var celcius: Double = 0
    
    func setTemperature(celcius: Double) {
        self.celcius = celcius
    }
}

// Can be used when you don't want to modify the originall class, struct, or enum.
// Open-closed principle: closed to modification but open extension
extension Temperature {
    func convertToFarhenhit() -> Double {
        var res = (celcius * 1.8) + 31
        return res
    }
}

let t1 = Temperature()
t1.setTemperature(celcius: 40)
print(t1.celcius)
print("Farhenhit: \(t1.convertToFarhenhit())")

extension Array {
    func randomizeSequence() {
        // logic
    }
}

let arr = [1, 2, 34, 4, 5]
arr.randomizeSequence()
