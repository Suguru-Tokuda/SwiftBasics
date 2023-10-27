//: [Previous](@previous)

import Foundation

/*
 Memory Management
 
 ARC - Automatic Reference Counting (Garbage collection in Java; simliar but not the same)
 - Works in both ObjC and Swift
 - It keeps a track of reference to objects and releases them when they are not needed.
 
 1. strong - this is default, use strong references to keep objs alive as long as they are being used
 2. weak - when you don't want to have a ownership of that object. weak doesn't increase the refernce count
 3. unowned - is simlar to weak, but unowned variable should always have data otherwise the app will crash. unowned doesn't incrase the reference count
 
 Retain Cycle Issue - when 2 strong objects retains each other strongly, then it creates a cyclic loop of dependency which is called as retain cycle issue.
 
 SwiftC - Compiler dirrectly complied into machine language (no byte code)
 */

class Person {
    var name: String // strong reference: ARC will work on collecting unused references and clears.
    var age: Int? // strong
    unowned var car: Car? // weak reference
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
        print("init Person")
    }
    
    func getName() -> String {
        return name
    }
    
    deinit {
        print("deinit Person")
        self.age = nil
        self.car = nil
    }
}

/*
 reference count = 0 before initialization
 */

// the following code created a reference and trigerred an initializer.
//var person: Person? = Person(name: "SwiftUI", age: 4)
///*
// reference count = 1 after initialization
// */
//
//
//var person2 = person // strong reference
/*
 reference count = 2
 */

// it is better to remove an object by assigning nil
//person = nil // 2 - 1 = 1
//person2 = nil // 1 - 1 = 0

// deinit never gets called until all the references are removed.

/*
 reference count = 0 after deinitialization
 */

//print(person)
//print(person2)

class Car {
    var type: String
    var owner: Person?
    
    init(type: String) {
        self.type = type
        print("init Car")
    }
    
    func getType() -> String {
        return type
    }
    
    deinit {
        print("deinit Car")
        self.owner = nil
    }
}

var person: Person? = Person(name: "SwiftUI", age: 4)
var car: Car? = Car(type: "Cumbustion")

person?.car = car
car?.owner = person

// deinit is not called in Person and Car class because Person and Car class have strong reference to each other.

car = nil
//person = nil

print(person)
print(car)
