//: [Previous](@previous)

import Foundation

// 1. if
var isCorrect = true

if isCorrect {
    print("This is a correct statement")
}

// 2. if else
var num = 5

if num < 10 {
    print("num is smaller than 10")
} else {
    print("num is not smaller than 10")
}

// 3. if... else if .... else
if num > 5 {
    print("number is greater than 5")
} else if num < 10 {
    print("number is less than 10")
} else {
    print("number doesn't fit into the condition")
}

var number: Double? = 20

// if let shorthanded
if let number {
    print(number)
}
