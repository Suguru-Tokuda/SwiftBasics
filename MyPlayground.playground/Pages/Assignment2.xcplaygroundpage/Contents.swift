//: [Previous](@previous)

import Foundation

/**
    Assignment 2
    Suguru Tokuda
    10/19/2023
 */

/*
 1. Sets
    Sets are one of the swift collection datastructure. It is similar to array, however, 
    it does not allow any duplicate entries. Sets also use Hash, therefore, insert, delete functions provide O(1) time complexity. Sets are not sorted.
 */

var programmingLanguages: Set<String> = []

// Insert
programmingLanguages.insert("Swift")
programmingLanguages.insert("Objective-C")
programmingLanguages.insert("Java")
programmingLanguages.insert("C#")
programmingLanguages.insert("TypeScript")

// accessing data from a set
// 1. use a built in function
if let swift = programmingLanguages.first(where: { $0 == "Swift" }) {
    print(swift)
}

// 2. Find an index
if let swiftIndex = programmingLanguages.firstIndex(where: { $0 == "Swift" }) {
    print(programmingLanguages[swiftIndex])
}

// 3. Iterate a set
programmingLanguages.forEach { el in
    print(el)
}

// Remove from sets
programmingLanguages.remove("Swift")

print(programmingLanguages)

/*
 2. Dictionary
    Dictionary is another collection data structure that Swift provides: Key Value pair.
    Uses an hash algorithm and provides O(1) time complexity for data access.
 */

// Key: employee's first name. value: id
var employees: [String : Int] = [:]

// insert into a dictionary
employees["Mike"] = 1
employees["Sarah"] = 2
employees["Ken"] = 3
employees["Guile"] = 4

// accessing the data by key
if let sarahId = employees["Sarah"] {
    print(sarahId)
}

// remove from a dictionary
employees["Sarah"] = nil
// Sarah is removed
print(employees)

/* 
    3. Optinal
    Swift provides Optional Type for variables. Optional allows developers assign nil as a default vallue.
    Without an optional type all variables need to have values assigned to it. It is useful when creating a class/struct
    and when some of the properties are not mandatory.
*/

// assign value later
var phoneNumber: String?
phoneNumber = "123-456-7890"

// assign value on declaration
var isStudent: Bool? = false

/*
    4. Optional binding
 
    To access optional type, one of these techniques are required to "unwrap" (takes the value out of the Optional wrapper).
 
     - if let
     - guard let
     - Coalescing (??)
     - Force unwrap (!)
 */

// if let
if let phone = phoneNumber {
    print(phone)
}

// guard let
func performGuard() {
    guard let phone = phoneNumber else { return }
    print(phone)
}

performGuard()

// Coalescing (??)
print(phoneNumber ?? "")

// Force unwrap (!)
print(phoneNumber!)


/*
    5. Classes & Inheritance and Initializers
 
    Classes are reference type (stored in heap memory).
    A class can contain variables & constants, and functions.
    Classes also support inheritance, however, a child class can inherit ONLY one parent class.
 */

class Person {
    var firstName: String = ""
    var lastName: String = ""
        
    // initializer with no arguments.
    init() {}

    // parent class initializer
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func jump() {
        print("\(firstName) \(lastName) is jumping.")
    }
}

let person = Person(firstName: "Suguru", lastName: "Tokuda")
let person2 = Person()
person2.firstName = "Kit"
person2.lastName = "Kat"
person2.jump()

// child class that inherits Person class
class Employee: Person {
    var id: Int
    
    // child class initializer
    init(firstName: String, lastName: String, id: Int) {
        self.id = id
        super.init(firstName: firstName, lastName: lastName)
    }
    
    func work() {
        print("\(firstName) \(lastName) (Id: \(id)) is working.")
    }
}

let employee = Employee(firstName: "Tom", lastName: "Hardy", id: 1)
employee.jump()
employee.work()

// creates a reference copy
let employee2 = employee
employee2.firstName = "Henry"

// both employee and employee2 has Henry for their firstName
print(employee.firstName)
print(employee2.firstName)

/*
    6. Struct
    
    Struct is a value type and gets stored in stack memory.
    Unlike Class, Struct does not need an initializer. Memberwise initializer is provided by default, though you can
    also set a custom initializer.
 
    Struct is not supported for inheritance.
 */

struct Fighter {
    var name: String
    var healthPoint: Int
    var attackPoint: Int
    
    func attack() {
        print("\(name) attacked (attack point: \(attackPoint).")
    }
}

let fighterA = Fighter(name: "Cloud", healthPoint: 100, attackPoint: 20)
// since all properties are not optional, the following code throws a compliation error
// let fighterB = Fighter()
// creates a deep copy
var fighterB = fighterA

fighterB.name = "Tifa"

print(fighterA.name)
print(fighterB.name)
