# Swift 5.0

## SE-0235 Included Result enum into the standard library

```
import Foundation

enum NetworkError: Error {
    case badURL
}

func fetchUnreadCount(from urlString: String, completionHandler: @escaping ((Result<Int, NetworkError>) -> ())) {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }

    // complicated networking code here
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}

fetchUnreadCount(from: "https://www.hackingwithswift.com") { result in

    switch result {
    case .success(let count):
        print("\(count) unread messages.")
    case .failure(let error):
        print(error.localizedDescription)
    }
}

fetchUnreadCount(from: "https://www.hackingwithswift.com") { result in
    if let count = try? result.get() {
        print("\(count) unread messages.")
    }
}

let someFile = URL(fileURLWithPath: "/path/to/file")
let result = Result { try String(contentsOf: someFile) }
```

## Flattening nested optionals from try?

```
struct User {
    var id: Int

    init?(id: Int) {
        if id < 1 {
            return nil
        }

        self.id = id
    }

    func getMessages() throws -> String {
        // complicated code here
        return "No messages"
    }
}

let user = User(id: 1)
let messages = try?.user?.getMessages()
```

## SE-2000 Raw Strings

```
import Foundation

let rain = #"The "rain" in "Spain" falls mainly on the Spaniards."#
let keypaths = #"Swift keypaths such as \Person.name hold uninvoked references to properties."#

let answer = 42
let dontpanic = #"The answer to life, the universe, and everything is \#(answer)."#


let str = ##"My dog said “wood”#gooddog"##

let multiline = #"""
the answer to life,
the universe,
and everything id \#(answer)
"""#

let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
```

## SE-0216 @dynamicCallable

@dynamicCallable can make developers ommit function names to call functions.

```
import Foundation

@dynamicCallable
struct RandomNumberGenerator {
    func dynamicallyCall(withArguments args: [Int]) -> Double {
        let numberOfZeros = Double(args[0])
        let maximum = pow(10, numberOfZeros)
        return Double.random(in: 0...maximum)
    }
}

let random = RandomNumberGenerator()
let result = random(5)
```

## SE-0225 Multiple of Integer

```
import Foundation

var four: Int = 4
print(four.isMultiple(of: 2))
```

## SE-0228 Improved string interpolation

```
import Foundation

struct User {
    var name: String
    var age: Int
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: User) {
        appendInterpolation("My name is \(value.name) and I'm \(value.age)")
    }
}

let user = User(name: "Suguru Tokuda", age: 36)
print("User details: \(user).")

extension String.StringInterpolation {
    mutating func appendInterpolation(_ number: Int, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style

        if let result = formatter.string(from: number as NSNumber) {
            appendInterpolation(result)
        }
    }
}

let number = Int.random(in: 0...100)
let lucky = "The lucky number this week is \(number, style: .spellOut)."
print(lucky)

extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendInterpolation(str)
        }
    }
}

print("Baby shark \(repeat: "doo\n", 6)")

extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [String], empty defaultValue: @autoclosure () -> String) {
        if values.count == 0 {
            appendInterpolation(defaultValue())
        } else {
            appendInterpolation(values.joined(separator: ", "))
        }
    }
}

//let names = ["Harry", "Ron", "Harmione"]
let names = [String]()
print("List of students: \(names, empty: "No one").")

func printString(_ value: @autoclosure () -> String) {
    print(value())
}

func generateString() -> String {
    return "I'm an iOS Developer"
}

printString("Hello World")
printString(generateString())

struct HTMLComponent: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    struct StringInterpolation: StringInterpolationProtocol {
        // start with an empty string
        var output = ""

        // allocate enough space to hold twice the amount of literal text
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }

        mutating func appendLiteral(_ literal: StringLiteralType) {
            print("Appending \(literal)")
            output.append(literal)
        }

        // a Twitter username - add it as a link
        mutating func appendInterpolation(twitter: String) {
            print("Appending \(twitter)")
            output.append("<a href=\"https://twitter.com/\(twitter)\">@\(twitter)</a>")
        }

        // ane email address - addd it using mailto:
        mutating func appendInterpolation(email: String) {
            print("Appending \(email)")
            output.append("<a href=\"mailto:\(email)/>(email)</a>")
        }
    }

    // the finished text for this whole component
    let description: String

    // create an instance from a literal string
    init(stringLiteral value: String) {
        description = value
    }

    // create an instance
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
    }
}

let text: HTMLComponent = "You should follow me on Twitter \(twitter: "twostraws"), or you can email me at \(email: "paul@hackingwithswift.com")"
print(text)
```

## SE-0218 Improved compactMapValues

```
import Foundation

// Prior to 5.0
let times = [
    "Hudson": "38",
    "Clarke": "42",
    "Robinson": "35",
    "Hartis": "DNF"
]

let finishers1 = times.compactMapValues { Int($0) }
let finishers2 = times.compactMapValues(Int.init)

// From 5.0
let people = [
    "Paul": 38,
    "Sophie": 8,
    "Charlotte": 5,
    "William": nil
]

let knownAges = people.compactMapValues { $0 }
```

## SE-0192 Non-exhaustive enums

```
import Foundation

enum PasswordError: Error {
    case short, obvious, simple
}

func showOld(error: PasswordError) {
    switch error {
    case .short:
        print("Your password was too short.")
    case .obvious:
        print("Your password was too obvious.")
    @unknown default:
        print("Your password was too simple.")
    }
}
```
