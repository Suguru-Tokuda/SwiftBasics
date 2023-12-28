//: [Previous](@previous)

import Foundation

let currentTimestamp = Int(Date().timeIntervalSince1970)
print(currentTimestamp)

/*
 Concurrency / MultiThreading
 1. GCD - Grand Central Dispatch
 2. Operations and Operation Queues
 3. SwiftConcurrency - Await Async
 4. Actor
 5. ThirdParty Frameworks - Combine, RXSwift
 6. Thread - (NSThread)NS - Namespace - lowest level api for threading/multitasking
 7. Semaphores
 
 
 Question: call api in multi threading, what should I use?
 
 Single task: GCD
 Multiple tasks: operation queues because you can add dependencies.
 Better than GCD and operation queues? => async await
 To make everything complicated into simple code => async let
 
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
//
//DispatchQueue.main.async {
//    print("Main thread a")
//}
//
//DispatchQueue.main.async {
//    print("Main thread b")
//}
//
//// 2. Serial Queue / Custom Queue
//let queue1 = DispatchQueue(label: "queue1")
//
//queue1.async {
//    print(Thread.current)
//    print("a Task")
//}
//
//// task a has to complete before b can start
//queue1.async {
//    print("b Task started")
//    for i in 0..<100 {
//        if i % 2 == 0 {
//            print(i)
//        }
//    }
//    print("b Task ended")
//}
//
//queue1.async {
//    print("c task")
//}
//
//let concurrentQueue = DispatchQueue(label: "concurrentQueue123", attributes: .concurrent)
//
//concurrentQueue.async {
//    for i in 0...150 {
//        print("a - \(i)")
//    }
//    
//    print("a Task")
//}
//
//concurrentQueue.async {
//    print("b Task")
//}
//
//concurrentQueue.async {
//    for i in 0...10 {
//        print("c - \(i)")
//    }
//    print("c Task")
//}
//
//// sync makes sure to finish even it's concurrent. No need to use sync if the que is serial.
//concurrentQueue.sync {
//    for i in 0...150 {
//    }
//    
//    print("a Task")
//}
//
//concurrentQueue.sync {
//    print("b Task")
//}
//
//concurrentQueue.sync {
//    for i in 0...10 {
//    }
//    print("c Task")
//}
//
//
//
//// 3. Global Queue - system provided queues, and are ALWAYS concurrent
//// Priority of this queue is decided by factor called as QOS - Quality of Service
//DispatchQueue.global(qos: .background).async {
//    print("Background thread")
//}
//
//DispatchQueue.global(qos: .userInteractive).async {
//    print("userInteractive")
//}

main()
