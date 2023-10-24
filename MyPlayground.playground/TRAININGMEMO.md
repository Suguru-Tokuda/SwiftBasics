# Swift Basics Note

## Variables & Functions

### Variables

Variables are used to temporarily store data in the memory in programming. In Swift, variables are declared with the `var` keyword.

```
var lastNaem: String = "Tokuda" // String
var rollNo: Int = 101 // Int
var num: Float = 11.2 // Float
var number: Double = 12345.11 // Double
var isCorrect: Bool = false // Boolean
```

### Constants

Constants are similar to variables, however, data stored as a constant cannot be modified after the initialization. Constants are defined with `let` keyword in Swift.

```
let fullName = "Suguru Tokuda"
fullName = "Tokuda, Suguru" // Not allowed
```

### Data Types

Swift supports various data types. Examples of data types are:

- String
- Character
- Int
- Float
- Double

### Type inferencing

When declaring variables, Swift can automatically detect the type if `=` is used to assign initial value.

```
// These two lines are equivalent.
var name = "Suguru"
var name: String = "Suguru"
```

When it comes to numbers, Swift automatically picks a lower data type to save memory usage.

```
var num = 1 // considered as Int instead of Double.
```

### Type Safety

Swift has Type Safety mechanism which prevents a variable from having other data type values.

```
// The following code throws a compilation error.
var name = "Suguru" // String
name = 1234 // assining Int value into a String variable is not allowed.
```

### ARC - Automatic Reference Counting (Memory Management)

Swift counts active memory reference and remove unused reference from memory just like other languages such as Java and C#.

### Functions

Functions/Methods are considered as behaviors and actions in programming.

1. Simple function without any arguments or return type. You can append `-> Void` at the end of function definition as a return type but this is not necessary.

```
func doAction() {
    print("doing maths")
}

func doStuff() -> Void {
    print("doing stuff")
}
```

2. Functions with parameters

```
func doSum(num1: Int, num2: Int) {
    let result = num1 + num2
    print(result)
}

doSum(num1: 2, num2: 2) // 4 is printed
```

3. Functions with return values

```
func doSutraction(n1: Int, n2: Int) -> Int {
    return n1 - n2
}

print(String(doSubtraction(n1: 1, n2: 1))) // prints 0

// The following function definition can omit paramter names when calling it by using `_`.
func addNumbers(_ n1: Int, _ n2: Int) -> Int {
    return n1 + n2
}

print(String(addNumbers(1, 1,))) // prints 2

// You can also give external parameter names
func divideNumbers(numerator n: Int, denominator d: Int) -> Float {
    return Float(n) / Float(d)
}

print(String(divideNumbers(numerator: 1, denominator: 2))) // prints 0.5

```

### String Formatting

When printing or formatting a String with variables (that are not string types), `\()` is used to concatenate.

```
var sal = 100

print("My salary is $\(100)k") // prints My salary is $100k"
```

### Tuple

Tuples are a group of data. This enables a function to return more than one values. Tuples are created by using `()`

```
var tuple = (1, "A", true)
var tuple2: (Int, String, Bool) = (2, "B", false)

func getTuple() -> (String, Bool) {
    return ("This is true", true)
}
```

---

## Collections

### Array

Array is a sequence of values as a group. Array can contain the same data type or any data type (`Any`).

```
var numbers: [Int] = [1, 2, 3] // With data type definied and initial values are given.
var numbers2 = [1, 2, 3] // Uisng type inference
var numbers3 = [Int]() // Empty array
```

Accessing data from the array can be done by using a property or `[]`.

```
numbers[0] // get 1
numbers.first // Optional(1)
```

Adding data into an array can be done append (O(1)) insert(O(n))

```
numbers.append(5) // append at the end of array
numbers2.insert(1, at: 0) // prepends
```

Removing an element from the array can be achieved by `remove(at: Int)`

```
numbers.remove(at: 0) // removing 1 from the array
```

### Set

Set is another data structure in Swift which can contain only unique elements. Data in a set cannot be sorted. Set uses hash algorithm, therefore, inserting and deleting have O(1) time complexity.

```
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
```

### Dictionary

Dictionary is a data structure for key value pairs. You can set any data type as key and value.

