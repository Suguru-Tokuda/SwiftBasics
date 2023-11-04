//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

/**
    Assignment 12
    Suguru Tokuda
    11/3/2023
 */

/*
    MARK: Async let
    Async let can be used to wait for one or multiple procsses to be completed before the rest of code executions.
 */

func wait(seconds: Int) async -> Bool {
    do {
        try await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
        return true
    } catch {
        return false
    }
}

func performAsyncLet() {
    Task {
        async let sleep1 = wait(seconds: 1)
        async let sleep2 = wait(seconds: 2)
        async let sleep3 = wait(seconds: 3)
        
        
        let les = await [sleep1, sleep2, sleep3]
        
        print(les)
    }
}

performAsyncLet()

/*
 MARK: DispatchGroup
 Allows multiple tasks to complete before you proceed to next tasks. Can be used with escaping closures.
 */

func wait(completionHandler: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        completionHandler()
    }
}

let waitGroup = DispatchGroup()

// 1.
waitGroup.enter()
wait {
    print("wait 1")
    waitGroup.leave()
}

// 2.
waitGroup.enter()
wait {
    print("wait 2")
    waitGroup.leave()
}

// 3.
waitGroup.enter()
wait {
    print("wait 3")
    waitGroup.leave()
}

