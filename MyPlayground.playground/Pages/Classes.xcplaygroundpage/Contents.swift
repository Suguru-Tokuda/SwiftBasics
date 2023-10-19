//: [Previous](@previous)

import Foundation

// Reference Type
class Employee {
    var name: String
    var id: Int
    var sal: Int?
    
    init() {}
    
    // default initializer/constructor
    init(name: String, id: Int, sal: Int?) {
        self.name = name
        self.id = id
        self.sal = sal
    }
    
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

let emp1 = Employee(name: "Suguru", empId: 1)
let emp2 = emp1

emp2.name = "Suguru updated"

print(emp1.name)
print(emp2.name)

print(emp1.getName())
print("\(emp1.getEmpId())")
emp1.walk()
emp1.haveLunch()

// multipl inheritance is not allowed in Swift
class ITEmployee : Employee {
    private var techName: String
    
    init(techName: String, name: String, id: int, sal: Int?) {
        super.init(name: name, id: id, sal: sal)
        self.techName = techName
    }
}

let i1 = ITEmployee(techName: "iOS", name: "Suguru", id: 123)