```
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
```

## Optional

Optional type is defined by appending `?` after the data type or assining an optional value from the return type in function. The default value for optional types are `nil`. This is useful when a property does not need to have any value in the application.

```
// Assign a value after declaration
var phoneNumber: String?
phoneNumber = "123-456-7890"

// Assignng a value on declaration
var isStudent: Bool? = false

// A function with an optionak type
function getNumber(isCorrect: Bool) -> Int? {
    if isCorrect {
        return 1
    } else {
        return nil
    }
}

var num = getNumber(isCorrect: false)
print(num) // prints nil
```

### Optional Binding

Optional binding is the way unwrap a value from an optional type. If there is a value in it and attempting accessing a value without unwrapping always return "Optional(value)"

1. `if let`
   <br>
   `if let` creates a temp variable and the wrapped value is available inside the block if there is a value (not nil).

```
var num: Int? = 0
if let number = num {
    print(number) // prints 0
}

// shorthand if let
if let num {
    print(num) // prints 0
}
```

2. `guard let`
   <br>
   `guard let` is similar to `if let`, however, `guard let` prevents the program to go any further if the value is nil. `guard let` should be used for edge cases.

```
var num: Int?

func performGuardLet() {
    guard let num else { return }
    print(num) // this line will not be executed.
}
```

3. `Coalescing (??)`
   <br>
   By using `??` after the variable, it can specify the default value if the optional variable is nil. It is useful to avoid using multiple if let and guard let; promotes code readability.

```
var num: Int?
var newNum: Int = num ?? 0

print(newNum) // prints 0
```

4. `Force unwrap (!)`
   <br>
   With `Force unwrap (!)`, the value is unwrapped forcefully; even if there is not value in it. `!` should be used when the chance of getting the value is 100%, because the program will through an error if `nil` is unwrapped.

## Class & Struct

### Class

Classes allows to create a block of code which can contain variables, constants, and functions. Class allows Object Oriented Programming (1. Abstraction, 2. Polyphormism, 3. Inheritance, 4. Encapsulation).

Classes are reference type in Swift and the objects initialized by classes are stored in the heap memory.

```
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
```

### Struct

Struct is similar to class, however, Struct is value type and the objects initialized by structs are stored in the stack memory. Structs are light weight and preferred in the Swift programming. Structs do not support inheritance but it supports protocols.

Unlike class, Structs are immutable by default. Modifying properties are possible by creating `mutating func`. Under the hood, Swift creates a brand new data based on the new value and pops the old data from the stack memory.

```
struct Fighter {
    var name: String
    var healthPoint: Int
    var attackPoint: Int

    func attack() {
        print("\(name) attacked (attack point: \(attackPoint)).")
    }

    // when mutating func is called
    // the data is popped from the stack memory
    // and the copy of the data gets inserted into
    // the stack memory
    mutating func changeName(newName: String) {
        self.name = newName
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
```

## Control Statements

1. `if`

```
var number = 5

if number == 5 {
    print("correct number")
}
```

2. `if {} else if {}`

```
if number < 5 {
    print("number is smaller than 5")
} else if number > 5{
    print("number is greater than 5")
}
```

3. `if {} else if {} else`

```
if number < 5 {
    print("number is smaller than 5")
} else if number > 5 {
    print("number is greater than 5")
} else {
    print("other case")
}
```

4. Switch Statement

```
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
```

## Loops

1. `for loop`
   <br>
   for loops iterate through range, arrays, sets, and dictionary.

```
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
```

2. `while loop`
   <br>
   `while loop` iterates until the condition is satisfied.

```
var whileNum = 0

while whileNum < 20 {
    print(whileNum)
    whileNum += 1
}
```

3. `repeat {} while condition`
   <br>
   Similar to while loop, but the while block runs at least once.

```
repeat {
    print(whileNum)
    whileNum += 1
} while whileNum == 20
```

## Initializers

1. Default initializer
   <br>Values are initialized when class properties are declared

```
class PersonForAssign3 {
    var firstName: String = "Suguru"
    var lastName: String = "Tokuda"
}

let per1 = PersonForAssign3()
```

