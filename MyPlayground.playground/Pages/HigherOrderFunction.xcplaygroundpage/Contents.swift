//: [Previous](@previous)

import Foundation

/*
    Higher Order Functions:
    These are functions that take other function as a parameter and/or returns functions or collection as result.
 */

// MARK: Map
// 1. Map - takes a collection and applies a function to each element. Returns a new collection with results.
let numbers = [1, 2, 3, 4, 5, 6, 7]
var res = [Int]()

for num in numbers { res.append(num * num) }

// Using closure
let squares = numbers.map { num in
    return num * num
}

// Short handed
let squares2 = numbers.map { $0 * $0 }

// MARK: Filter
// 2. Filter - takes a collection and applies a function and return a boolean value
let evenNumber = numbers.filter { $0 % 2 == 0 }
print(evenNumber)

// MARK: Reduce
// 3. Reduce - takes a collection and applies a operation to the sum
let totalOfAllNums = numbers.reduce(100, +)
print("totalOfAllNums - \(totalOfAllNums)")

// MARK: Sort
// 4. Sort
let unsortedNumbers = [234, 11, 2, 100, 25, 79, 1234135, 8, 1, 4]
let sortedNumbers = unsortedNumbers.sorted(by: { $0 < $1 })
print(sortedNumbers)

// MARK: FlatMap
// 5. FlatMap
let someWords = ["hello", "swift", "word"]
let wordsResult = someWords.flatMap { $0 }
print(wordsResult)

let duplicatedNilArray = [[1,2,3], [4,5,6], [7,8,9]]
print(duplicatedNilArray.flatMap { $0 })

// MARK: CompactMap
// 6. CompactMap - flattens multi dimensional arrays
let matrix = [[1,2,3], nil, [4,5,6], [7,8,9]]
print(matrix.compactMap { $0 })

// MARK: ForEach
numbers.forEach { print($0) }

// MARK: Zip
let chars = ["a", "b", "c"]
let pairs = Array(zip([1, 2, 3], chars))

print(pairs)
