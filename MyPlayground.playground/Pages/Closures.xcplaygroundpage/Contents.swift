//: [Previous](@previous)

import Foundation

/*
    Closures - unnamed block of code, that we can pass arround and use in code and can assign to a variable or can return from a function also. Closures are reference type like class. They capture and store the reference to any any constants and variable surrouding context.
 */

func squareOfNumber(n1: Int) -> Int {
    return n1 * n1
}

let res = squareOfNumber(n1: 3)
print("\(res)")

let sayHello = {
    print("Hello")
}

sayHello()

let sayHello2 = {
    print("Hello2")
}

func doSquare(n1: Int, completion: (Int) -> ()) {
    let result = n1 * n1
    completion(result)
}
print("before do square")
doSquare(n1: 5) { output in
    print("doSquare - \(output)")
}
print("after do square")

doSquare(n1: 25, completion: { output in
    print("doSquare - \(output)")
})

// 1. Non Escaping Closures - doesn't escape from another scope
let nonEscapingClosure = {
    print("non escaping")
}



nonEscapingClosure()

// 2. Escaping closures
func performApiCallTask(completion: @escaping () -> ()) {
    print("1. We are inside performApiCallTask func")
    
    DispatchQueue.global().async {
        print("2. We are inside global queue")
        Thread.sleep(forTimeInterval: 4)
        
        DispatchQueue.main.async {
            print("3. We are inside DispatchQueue.main")
            print("4. Afte 4 secs of delay")
            completion()
        }
        
        print("5. After DispatchQueue.main")
    }
}

performApiCallTask {
    print("6. Inside a closure")
}

// 3. Training Closure: Whenever there is a closure which is the last parameter for a function then it will be called as trailing closure

func doSomeTask(name: String, age: Int, onSuccess: (String) -> Void) {
    let bioData = "Name of Person is \(name) and age is \(age)"
    onSuccess(bioData)
}

doSomeTask(name: "Suguru", age: 36) { output in
    print(output)
}

// not a trailing closure
func doSomeTask2(name: String, age: Int, onSuccess: (String) -> Void, isValid: Bool) {
    let bioData = "Not traiing closure: Name of Person is \(name) and age is \(age)"
    onSuccess(bioData)
}

doSomeTask2(name: "Suguru", age: 36, onSuccess: { output in
    print(output)
}, isValid: false)

// 4. Auto Closure - When a closure doesn't take any parameter not it returns anything from closure then it get self wraped when called is known as Auto Closure.
func travelToDestination(action: @autoclosure () -> String) {
    print(action())
}

var myName: String = {
    return "Suguru Tokuda"
}()

travelToDestination(action: myName)

print(Int.max)
