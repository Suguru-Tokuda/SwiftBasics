import UIKit

var greeting = "Hello, playground"

/*
 early 1980-1983- NextStep Computer
 NeXT's operating system- Objective C,
 
 Objective C- Brad Cox
 1997 -Apple - NextStep
 
 MacOS
 iOS 29 June 2007, iPhone OS-1
 2007-2014- Obj C C, C++ OOPS (abstraction, encapsulation, polymorphism, inheritence)
 
 Objective-C conventions
 ;
 []
 
 2014- Swift
 UIKit
 2019- SwiftUI
 
 Languages
 ObjC
 Swift
 
 UIFramework
 
 iOS 17
 WWDC
 */

// Single line commen
/* Multiline comment */
print("Hello World")

var name = "Suguru"
var age = 36
let gender = "Male"
var EmployeeID = 100

print(EmployeeID)

// Data types
var lastNaem: String = "Tokuda" // String
var rollNo: Int = 101 // Int
var num: Float = 11.2 // Float
var number: Double = 12345.11 // Double
var isCorrect: Bool = false // Boolean

var value = false // type inferencing
// name = 12345 // type safety

// Swift automatically selects a lower data type than higher to save memory

// ARC - automatic reference counting (memory management)

// Functions - methods (actions)

// definition
// 1. Simple function without any arguments or return type
func doAdition() {
    print("doing Maths")
}

// call a function
doAdition()

// 2. Func taking some parameters
func doSum(num1: Int, num2: Int) {
    let result = num1 + num2
    print(result)
}

doSum(num1: 2, num2: 2)

// 3. Returning values from function
func doSubstraction(n1: Int, n2: Int) -> Int {
    let res = n1 - n2
    return res
}

let ans = doSubstraction(n1: 100, n2: 25)

print(ans)

// use String cast when returning a value
func doSomeTask(name: String, age: Int, gender: Bool) -> String {
    return name + String(age) + String(gender)
}

let r1 = doSomeTask(name: "Swift", age: 9, gender: true)
print(r1)

var sal = 10.1

// use \() when printing/formatting string
print("result is \(r1) \(sal)")

// Tuple
let tupleExample = (1, "A", true)
func taskWhichReturnMultiplThings() -> (Int, String) {
    return (10, "ABC")
}


// Collections
// Array
// Dictionary
// Set

var arrayOfStrings = ["A", "B", "C"]
print(arrayOfStrings)
print(arrayOfStrings.first)

// does not create a new pointer for a duplication
var arrayOfInt = [1, 2, 3, 4, 5, 6]
arrayOfInt.append(7)

var collection: [Any] = [11, "c", false]
