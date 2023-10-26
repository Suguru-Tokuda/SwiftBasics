//: [Previous](@previous)

import Foundation

/*
    Access Specifiers
    1. Internal - (Default) Anything which is defined in the same module is accessible.
    2. Private - the most restricted specifier. In this declarations are accessible only within the defined class or struct.
    3. FilePrivate - private only within the file. Second most restricted specifier.
    4. Public - can be accessed from anywhere within the project (regardelss the directory structure).
    5. Open - similar to public, however, you can subclass (inherit) anywhere.
 
    As a standard practice, internal & private should be used. Using public & open is not recommended in real life projects.
 */

// 1. Internal - Employee can be accessed from the same module
fileprivate class Employee {
    // 4. public - the property can be accessed through any files within the same project.
    public var empName: String
    var empYearsOfExperience: Int
    
    init(empName: String, empYearsOfExperience: Int) {
        self.empName = empName
        self.empYearsOfExperience = empYearsOfExperience
    }
    
    // 2. private - this function can be called only in the class
    private func getNumberOfExperience() -> Int {
        return empYearsOfExperience
    }
}

class ITEmployee {
    func abc() {
        // 3. fileprivate - Employee is accessible because Employee is in the same file where ITEmployee is
        let emp1 = Employee(empName: "Emp", empYearsOfExperience: 5)
    }
}
