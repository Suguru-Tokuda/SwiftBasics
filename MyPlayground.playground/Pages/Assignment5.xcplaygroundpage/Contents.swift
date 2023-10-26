//: [Previous](@previous)

import Foundation

/**
    Assignment 5
    Suguru Tokuda
    10/25/2023
 */

/*
    MARK: 1. Generic (continued)
       Addition to the usage of Generic with functions. Generic can also be used for classes, structs, and enums. The advantage of Generics in any data types is to make the code reusable.
 */

// Generic with Class
class Housing {
    var numberOfBedrooms: Int
    
    init(numberOfBedrooms: Int) {
        self.numberOfBedrooms = numberOfBedrooms
    }
}

class House : Housing {
    var houseName: String
    
    init(houseName: String, numberOfBedRooms: Int) {
        self.houseName = houseName
        super.init(numberOfBedrooms: numberOfBedRooms)
    }
}

class Apartment : Housing {
    var apartmentName: String
    
    init(apartmentName: String, numberOfBedrooms: Int) {
        self.apartmentName = apartmentName
        super.init(numberOfBedrooms: numberOfBedrooms)
    }
}

class PersonClassForAss5<T> {
    var firstName: String
    var lastName: String
    var property: T

    init(firstName: String, lastName: String, property: T) {
        self.firstName = firstName
        self.lastName = lastName
        self.property = property
    }
}

let personWithHouse = PersonClassForAss5(firstName: "Suguru", lastName: "Tokuda", property: House(houseName: "House", numberOfBedRooms: 5))
let personWithApartment = PersonClassForAss5(firstName: "Suguru 2", lastName: "Tokuda 2", property: Apartment(apartmentName: "Apartment", numberOfBedrooms: 2))


// Generic with Stack
struct Stack<T> {
    var stack: [T] = []
    var count: Int = 0 // used to track the length of the stack
    
    // add a new element to the stack at the end of the array
    // then increment the count by 1
    mutating func add(_ element: T) {
        stack.append(element) // add to the array
        count += 1
    }
    
    // Removes the last element and return it if exists.
    // If doesn't exist then it returns nil.
    mutating func pop() -> T? {
        if let retVal = stack.last {
            count -= 1
            return retVal
        } else {
            return nil
        }
    }
}

var stack = Stack<Int>()

stack.add(1)
stack.add(2)
stack.add(3)

print("After adding elements in the stack: \(stack.stack)")

if let removed = stack.pop() {
    print("\(removed) was removed")
}

print("After removal: \(stack.stack)")

// Generic with enum
enum GenericEnum<T> {
    case one(val: T),
         two(val: T),
         three(val: T)
    
    func getValue() -> T {
        switch self {
        case .one(val: let val):
            return val
        case .two(val: let val):
            return val
        case .three(val: let val):
            return val
        }
    }
}

var one = GenericEnum<String>.one(val: "one")
print(one.getValue())

/*
    MARK: 2. Closures
       Closures are unnamed/anonymous functions. Those functions can be passed as a function argument or assign it to variables. Closures are flexible and poweful functions which enable flexible operations in swift code. It is commonly used when synchronous operations are done in Swift for multi-threading and api calls. It is used as a call back function.
        
        There are 4 types of closures in Swift:
        1. Non escaping closures
        2. Escaping closures
        3. Trailing closures
        4. Auto closures
 */

// Non Escaping Closue: simply assining a block (anonymous function) to a variable.
let nonEscapingClosure = {
    print("I'm not escaping...")
}

// print "I'm not escaping..."
nonEscapingClosure()

// Escaping closure: escaping closure takes an argument. The calling function can contain any logic with the return value.
func escapingClosure(val: Int, complesion: (Int) -> (), isEscaping: Bool) {
    if isEscaping && val > 5 {
        complesion(val)
    }
}

// the closure gets called because isEscaping is true
escapingClosure(val: 6, complesion: { val in
    print(val)
}, isEscaping: true)

// the closure never gets called
escapingClosure(val: 4, complesion: { val in
    print(val) // never gets executed
}, isEscaping: false)

// Trailig closure: the closure that is at the end of the function parameter
func trailingClosure(val: String, _ completion: (String) -> Void) {
    print(val)
}

// calling a closure func with short hand.
trailingClosure(val: "This is an example of a trailing closure") { print($0) }

// Auto Closure: a type of closure without any paramter. Used as a call back.
func onBtnClick(action: () -> ()) {
    action()
}

onBtnClick {
    print("Btn clicked!")
}

/*
    MARK: @escaping
    @escaping needs to be added before the closure if the function contains synchronous code.
 */
func timer(completion: @escaping () -> ()) {
    print("Got into the sleep func")
    
    DispatchQueue.global(qos: .background).async {
        print("Background thread!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("Back to main after 5 seconds!")
            completion()
        }
    }
}

timer {
    print("timer called after completion")
}

/*
    MARK: 3. Higther Order Functions
    Higher order functions take a collection. The caller can use a custom function (closure) to various operations such as:
    1) map
    2) filter
    3) reduce
    4) sort
    5) flatMap
    6) compactMap
    7) forEach
    8) zip
 */

// 1. map: takes a collection and return a collection
var randomNums: [Int] = []
for i in 0..<100 {
    // add random num
    randomNums.append(Int.random(in: 1..<100))
}

let randomNumsPlusOne = randomNums.map { $0 + 1 } // add 1 to every number from randomNums and assign the return value to a constant.
print(randomNumsPlusOne)

// 2. Filter: filters a collection for the condition specified inside a closure.
let numsOver50 = randomNums.filter { $0 > 50 } // filter numbers that are greater than 50
print(numsOver50)

// 3. Reduce: reduce function temporarily stores a value and applies the specified operation for each element.
let sumOfRandomNums = randomNums.reduce(0, +)
// equivalent but set the initial value to 100
let sumOfRandomNums2 = randomNums.reduce(100) { partialResult, num in
    partialResult + num
}
print(sumOfRandomNums)
print(sumOfRandomNums2) // 100 greater than sumOfRandomNums

// 4. Sort
let randomNumsSortAsc = randomNums.sorted(by: { $0 < $1 })
let randomNumsSortDesc = randomNums.sorted(by: { $0 > $1 })

print(randomNumsSortAsc)
print(randomNumsSortDesc)

// 5. FlatMap
let nums: [[Int]] = [[1,2,3], [4,5,6]]
let flatNums = nums.flatMap { $0.count } // instead of returning all numbers, return count for individual array inside the multi dimensional array.
print(flatNums)

let wordList: [String] = ["Hello", "World"]
let flattenedWordListLower: [Character] = wordList.flatMap { $0.lowercased() } // converts a String array into a Character array. During the operation all the cases are lowered.

print(flattenedWordListLower)

// 6. CompactMap: used to remove all nils inside a collection.
let optionalNums: [Int?] = [1, 2, 3, 4, nil, 6, nil, 8, 9]
let nonOptionalNums = optionalNums.compactMap { $0 }

print(nonOptionalNums) // only non optional values are returned.

// 7. forEach: iterate through a collection. Similiar to for item in items { block of code }
var sum: Int = 0
randomNums.forEach { sum += $0 } // can be used in different sinarios by looping through every object, however, unlike for loop, break cannot be called inside forEach.

// 8 . zip: combine two arrays
let petOwners = ["Mike", "Sarah", "Kat"]
let pets = ["Leo", "Tiger", "Mao"]

for (owner, pet) in zip(petOwners, pets) {
    print("\(owner) owns \(pet)")
}
