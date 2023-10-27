//: [Previous](@previous)

import Foundation

/*
 Concurrency / MultiThreading
 1. GCD - Grand Central Dispatch
 2. Operations and Operation Queues
 3. SwiftConcurrency - Await Async
 4. Actor
 5. ThirdParty Frameworks - Combine, RXSwift
 6. Thread - (NSThread)NS - Namespace - lowest level api for threading/multitasking
 7. Semaphores
 */

/*
 1. GCD - Grand Central Dispatch
    Queue Based API that will allow us to execute tasks in FIFO order.
    GCD is built on top of threads.
    
    3 Types of Queue
    1. Main Queue - Main Thread - Anything related UI should be done in the main thread
    2. Serial Queue / Custom Queue
    3. Global Queue
 */

// Main Queue - Main Thread
//let isMainThread = true

DispatchQueue.main.async {
    print("Main thread a")
}

DispatchQueue.main.async {
    print("Main thread b")
}

// 2. Serial Queue / Custom Queue
let queue1 = DispatchQueue(label: "queue1")

queue1.async {
    print(Thread.current)
    print("a Task")
}

// task a has to complete before b can start
queue1.async {
    print("b Task")
}

queue1.async {
    print("c task")
}

let concurrentQueue = DispatchQueue(label: "concurrentQueue123", attributes: .concurrent)

concurrentQueue.async {
    for i in 0...150 {
        print("a - \(i)")
    }
    
    print("a Task")
}

concurrentQueue.async {
    print("b Task")
}

concurrentQueue.async {
    for i in 0...10 {
        print("c - \(i)")
    }
    print("c Task")
}

// 3. Global Queue
DispatchQueue.global(qos: .background).async {
    print("Background thread")
}
