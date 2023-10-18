import UIKit

/**
    Assignment 1
    Suguru Tokuda
    10/18/2023
*/

// 1. Constants: After declaration, value cannot be changed
let fullName = "Suguru Tokuda"
// fullName = "Tokuda Suguru" // throws an error

// 2. Variables: Can assign values after declaration
var heightInCm = 173
heightInCm = 180

var animal = "Cat"
animal = "Dog"

// 3. Functions in Swift

// Function with no argument
func printFullName() -> String {
    return fullName
}

printFullName()

// Function with an argument
func getDateStr(date: Date) -> String {
    return date.formatted(date: .complete, time: .omitted)
}

print(getDateStr(date: Date()))

// Function with an external argument name
func printDateRange(from startDate: String, to endDate: String) -> Void {
    print("From \(startDate) to \(endDate)")
}

printDateRange(from: "Janunary 1st, 2023", to: "December 31st, 2023")

// Function with no argument names
func addNums(_ num1: Int, _ num2: Int) -> Int {
    return num1 + num2
}

print(addNums(1, 2))

// 4. Type inference
var age = 20 // Int
var pet = "Dog" // String
var floatNum = 1.12 // Float
var success = true // Boolean

// 5. Type Safety
// age = "30" // this line returns an error

// 6. Arrays
var names: [String] = ["Sarah", "Leo", "Mike"]
var numbers: [Int] = [1, 2, 3, 4, 5]

// 7. Tuples
var tuple1: (Int, String) = (30, "40")
var tuple2: (Bool, Float) = (true, 1.234)
var tuple3: (Double, Int) = (1234, Int.max)

// Assign a different value to a tuple
tuple3.1 = Int.min

