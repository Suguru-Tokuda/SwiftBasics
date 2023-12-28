# Swift 5.2

## SE-0049 Key Path Expression as Functions

```
import Foundation

struct User {
    let name: String
    let age: Int
    let bestFriend: String?

    var canVote: Bool {
        age >= 18
    }
}

let eric = User(name: "Eric Effiong", age: 18, bestFriend: "Otis Milburn")
let maeve = User(name: "Maeve Wiley", age: 19, bestFriend: nil)
let otis = User(name: "Otis Milburn", age: 17, bestFriend: "Eric Effiong")
let users = [eric, maeve, otis]

let userNames = users.map(\.name)
print(userNames)

let oldUserNames = users.map { $0.name }
let voters = users.filter(\.canVote)
let bestFriends = users.compactMap(\.bestFriend)
```

## SE-0253 Callable values of user-defined nominal types

If you have `callAsFunction` defined in a struct or class, then the object itself can be called as a function with `()` after the variable name.

```
import Foundation

struct Dice {
    var lowerBound: Int
    var upperBound: Int

    func callAsFunction() -> Int {
        (lowerBound...upperBound).randomElement()!
    }
}

let d6 = Dice(lowerBound: 1, upperBound: 6)
let roll1 = d6()
print(roll1)

// same
let d12 = Dice(lowerBound: 1, upperBound: 12)
let roll12 = d12.callAsFunction()
print(roll12)

struct StepCounter {
    var steps = 0

    mutating func callAsFunction(count: Int) -> Bool {
        steps += count
        print(steps)
        return steps > 10_000
    }
}

var steps = StepCounter()
let targetReached = steps(count: 10)
```

## Subscripts can now declare default arguments

```
struct PoliceForce {
    var officers: [String]

    subscript(index: Int, default default: String = "Unknown") -> String {
        if index >= 0 && index < officers.count {
            return officers[index]
        } else {
            return `default`
        }
    }
}

let force = PoliceForce(officers: ["Amy", "Jake", "Rosa", "Terry"])
print(force[0])
print(force[5])

print(force[-1, default: "The Vulture"])
```

## Lazy filtering order is now reversed

```
import Foundation

let people = ["Arya", "Cersei", "Samwell", "Stannis"]
    .lazy
    .filter { print($0); return $0.hasPrefix("S") }
    .filter { print($0); return true }
_ = people.count
```

In Swift 5.2 and later that will print “Samwell” and “Stannis”, because after the first filter runs those are the only names that remain to go into the second filter. But before Swift 5.2 it would have returned all four names, because the second filter would have been run before the first one. This was confusing, because if you removed the `lazy` then the code would always return just Samwell and Stannis, regardless of Swift version.

This is particularly problematic because the behavior of this depends on where the code is being run: if you run Swift 5.2 code on iOS 13.3 or earlier, or macOS 10.15.3 or earlier, then you’ll get the old backward behavior, but the same code running on newer operating systems will give the new, correct behavior.

So, this is a change that might cause surprise breakages in your code, but hopefully it’s just a short-term inconvenience.

## New and Improved diagnostics

```
import SwiftUI

struct ContentView: View {
    @State private var name = 0

    var body: some View {
        VStack {
            Text("What is your name?")
            TextField("Name", text: $name) // Cannot convert value of type 'Binding<Int>' to expected argument type 'Binding<String>'
                .frame(maxWidth: 300)
        }
    }
}
```
