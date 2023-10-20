//: [Previous](@previous)

import Foundation

/**
    Assignment 3
    Suguru Tokuda
    10/20/2023
 
     1.Control Statements (if , if else, if else if else,switch)
     2.Loops (for loop , while loop, repeat while)
     3.Initialisers in Swift
     4. Enums and its types
     5.Different uses of Enums and use of variables and functions inside Enum
     6.Mutating Function in struct
 */

/*
    MARK: 1. Control Statements
       - if
       - if else
       - if else if else
       - switch statement
 */

var number = 5

// if
if number == 5 {
    print("correct number")
}

// if else

if number < 5 {
    print("number is smaller than 5")
} else if number > 5{
    print("number is greater than 5")
}

// if else if else

if number < 5 {
    print("number is smaller than 5")
} else if number > 5 {
    print("number is greater than 5")
} else {
    print("other case")
}

// switch stement

var char: Character = "a"

switch char {
case "a":
    print("printing 'a'")
case "b":
    print("printing 'b'")
case "c":
    print("printing 'c'")
default:
    print("default")
}

/* 
    2. MARK: Loops
    - for loop
    - while loop
    - repeat while
 */

/*
    for loop: iterate through range, arrays, sets, and dictionary.
 */

// with range

// print 0 to 4
for i in 0..<5 {
    print(i)
}

// print 0 to 20 (includes 20) and skip by 2
for i in stride(from: 0, through: 20, by: 2) {
    print(i)
}

// print 0 to 20 (exluddes 20) and skip by 2
for i in stride(from: 0, to: 20, by: 2) {
    print(i)
}

// iterate an array
let nums: [Int] = [1, 2, 3, 4, 5]
for num in nums {
    print(num)
}

// iterate a set
let animals: Set<String> = ["Dog", "Cat", "Bird"]

for animal in animals {
    print(animal)
}

// iterate a dictionary
let employees: [Int : String] = [1: "Emp1", 2: "Emp2", 3: "Emp3"]

for (key, val) in employees {
    print("key: \(key), val: \(val)")
}

// while loop: iterates until the condition is met
var whileNum = 0

while whileNum < 20 {
    print(whileNum)
    whileNum += 1
}


// repeat while: similar to while loop, but the while block runs at least once

repeat {
    print(whileNum)
    whileNum += 1
} while whileNum == 20


/*
    MARK: Initializers in Swift
    1. Default Initializer
    2. Memberwise Initializer
    3. Custom Initializer
    4. Failable initializer
    5. Required initializer
 */

// 1. Default initializer: values are initialized when class properties are declared
class PersonForAssign3 {
    var firstName: String = "Suguru"
    var lastName: String = "Tokuda"
}

let per1 = PersonForAssign3()

// 2. Memberwise initializer: applies only for structs. The initializer is generated automatically by Swift without specifying default values for non-optional values

struct PersonStructForAssign3 {
    var firstName: String
    var lastName: String
}

let per2 = PersonStructForAssign3(firstName: "Suguru", lastName: "Tokuda")

// 3. Custom Initializer: your own initializer for both class and structs

class PersonClassWithCustomInit {
    var firstName: String
    var lastName: String
    var email: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

class PersonStructWithCustomInit {
    var firstName: String
    var lastName: String
    var email: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

var personClassWithCustomInit = PersonClassWithCustomInit(firstName: "Suguru", lastName: "Tokuda", email: "stokuda@email.com")

var personStructWithCustomInit = PersonStructWithCustomInit(firstName: "Suguru", lastName: "Tokuda", email: "stokuda@email.com")

// 4. Failable initializer
struct Pet {
    var name: String
    var type: String
    var dateOfBirth: Date
    
    init?(name: String, type: String, dateOfBirth: Date?) {
        guard let dob = dateOfBirth else { return nil }
        // check if dateOfBirth is not future
        if dob > Date() {
            return nil
        }
        
        self.name = name
        self.type = type
        self.dateOfBirth = dob
    }
}

let pet1: Pet? = Pet(name: "MyPet", type: "Dog", dateOfBirth: DateFormatter().date(from: "01/01/2100"))

// nil is printed becauase dateOfBirth needs to be in the past than the current date.
print(pet1)

// 5. Required Init
class CheckboxItem {
    var isSelected: Bool?
    
    required init(isSelected: Bool) {
        self.isSelected = isSelected
    }
}

class ChildCheckboxItem: CheckboxItem {
    var title: String
    
    init(isSelected: Bool, title: String) {
        self.title = title
        super.init(isSelected: isSelected)
    }
    
    required init(isSelected: Bool) {
        self.title = ""
        super.init(isSelected: isSelected)
    }
}

var checkboxItem = ChildCheckboxItem(isSelected: false, title: "Checkbox")

/*
    MARK: 4. Enums && 5. Use of Variables and functions inside enum
    - Raw Value Enum
    - Associated Type Enum
 */

// Raw Value Enum
enum Animals: String {
    case dog = "Dog",
         cat = "Cat",
         horse = "Horse"
}

print(Animals.dog.rawValue)
print(Animals.cat.rawValue)
print(Animals.horse.rawValue)

// Associated Type Enum
enum iPhones {
    case iPhone15(price: Int)
    case iPhone14(price: Int)
    case otherPhone(price: Int)
    case unclassified
    
    // variable inside enum
    var defaultPrice: Int { return 200 }
    
    // function inside enum
    func getPrice() -> Int {
        switch self {
        case .iPhone15(price: let price):
            return price
        case .iPhone14(price: let price):
            return price
        case .otherPhone(price: let price):
            return price
        default:
            return defaultPrice
        }
    }
}

var iPhone15 = iPhones.iPhone15(price: 1500)
var iPhone14 = iPhones.iPhone14(price: 1000)
var iPhoneSE = iPhones.otherPhone(price: 500)
var oldIPhone = iPhones.unclassified

print(String(iPhone15.getPrice()))
print(String(iPhone14.getPrice()))
print(String(iPhoneSE.getPrice()))
print(String(oldIPhone.getPrice()))

// MARK: 6. Mutating function in Struct
// Under the hood, Swift creates a new copy of data
// the old data is popped from the stack memory after inserting a new data
// with updated values
struct Robot {
    var name: String
    var healthPoint: Int = 100
    let maxHP: Int = 100
        
    mutating func receiveDamange(_ damage: Int) {
        healthPoint -= damage
        
        if healthPoint < 0 { healthPoint = 0 }
    }
    
    mutating func heal(_ point: Int) {
        healthPoint += point
        
        if healthPoint > maxHP { healthPoint = maxHP }
    }
}

var robot = Robot(name: "My Robot")
robot.receiveDamange(50)
print("\(robot.name)'s HP: \(robot.healthPoint)")
robot.heal(60)
print("\(robot.name)'s HP: \(robot.healthPoint)")
