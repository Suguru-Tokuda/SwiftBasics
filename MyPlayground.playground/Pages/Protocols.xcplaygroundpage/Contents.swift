//: [Previous](@previous)

import Foundation

// Protocols - Interface
/*
 Protocol - the list of rules or blueprint which class or struct or anyone who adopts/confirms it, needs to give implementation for function/variables.
 
 Any class, struct, enum can conirm to protocols.
 
 Enables polyphormism in Swift.
 Abstract means that there is no implementation.
 */
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

//enum DriveDirection : Driveable {
//    case left, right
//    
//    func accelerate(speed: Int) {
//        print("Accelerating Electric car by \(speed)")
//    }
//    
//    func applyBreaks() {
//        print("Applying breaks for Electric car")
//    }
//}
//
//let d1 = DriveDirection()
