//: [Previous](@previous)

import Foundation

/**
    Assignment 7
    Suguru Tokuda
    10/27/2023
 */

/*
    MARK: Memory Management
 
    ARC (Automatic Reference Counting), in Swift, counts the number of strong references. Once objects are no longer used, they will be removed from the heap memory. It works with only reference type.
 */

class Vehicle {
    var make: String
    var model: String
    var year: Int

    init(make: String, model: String, year: Int) {
        self.make = make
        self.model = model
        self.year = year
    }
}

class Engine {
    var hoursePower: Int
    var car: Vehicle?
    
    init(hoursePower: Int) {
        self.hoursePower = hoursePower
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}

// referenceCount: 0
var engine1: Engine? = Engine(hoursePower: 200) // increasing the count to 1
var engine2 = engine1 // increasing the count to 2

engine1 = nil // decreasing the count to 1
engine2 = nil // decreasing the count to 0

class Break {
    var breakingPower: Int
    var car: Vehicle?
    
    init(breakingPower: Int) {
        self.breakingPower = breakingPower
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}

class HatchBack : Vehicle {
    var engine: Engine?
    var vehicleBreak: Break?
    
    override init(make: String, model: String, year: Int) {
        super.init(make: make, model: model, year: year)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
        self.engine = nil
        self.vehicleBreak = nil
    }
}

// MARK: 1. strong refrence
var engine: Engine? = Engine(hoursePower: 250)
var vehicleBreak: Break? = Break(breakingPower: 50)

var civic: HatchBack? = HatchBack(make: "Honda", model: "Civic Type R", year: 2023)

engine?.car = civic
vehicleBreak?.car = civic

civic?.engine = engine
civic?.vehicleBreak = vehicleBreak

// MARK: Retain Cycle Issue
// After assining nil to car, deinit function is called for the Car class
// deinit for Engine and VehicleBreak classes are not called, because
// refrences for engine and vehicleBreak are still remained in the counter.
civic = nil
engine = nil
vehicleBreak = nil

// MARK: 2. weak reference
class Sedan : Vehicle {
    weak var engine: Engine?
    weak var vehicleBreak: Break?
    
    override init(make: String, model: String, year: Int) {
        super.init(make: make, model: model, year: year)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
        self.engine = nil
        self.vehicleBreak = nil
    }
}

var focus: Sedan? = Sedan(make: "Ford", model: "Fusion", year: 2010)
var focusEngine: Engine? = Engine(hoursePower: 280)
var focusBreak: Break? = Break(breakingPower: 30)

focus?.engine = focusEngine
focus?.vehicleBreak = focusBreak

engine?.car = focus
focusBreak?.car = focus
// Sedan, Engine, and Break objects are destroyed even though they are referencing each other.
print("Weak reference:")
focus = nil
focusEngine = nil
focusBreak = nil

/*
 MARK: 3. unowned reference
 Similar to weak reference which prevents Retain Cycle Issue, however, the reference needs to keep holding value otherwise the code crashes.
 */

class SUV : Vehicle {
    unowned var engine: Engine? = nil
    unowned var vehicleBreak: Break? = nil
    
    override init(make: String, model: String, year: Int) {
        super.init(make: make, model: model, year: year)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
        // the following code should never be called inside SUV class???
//        self.engine = nil
//        self.vehicleBreak = nil
    }
}

// by creating a reference for compassEngine and compassBreak
var compass: SUV? = SUV(make: "Jeep", model: "Compass", year: 2023)
var compassEngine: Engine? = Engine(hoursePower: 300)
var compassBreak: Break? = Break(breakingPower: 60)

compass?.engine = Engine(hoursePower: 300)
compass?.vehicleBreak = Break(breakingPower: 60)

compassEngine?.car = compass
compassBreak?.car = compass

print("unowned reference:")
compass?.engine = nil
compass?.vehicleBreak = nil

compassEngine = nil
compassBreak = nil
// the following code crahses, because, SUV has Engine and Break as unowned. When compass gets destroyed, the reference inside SUV class will be set to nil. Unowned references cannot be nil
compass = nil

// without declaring variables. Directly assign values to class properties.
compass = SUV(make: "Jeep", model: "Compass", year: 2023)
compass?.engine = Engine(hoursePower: 300) // Instance will be immediately deallocated because property 'engine' is 'unowned'
compass?.vehicleBreak = Break(breakingPower: 60) // Instance will be immediately deallocated because property 'vehicleBreak' is 'unowned'

/*
 THE FOLLOWING CODE CLASHES:
 Fatal error: Attempted to read an unowned reference but object 0x600000214e60 was already deallocated
 */
//compass?.engine?.car = compass
//compass?.vehicleBreak?.car = compass

print("unowned reference 2:")
compass?.engine = nil
compass?.vehicleBreak = nil
compass = nil

/*
    MARK: Concurrency / Multi Threading
 
    The modern CPUs can process multiple processes in pararell. Swift provides concurrency / multi threading.
 */

/* 
 MARK: 1. GCD - Grand Central Dispatch
 Queus basically add code executions into a stack (FIFO) and they get executed one by one.
 */

/*
 MARK: Main Queue - Main Thread
 In iOS Development, Main Queue is used to update the UI.
 */

DispatchQueue.main.async {
    print("Main thread A started")
    
    for i in 0...500 {
        if i / 100 > 0 {
            print(i)
        }
    }
    print("Main thread B started")
}

/*
    MARK: Serial Queue / Custom Queue
    Serial Queue push code executions into stack. Each execusion in the stack depends on the call that comes first. For eample, if there are task A, B, and C. B cannot start until A ends, and C cannot start and C ends.
 */
let serialQueue = DispatchQueue(label: "serialQueue")

serialQueue.async {
    print("Serial Task A started")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("Slept for 2 sseconds")
        print("Task A finished in the main thread")
    }
    
    print("Serial Task A finished")
}

// Starts after Task A finishes
serialQueue.async {
    print("Serial Task B started")
    
    for i in 0..<100 {
        print("Serial task B - \(i)")
    }
    
    print("Serial Task B finished")
}

// Starts after Task B finishes
serialQueue.async {
    print("Serial Task C started")
    
    for i in 0..<150 {
        print("Serial task C - \(i)")
    }
    
    print("Serial Task C finished")
}

/* 
 MARK: Concurrency
 With concurency, the order of tasks executed in the queue don't depend on the tasks that are initiated already. It aslo does not need to wait for the precedent tasks to finish.
 */
let concurrentQueue = DispatchQueue(label: "concurrency", attributes: .concurrent)

// Concurrent Task A
concurrentQueue.async {
    print("Concurrent Task A started")
    for i in 0..<1000 {
        print("Concurrent Task A - \(i)")
    }
    print("Concurrent Task A finished")
}

// Concurrent Task B: finishes before Concurrent Task A & C finishes
concurrentQueue.async {
    print("Concurrent Task B started")
    for i in 0..<10 {
        print("Concurrent Task B - \(i)")
    }
    print("Concurrent Task B finished")
}

// Concurrent Task C: finishes before Concurrent Task A finishes but after B finishes
concurrentQueue.async {
    print("Concurrent Task C started")
    for i in 0..<100 {
        print("Concurrent Task C - \(i)")
    }
    print("Concurrent Task C finished")
}
