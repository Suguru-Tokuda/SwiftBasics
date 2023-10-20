//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

// for loop
let numbers: [Int] = [1, 2, 3, 4, 5, 6, 7]

for val in numbers {
    print(val)
}

for (i, val) in numbers.enumerated() {
    print("\(i): \(val)")
}

for i in 0..<10 {
    print(i)
}

for i in stride(from: 0, to: 10, by: 2) {
    print(i)
}

let dictionary = ["a" : 1, "b" : 2, "c" : 3]

for (key, val) in dictionary {
    print("key: \(key), val: \(val)")
}

// 2. White loop
var num = 5
while num < 10 {
    print(num)
    num += 1
}

// 3. repeat whiel
repeat {
    print(num)
    num += 1
} while num < 20
