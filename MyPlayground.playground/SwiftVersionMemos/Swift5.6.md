# Swift 5.6

## Introduce existential `any`

SE-0335 introduces a new `any` keyword to mark existential types.

```
protocol Vehicle {
    func travel(to destination: String)
}

struct Car: Vehicle {
    func travel(to destination: String) {
        print("I'm driving to \(destination)")
    }
}

let vehicle = Car()
vehicle.travel(to: "London")
```

It's also possible to use protocols as generic type constraints in functions, meaning that we write code that can work with any kind of data that conforms to a particular protocol. For example, this will work with any kind of type that conforms to `Vehicle`:

```
func travel<T: Vehicle>(to destinations: [String], using vehicle: T) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}

travel(to: ["London", "Amarillo"], using: vehicle)
```

When that code complies, Swift can see we're calling `travel()` with a `Car` instance and so it is able to create optimized code to call the `travel()` function directly - a process known as static dispatch.

All this matters becuase there is a second way to use protocols, and it looks very similar to the other code we've used so far:

```
let vehicle2: Vehicle = Car()
vehicle2.travel(to: "Glasgow")
```

Here we are still creating a `Car` struct, but we're storing it as a `Vehicle`. This isn't just a simple matter of hiding the underlying information, but instead this `Vehicle` type is a whole other thing called in _exsistential type_: a new data type that is able to hold any value of any type that conforms to the `Vehicle` protocol.

**Important**: Existential types are different from opaque that use the `some` keyword, e.g. `some View`, which must always represent one specific type that conforms to whatever constraints you specify.

```
func travel2(to destinations: [String], using vehicle: Vehicle) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}
```

That might look similar to the other `travel()` function, but as this one acepts any kind of `Vehicle` object Swift can no longer perofrm the same set of optimizations - it has to use a process called _dynamic dispatch_, which is less efficient than the static dispatch available in the generic equivalent. So, Swift was in a position where both uses of protocols looked very similar, and actually the slower, existential version of our function was easier to write.

To resolve the problem, Swift 5.6 introduces a new `any` keyword for use with existential types, so that we're explicitliy acknowleding the impact of existentials in our code. In Swift 5.6 this new behavior is enabled and works, but in future Swift versions failing to use it will generate warnings, and from Swift 6 onwards the plan is to issue rrors - you will be required to mark existing types using `any`.

```
let vehicle3: any Vehicle = Car()
vehicle3.travel(to: "Glasgow")

func travel3(to destinations: [String], using vehicle: any Vehicle) {
    for destination in destinations {
        vehicle.travel(to: destination)
    }
}
```

## Type placeholders

SE-0315 introduces the concept of type placeholders, which allow us explicitly specify only some parts of a value's type so that the remainder can be filled in using type interface.

In practice, this means writing \_ as your type in any place you want Swift to use type inference, meaning that these three lines of code are the same:

```
let score1 = 5
let score2: Int = 5
let score3: _ = 5
```

```
var result1 = [
    "Cynthia": [],
    "Jenny": [],
    "Trixie": []
]

var results2: [String: [Int]] = [
    "Cynthia": [],
    "Jenny": [],
    "Trixie": []
]
```

```
var results3: [_: [Int]] = [
    "Cynthia": [],
    "Jenny": [],
    "Trixie": []
]
```

**Tip**: Type placeholders can be optional too use `_?` to have Swift infer your type as optional.

Types placeholders do _not_ affect the way we write function signatures: you must still provide their parameter and return types in full. However, I have found that type placeholders do still serve a purpose for when you're busy experimenting with a prototype: telling the compiler for want it to infer some type often prompts Xcode to offer a Fix-it to complete the code for you.

```
struct Player<T: Numeric> {
    var name: String
    var score: T
}

func createPlacer() -> _ {
    Player(name: "Anonymous", score: 0)
}
```

## Allow coding of none `String`/`Int` keyed `Dictionary` into a `KeyedContainer`

SE-0320 introduces a new `CodingKeyRepresentable` protocol that allows dictionaries with keys that aren't plain `String` or `Int` to be encoded as keyed containers rather than unkeyed containers.

To understand why this is important, you first need to see the behavior without `CodingKeyRepresentable` in place. As an example, this old code uses enum cases for keys in a dictionary, then encodes it to JSON and prints out the resulting string:

```
import Foundation

enum OldSettings: String, Codable {
    case name
    case twitter
}

let oldDict: [OldSettings: String] = [.name: "Paul", .twitter: "@twostraws"]
let oldData = try JSONEncoder().encode(oldDict)
print(String(decoding: oldData, as: UTF8.self))
```

Prints out:

```
["name","Paul","twitter","@twostraws"]
```

The new `CodingKeyRepresentable` resolves this, allowing the new dictionary keys to be written correctly.

```
enum NewSettings: String, Codable, CodingKeyRepresentable {
    case name
    case twitter
}

let newDict: [NewSettings: String] = [.name: "Paul", .twitter: "@twostraws"]
let newData = try! JSONEncoder().encode(newDict)
print(String(decoding: newData, as: UTF8.self))
```

Prints out:

```
"{"twitter":"@twostraws","name":"Paul"}"
```

## Unavailability condition

SE-0290 introduces an inverted form of `#available` called `#unavaialble`, which will run some code if an availability check fails.

This is going to be particularly useful in places where you were previously using `#available` with an empty true block becuase you only wanted to run the code if a specific system was _unavailable_.

Instead of this:

```
if #available(iOS 15, *) { } else {
    // Code to make iOS 14 and earlier work correctly
}
```

You can write this:

```
if #unavailable(iOS 15) {
    // Code to make iOS 14 and earlier work correctly
}
```

## More concurrency change

```
import SwiftUI

@MainActor class Settings: ObservableObject {}

struct OldContentView: View {
    @StateObject private var settings = Settings()

    var body: some View {
        Text("Hello, world!")
    }
}
```

```
struct NewContentView: View {
    @StateObject private var settings: Settings

    init() {
        _settings = StateObject(wrappedValue: Settings())
    }

    var body: some View {
        Text("Hello, world!")
    }
}
```
