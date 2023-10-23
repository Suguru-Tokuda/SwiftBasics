//: [Previous](@previous)

import Foundation

/*
 Generics
 */

//func doSumOfTwoNums(n1: Int, n2: Int) -> Int {
//    let res = n1 + n2
//    print("res = \(res)")
//    return res
//}
//
//doSumOfTwoNums(n1: 2, n2: 3)
//
//func doSumOfTwoNums(n1: Double, n2: Double) -> Double {
//    let res = n1 + n2
//    print("Double res = \(res)")
//    return res
//}
//
//doSumOfTwoNums(n1: 2.2, n2: 3.3)

// Allows the caller to pass either Int, Double, Float or other Numeric types.
func doSumOfTwoNums<T: Numeric>(n1: T, n2: T) -> T {
    let res = n1 + n2
    print("Generic res = \(res)")
    return res
}

doSumOfTwoNums(n1: 10, n2: 20)
doSumOfTwoNums(n1: 100.1, n2: 50.1)

// Generics basic use
// Use of Extension
// Use of Protocols
// Type of Properties
