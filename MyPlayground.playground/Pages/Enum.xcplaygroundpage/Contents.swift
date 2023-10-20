//: [Previous](@previous)

import Foundation

/*
 Enums
 Group of related data types
 Value type: stored in stack memory
 Immutable
 No inheritance
 */

enum Days: Int {
    case day1 = 1
    case day2
    case day3
    case day100 = 100
}

print(Days.day1.rawValue)
print(Days.day100.rawValue)

enum WeekDays : String, CaseIterable {
    case monday = "Monday", 
         tuesday = "Tuesday",
         wednesday = "Wednesday",
         thursday = "Thursday", 
         friday = "Friday",
         saturday = "Saturday",
         sunday = "Sunday"
    
    func dayType() -> String {
        switch self {
        case .sunday, .saturday:
            return "Weekend"
        default:
            return "Weekdays"
        }
    }
    
    var numberOfDays: Int {
        return 7
    }
}

print(WeekDays.friday.dayType())
print(WeekDays.monday.numberOfDays)

enum Ids: Int {
    case id1 = 1, id2, id3, id4, id5
}

print(WeekDays.monday)

print(Ids.id1.rawValue)
print(Ids.id2.rawValue)
print(Ids.id3.rawValue)
print(Ids.id4.rawValue)

// in order to iterate through enum, enum needs to confirm to CaseIterable
for val in WeekDays.allCases {
    print(val)
}

// Two types of enum
// 1. Raw Value Enum
// 2. Associated Type Enum

// 1. Raw Value Enum
enum VehicalBrand: String {
    case toyota = "Known for High Quality"
    case mercedes = "Known for High Prices"
    case honda = "Known for varients"
    case ford
}

print(VehicalBrand.toyota.rawValue)
print(VehicalBrand.mercedes.rawValue)
print(VehicalBrand.honda.rawValue)
print(VehicalBrand.ford.rawValue)

// 2. Associated Type Enum
enum VehicalPrices {
    case highEnd(price: Int)
    case lowEnd(price: Int)
    case midEnd(type: String)
    case noPricing
}

func getVehicalPrices(range: VehicalPrices) {
    switch range {
    case .highEnd(price: let price):
        if price > 1000 {
            print("it is a costly vehical")
        }
    case .lowEnd(price: let price):
        if price < 500 {
            print("it is a cheap vehicle")
        }
    case .midEnd(type: let type):
        print("Car type is \(type)")
    default:
        print("default")
    }
}

getVehicalPrices(range: .highEnd(price: 1200))
getVehicalPrices(range: .lowEnd(price: 400))
getVehicalPrices(range: .midEnd(type: "Civic Type R"))
getVehicalPrices(range: .noPricing)

enum NetworkError {
    case ResponseError(_ code: Int)
    case ParsingError
    case DataNotFoundError
}
