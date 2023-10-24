//: [Previous](@previous)

import Foundation

/*
 Types of Properties in iOS
 */

protocol Maths {
    var radius: Double { get set }
}

// extensions don't have their own memory
extension Maths {
    // gets executed every time it gets called.
    var area: Double { // Compute Property
        print("Computed propety")
        return Double.pi * radius * radius // pi * r^2
    }
}

class Circle : Maths {
    // Double type varialbe called 'radius' and 100 is assigned to it by default
    var radius: Double = 100 // Stored Properties
    
    // lazy gets called only once
    // optimizing the cpu
    lazy var circumference: Double = { // 3. Lazy Property
        print("Lazy Property")
        return 2 * Double.pi * radius // 2 * pi * r
    }()

    init() {}
    
    init(radius: Double) {
        self.radius = radius
    }
}

var c1 = Circle()
print(String(c1.radius))
print(String(c1.area))
print(String(c1.circumference))
c1.radius = 200
print("after new assignment")
print(String(c1.area))
print(String(c1.circumference))
