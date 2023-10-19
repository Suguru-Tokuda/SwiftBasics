//: [Previous](@previous)

import Foundation

// Set - is unsorted collection of unique elements.
// it is similar to an array
// no duplicate elements

var fruitCollection: Set<String> = ["Apple", "Banana", "Orange"]

// O(1)
fruitCollection.insert("New Element")
// O(1)
fruitCollection.remove("Orange")

if fruitCollection.contains("Banana") {
    print("Banana is present")
}

var numbers: Set = [1, 2, 3, 4]
var emptySet = Set<String>()
var emptySet2: Set<String> = []

// Dictionary - it's a collection of Key value pairs
// key needs to be unique
var scores: [String : Int] = ["Adam": 1, "Bob": 2, "Charles": 3]

// access values
print(scores["Bob"])
print(scores["Charles"])

scores["Adam"] = 12

// removing a value for particular key
scores["adam"]

// Overloading is not possible in Swift
