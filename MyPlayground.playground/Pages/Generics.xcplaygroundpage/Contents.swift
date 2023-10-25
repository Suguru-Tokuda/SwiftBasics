//: [Previous](@previous)

import Foundation

/*
 Generics
 Allows the same function to be more reusable for different data types.
 */

func doSumOfTwoNums(n1: Int, n2: Int) -> Int {
    let res = n1 + n2
    print("res = \(res)")
    return res
}
//
//doSumOfTwoNums(n1: 2, n2: 3)
//
func doSumOfTwoNums(n1: Double, n2: Double) -> Double {
    let res = n1 + n2
    print("Double res = \(res)")
    return res
}
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

// Generic can be used for class.
class Information<T> {
    var data: T
    
    init(data: T) {
        self.data = data
    }
    
    func displayTheData() {
        print("Data is = \(self.data)")
    }
    
    func description() -> NSString {
        return "Data: \(self.data)" as NSString
    }
}

let i1 = Information(data: 100)
let i2 = Information(data: "20")
let i3 = Information(data: true)
i1.displayTheData()
i2.displayTheData()
i3.displayTheData()

// Generic also works for structs as well.
// FIFO
struct MyQueue<T> {
    var myqueue: [T]
    
    mutating func enque(element: T) {
        myqueue.append(element)
    }
    
    mutating func deque() {
        myqueue.removeFirst()
    }
}

var numberQueue = MyQueue(myqueue: [0])

numberQueue.enque(element: 1)
numberQueue.enque(element: 2)
numberQueue.enque(element: 3)
print(numberQueue.myqueue)
numberQueue.deque()
print(numberQueue.myqueue)

var stringQueue = MyQueue(myqueue: ["A", "B"])
stringQueue.enque(element: "C")
stringQueue.enque(element: "D")
stringQueue.enque(element: "E")
print(stringQueue.myqueue)

var infoQueue = MyQueue(myqueue: [i1, i2])
print(infoQueue.myqueue)