2. Membership initializer
   <br>
   Applies only for structs. The initializer is generated automatically by Swift without specifying default values for non-optional values.

```
struct PersonStructForAssign3 {
    var firstName: String
    var lastName: String
}

let per2 = PersonStructForAssign3(firstName: "Suguru", lastName: "Tokuda")
```

3. Custom Initializer
   <br>
   Your own initializer for either class or struct.

```
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

struct PersonStructWithCustomInit {
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
```

4. Failable initializer
   <br>
   An initilizer which can result in nil (Optinal).

```
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
```

5. Required initializer
   <br>
   The child classes which inherits a parent class which have required initializer needs to contain the same initializer.

```
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
```

## Enums

`Enums` are value type and are widely used in Swift programming. It allows developers organize the code by having multiple switch statements for each case.

### Raw value enum

<br>
Raw value enums contain simple data type such as String and Int. For String type, if no specific value is specified it the string characters used as case is used.

```
enum Animals: String {
case dog = "Dog",
cat = "Cat",
horse
}

print(Animals.dog.rawValue) // "Dog
print(Animals.cat.rawValue) // "Cat"
print(Animals.horse.rawValue) // "hourse" because no specific value is assigned.

// The first value for Int is 0 if no value is specified.
enum Languages: Int {
case English,
Spanish = 5,
French
}

print(Languages.English.rawValue) // 0
print(Languages.Spanish.rawValue) // 5
print(Languages.French.rawValue) // 6 because 5 is assigned to Spanish. French is next and 6 is automatically assigned to it.

```

### Associated Type Enum

<br>
Associated Type Enum can pass value for each case. Enum can also contain variables and functions.

```
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
```

## Protocols

Defines the list of rules or blueprints which class, struct or enum need to adopt/confirm to it. Types that confirm to protocols nee to give implementation for function/variables. Protocols make it possible to have polyphormis and abstraction.

```
protocol Driveable {
    // You cannot assign initial value to a variable.
    // Needs at least get. set is not reuiqred.
    var numberOfGears: Int { get set }

    func accelerate(speed: Int)
    func applyBreaks()

    // Optional function
    func stearing(direction: String)
}

extension Driveable {
    // defualt implementation
    func stearing(direction: String) {
        print("Stearing in Driveable protocol in \(direction)")
    }

    var numberOfGears: Int {
        return 1
    }
}

struct Car : Driveable {
    var numberOfGears: Int

    func accelerate(speed: Int) {
        print("Accelerating by \(speed)")
    }

    func applyBreaks() {
        print("Applying breaks")
    }

    // no need to implement because default implementation is created.
//    func stearing(direction: String) {
//        print("stearing the Car in \(direction)")
//    }
}

let c1 = Car(numberOfGears: 5)
c1.accelerate(speed: 10)
c1.stearing(direction: "Left")
c1.applyBreaks()
print("")

struct Truck : Driveable {
    var numberOfGears: Int

    func accelerate(speed: Int) {
        print("Accelerating Truck by \(speed)")
    }

    func applyBreaks() {
        print("Applying breaks for Truck")
    }

    func stearing(direction: String) {
        print("Stearing the Truck in \(direction)")
    }

    // good practice.
    // make variables private
    mutating func setNumberOfGears(gears: Int) {
        self.numberOfGears = gears
    }
}

var t1 = Truck(numberOfGears: 6)
t1.accelerate(speed: 100)
t1.stearing(direction: "Right")
t1.applyBreaks()
t1.setNumberOfGears(gears: 7)
print("")

class ElectricCar : Driveable {
    var numberOfGears: Int = 10

    func accelerate(speed: Int) {
        print("Accelerating Electric car by \(speed)")
    }

    func applyBreaks() {
        print("Applying breaks for Electric car")
    }
}

let electricCar = ElectricCar()
electricCar.stearing(direction: "Left")
```

## Extensions

Extensions allow us to add more meaning/functionality to the existing types or we can use them for protocol confirmance.

```
extension Int {
    func square() -> Int {
        return self * self
    }

    // varialbes need to be a Computed Varialbe
    var isNumberEven: Bool {
        return self % 2 == 0
    }
}

let i1: Int = 5
let result = i1.square()
print("Square - \(i1) is \(result)")
```
