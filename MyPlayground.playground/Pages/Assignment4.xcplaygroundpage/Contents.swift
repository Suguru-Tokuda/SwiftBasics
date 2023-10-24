//: [Previous](@previous)

import Foundation

/**
    Assignment 4
    Suguru Tokuda
    10/23/2023
 */


/*
 1. Protocols
    A list of rules or blueprint which class or struct or anyone who adopts/confirms it, needs to give implementation for function/variables. Protocols allow Swift to have polyphormism.
*/
protocol Runnable {
    // appending get is required. set is optional
    var runningSpeedInMiles: Int { get set }
    var isRunning: Bool { get set }
    
    mutating func run()
    mutating func stop()
    mutating func changeSpeed(speedInMiles: Int)
    func changeDirection(direction: String)
}

// To define default implementation, a function implementation can be done in extension.
extension Runnable {
    func changeDirection(direction: String) {
        print("Change direction to \(direction)")
    }
    
    var isRunning: Bool {
        return false
    }
}

/*
 Types that confirm protocols need to make sure to have implementation of the variables and functions.
 */
struct Runner : Runnable {
    var runningSpeedInMiles: Int
    var isRunning: Bool = false
    var name: String
    
    mutating func run() {
        print("\(name) is running at the speed of \(runningSpeedInMiles) miles per hour.")
        isRunning = true
    }
    
    mutating func stop() {
        print("\(name) stopped running")
        self.isRunning = false
    }
    
    mutating func changeSpeed(speedInMiles: Int) {
        self.runningSpeedInMiles = speedInMiles
    }
}

var runner = Runner(runningSpeedInMiles: 5, name: "Suguru")

runner.run()
runner.changeSpeed(speedInMiles: 10)
runner.stop()

class FastRunner: Runnable {
    var runningSpeedInMiles: Int = 12
    var isRunning: Bool = false
    
    // since it's a class confirming to the Runnable protocol. mutating keyword can be omitted.
    func run() {
        print("A fast runner is running at the speed of \(runningSpeedInMiles) miles per hour.")
        isRunning = true
    }
    
    func stop() {
        print("A fast runner stopped running")
        self.isRunning = false
    }
    
    func changeSpeed(speedInMiles: Int) {
        self.runningSpeedInMiles = speedInMiles
    }
}

var fastRunner = FastRunner()

fastRunner.run()
fastRunner.changeSpeed(speedInMiles: 15)
fastRunner.stop()


/*
 2. Extensions
    Extensions let us add more meaning/functionalit to existing types or we can use them for protocol confirmance. Extensions let developers have Open-close principle: closed to modification but open to extension.
 */

// Adding an extesion function for Date type
extension Date {
    static func getDateFromStr(dateStr: String, dateFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: dateStr)
    }
}

// Getting a date from string
let aDate = Date.getDateFromStr(dateStr: "01/01/2024", dateFormat: "MM/dd/yyyy")
if let aDate { print(aDate) }

/*
 3. Properties and Different Types and Uses
    - Stored Properties
    - Computed Properties
    - Lazy Properties
 */

protocol WildAnimal {
    var runningSpeedInMiles: Int { get set }
}

extension WildAnimal {
    // Computed property: gets executed every time it gets called
    var walkingSpeedInMiles: Int {
        print("Computed property")
        return runningSpeedInMiles / 2
    }
}

class Cheetah : WildAnimal {
    // stored properties
    var runningSpeedInMiles = 75
    
    lazy var maxSpeed: Double = {
        print("Lazy property")
        return Double(runningSpeedInMiles) * 1.2
    }()
}

var cheetah = Cheetah()
print("Running speed: \(cheetah.runningSpeedInMiles) miles per hour")
print("Walking speed: \(cheetah.walkingSpeedInMiles) miles per hour")
// executes only once
print("Max speed: \(cheetah.maxSpeed) miles per hour")

cheetah.runningSpeedInMiles = 80
print("Running speed: \(cheetah.runningSpeedInMiles) miles per hour")
print("Walking speed: \(cheetah.walkingSpeedInMiles) miles per hour")
// the value does not change even afer assining a new value to runningSpeedInMiles.
// because an execusion already occured before assining a new value.
print("Max speed: \(cheetah.maxSpeed) miles per hour")


/*
    4. Generics
       Generics enables to write flexible and reusable code and avoid duplication of code. Since Swift does not support function overloading, using Generics is a good solution to write DRY code.
 */

// In order to define generics, you need to append <AnyNameForType: ActualType>. Each function parameters should have the same Type. If you want to have a return type this can be done by writing "-> TypeName"
func multiplyNumbers<T: Numeric>(num1 : T, num2: T) -> T {
    let res = num1 * num2
    print("Generics res = \(res)")
    return res
}

multiplyNumbers(num1: 2, num2: 3)
multiplyNumbers(num1: 2.5, num2: 2)
