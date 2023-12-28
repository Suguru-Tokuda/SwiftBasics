# Swift 5.1

## SE-0242 Improvements to memberwise initializers

```
import Foundation

struct User {
    var name: String
    var loginCount: Int = 0
}

// Prior to 5.1
let piper = User(name: "Piper Chapman", loginCount: 0)
let gloria = User(name: "Gloria Mandoza", loginCount: 0)
// From 5.1
let suzanne = User(name: "Suzanne Warren")
```

## SE-0255 Implicit returns from single-expression functions

No need to have a `return` keyword if the first line of code has the return value itself.

```
import Foundation

let double1 = [1, 2, 3].map { $0 * 2 }
let double2 = [1, 2, 3].map { return $0 * 2 }

func double(_ number: Int) -> Int {
    number * 2
}
```

## SE-0068 Universal Self

```
import Foundation

class NetworkManager {
    class var maximumActiveRequests: Int {
        return 4
    }

    func printDebugData() {
        // Without Self, the sub classes will print 4
        print("Maximum network requests: \(Self.maximumActiveRequests).")
    }
}

class ThrottoledNetworkManager: NetworkManager {
    override class var maximumActiveRequests: Int {
        return 1
    }
}

let manager = ThrottoledNetworkManager()
manager.printDebugData()
```

## SE-0244 Opaque return types

```
import Foundation

protocol Fighter {}
struct XWing: Fighter {}

func launchFighter() -> some Fighter {
    XWing()
}

let red5 = launchFighter()

func makeInt() -> some Equatable {
    Int.random(in: 1...10)
}

let int1 = makeInt()
let int2 = makeInt()
print(int1 == int2)

func makeString() -> some Equatable {
    "Red"
}

protocol ImperialFighter {
    init()
}

struct TIEFighter: ImperialFighter {}
struct TIEAdvanced: ImperialFighter {}

func launchImperialFighter<T: ImperialFighter>() -> T {
    T()
}

let fighter1: TIEFighter = launchImperialFighter()
let fighter2: TIEAdvanced = launchImperialFighter()
```

## SE-0254 Static and class subscripts

```
import Foundation

public enum OldSettings {
    private static var values = [String: String]()

    static func get(_ name: String) -> String? {
        values[name]
    }

    static func set(_ name: String, to newValue: String?) {
        print("Adjusting \(name) to \(newValue ?? "nil")")
        values[name] = newValue
    }
}

OldSettings.set("Captain", to: "Gray")
OldSettings.set("Friend", to: "Mooncake")
print(OldSettings.get("Captain") ?? "Unknown")

public enum NewSettings {
    private static var values = [String: String]()

    public static subscript(_ name: String) -> String? {
        get {
            return values[name]
        }

        set {
            print("Adjusting \(name) to \(newValue ?? "nil")")
            values[name] = newValue
        }
    }
}

NewSettings["Captain"] = "Gary"
NewSettings["Friend"] = "Mooncake"
print(NewSettings["Captain"] ?? "Unknown")
```

## Warnings for ambiguous none cases

```
import Foundation

enum BorderStyle {
    case none
    case solid(thickness: Int)
}

let border1: BorderStyle = .none
print(border1)

let border2: BorderStyle? = .none // Assuming you mean 'Optional<BorderStyle>.none'; did you mean 'BorderStyle.none' instead?
print(border2) // Expression implicitly coerced from 'BorderStyle?' to 'Any'
```

## Matching optional enums against non-optionals

```
import Foundation

enum BuildStatus {
    case starting
    case inProgress
    case complete
}

let status: BuildStatus? = .inProgress

switch status {
case .starting:
    print("Build is starting...")
case .inProgress:
    print("Build is complete")
case .complete:
    print("Build is complete")
default:
    print("Some other build status")
}
```

## SE-0240 Ordered collection diffing

```
import Foundation

var scores1 = [100, 91, 95, 98, 100]
var scores2 = [100, 98, 95, 91, 100]

if #available(iOS 13, *) {
    let diff = scores2.difference(from: scores1)

    for change in diff {
        switch change {
        case .remove(let offset, _, _):
            scores1.remove(at: offset)
        case .insert(let offset, let element, _):
            scores1.insert(element, at: offset)
        }
    }

    print(scores1)
}

if #available(iOS 13, *) {
    let diff = scores2.difference(from: scores1)
    let result = scores1.applying(diff) ?? []
}
```

## SE-0245 Creating uninitialized arrays

```
import Foundation

let randonNumbers = Array<Int>(unsafeUninitializedCapacity: 10) { buffer, initializedCount in
    for x in 0..<10 {
        buffer[x] = Int.random(in: 0...10)
    }

    initializedCount = 10
}

// Can be done with map, however, less efficient. It creates a range, a new empty array, size up the correct amount, close the range with each item.
let randomNumbers2 = (0...9).map { _ in Int.random(in: 0...10) }
```
