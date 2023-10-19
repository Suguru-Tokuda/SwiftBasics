//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)
var name: String = "abc"
var num = 10



/* OPTIONAL - there can be or cannot be a value for that variable. Absense of value. Value or it can be nil
 */

var someName: String?
var n1: Double?

print(someName)
print(n1)

// Unwrapping optinals
// 1. if let
// 2. guard let
// 3. ?? Coalescing operator
// 4. ! Force unwrap

// 1. if let
if let newName = someName {
    print(newName)
}

// 2. guard let
func checkingGuardLetUse() {
    guard let newValue = someName else { return }
    print(newValue)
}

checkingGuardLetUse()

// 3. Coalescing
print(newValue ?? "Default value")

// 4. Force unwrap - use it only when you're 100% sure there is a value.
//print(someName!)
