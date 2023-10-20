//: [Previous](@previous)

import Foundation

// 1. Default Initializer
class Person {
    var name: String = "SwiftUI"
    var age: Int = 4
}

let p1 = Person()

// 2. MemberWise initializer
//    Only for structs
struct EmployeeStruct {
    var employeeName: String
    var employeeAge: Int
}

let e1 = EmployeeStruct(employeeName: "", employeeAge: 5)

// 3. Custom Initializer
class EmployeeClass {
    var empName: String
    var empAge: Int
    
    init(empName: String, empAge: Int) {
        self.empName = empName
        self.empAge = empAge
    }
}

let empClas = EmployeeClass(empName: "", empAge: 5)

// 4. Failable initializer
struct Dog {
    var breed: String
    
    init?(breed: String) {
        if breed.lowercased() != "doberman" {
            // the object will be nil
            return nil
        }

        self.breed = breed
    }
    
    init() {
        self.breed = "Huskey"
    }
}

let d1: Dog? = Dog(breed: "Doberman")

if let d1 {
    print(d1)
}

let d2 = Dog()

print(d2)

// 5. Required Init
class Emp {
    var yearsOfExp: Int
        
    required init(yearsOfExp: Int) {
        self.yearsOfExp = yearsOfExp
    }
}

class AccountsEmp: Emp {
    var age: Int
        
    init(age: Int, yearsOfExp: Int) {
        self.age = age
        super.init(yearsOfExp: yearsOfExp)
    }
    
    required init(yearsOfExp: Int) {
        self.age = 0
        super.init(yearsOfExp: yearsOfExp)
    }
}

let emp1 = Emp(yearsOfExp: 5)
let accountEmp = AccountsEmp(age: 5, yearsOfExp: 20)

print(emp1)
print(accountEmp)
