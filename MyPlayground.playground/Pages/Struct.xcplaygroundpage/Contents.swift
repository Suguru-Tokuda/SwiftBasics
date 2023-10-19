//: [Previous](@previous)

import Foundation

// Value type
struct Employee {
    var name: String
    var id: Int
    var sal: Int?
    
    func walk() -> Void {
        print("\(name) is walking.")
    }
    
    func haveLunch() {
        print("\(name) is having lunch.")
    }
    
    func getName() -> String {
        return name
    }
    
    func getEmpId() -> Int {
        return id
    }
}

// Struct provides memberwise initializers
let emp1 = Employee(name: "Suguru", empId: 1)

// Struct doesn't support inheritance
//struct ITEmployee: Employee {
//    
//}

/*
 When to use Class and Struct
 If inheritance needs to happen then use Class
 Struct is light weight and should be used more than class because it doesn't have to hold memory address.
 Classes are get stored in heap memory
 Structs are stored in stack memory
 */
