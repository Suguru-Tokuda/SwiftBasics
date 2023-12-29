# Swift 5.4

## SE-0287 Improved implicit member syntax

Swift has already had the ability to use implicit member syntax for simple expressions, for example if you wanted to color some text in SwiftUI you could use `.red` rather than `Color.red`:

```
import SwiftUI

struct ContentView1: View {
    var body: some View {
        Text("You're not my supervisor!")
            .foregroundColor(.red)
    }
}
```

Prior to Swift 5.4 this did not work with more complex expressions. For example, if you wanted your red color to be slightly transparent you would need to write this:

```
struct ContentView2: View {
    var body: some View {
        Text("You're not my supervisor!")
            .foregroundColor(Color.red.opacity(0.5))
    }
}
```

From Swift 5.4 onwards the compiler is able to understand multiple chained members, meaning that the `Color` type can be inferred:

```
struct ContentView3: View {
    var body: some View {
        Text("You're not my supervisor!")
            .foregroundColor(.red.opacity(0.5))
    }
}
```

## SE-0284 Multiple variadic parameters in functions

SE-0284 introduced the ability to have functions, subscripts, and initializers use multiple variadic parameters as long as all parmeters that follow a variadic parameter have labels. Before Swift 5.4, you could only have one variadic parameter in this situation.

So, with this improvement in place we could write a function that accepts a variadic parameter storing the times goals were scored

```
import Foundation

func summarizeGoals(times: Int..., players: String...) {
    let joinedNames = ListFormatter.localizedString(byJoining: players)
    let joinedTimes = ListFormatter.localizedString(byJoining: times.map(String.init))

    print("\(times.count) goals where scored by \(joinedNames) at the follow minutes: \(joinedTimes)")
}

summarizeGoals(times: 18, 33, 55, 90, players: "Dani", "Jamie", "Roy")
```

## Creating variable that call a function of the same name

From Swift 5.4 onwards it's possible to create a local variable by calling a function of the same name. That might sound obscure, but it's actually a problem we hit all the time.

For example, this creates a struct with a `color(forRow:)` function, which gets called and assigned to a local varialbe called color:

```
struct Table {
    let count = 10

    func color(forRow row: Int) -> String {
        if row.isMultiple(of: 2) {
            return "red"
        } else {
            return "black"
        }
    }

    func printRows() {
        for i in 0..<count {
            let color = color(forRow: i)
            print("Row \(i): \(color)")
        }
    }
}

let table = Table()
table.printRows()
```

This usually resulted in either using `self.color(forRow: 1989)` to make it clear we mean the method call, or just naming the local value something else such as `colorForRow`.

```
struct User {
    let username = "Taylor"

    func suggestAlternativeUsername() -> String {
        var username = username
        username += String(Int.random(in: 1000...9999))
        return username
    }
}

let user = User()
user.suggestAlternativeUsername()
```

## Result builders

Function builders unofficially arrived in Swift 5.1, but in the run up to Swift 5.4 they formally went through the Swift Evolution proposal process as `SE-0289` in order to be discussed and refined. As part of that process they were renamed to result builders to better reflect their actual purpose, and even acquired some new functionality.

```
func makeSentence1() -> String {
    "Why settle for a Duke when you can have a Prince?"
}

print(makeSentence1())
```

```
// This is invalid Swift, and will not compile.
// func makeSentence2() -> String {
//     "Why settle for a Duke"
//     "when you can have"
//     "a Prince?"
// }
```

By itself, that code won't work because Swift no longer understands what we mean. However, we could create a result builder that understands how to convert several strings into one string using whatever transformation we want, like this:

```
@resultBuilder
struct SimpleStringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }
}
```

- The `@resultBuilder` attribute tells Swift the following type should be treated as a result builder. Previously this behavior was achieved using `@_functionBuilder`, which had an underscore to show that this wasn't designed for general use.
- Every result builder must provide at least one static method called `buildBlock()`, which should take in some sort of data and transform it. The example above takes in zero or more strings, joins them, and sends them back as a single string.
- The end result that our `SimpleStringBuilder` struct becomes a result builder, meaning that we can use @SimpleStringBuilder anywhere we need its string joining powers.

You can call the method like this:

```
let joined = SimpleStringBuilder.buildBlock(
    "Why settle for a Duke",
    "when you can have",
    "a Prince?"
)

print(joined)
```

However, becuase we used the `@resultBuilder` annotation with our `SimpleStringBuilder` struct, we can also apply that to functions, like this:

```
@SimpleStringBuilder func makeSentence3() -> String {
    "Why settle for a Duke"
    "when you can have"
    "a Prince?"
}

print(makeSentence3())
```

Advanced usage:

```
@resultBuilder
struct ConditionalStringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }

    static func buildEither(first component: String) -> String {
        return component
    }

    static func buildEither(second component: String) -> String {
        return component
    }
}
```

```
@ConditionalStringBuilder func makeSentence4() -> String {
    "Why settle for a Duke"
    "when you can have"

    if Bool.random() {
        "a Prince?"
    } else {
        "a King?"
    }
}

print(makeSentence4())
```

Similarly, we could add support for loops by adding a `buildArray()` function to our builder type:

```
@resultBuilder
struct ComplexStringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }

    static func buildEither(first component: String) -> String {
        return component
    }

    static func buildEither(second component: String) -> String {
        return component
    }

    static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "\n")
    }
}
```

And now we can use `for` loops:

```
@ComplexStringBuilder func countDown() -> String {
    for i in (0...10).reversed() {
        "\(i)…"
    }

    "Lift off!"
}

print(countDown())
```

## Local functions new support overloading

SR-10069 requested the ability to overload functions in local contexts, which in means nested functions can now be overloaded so that Swift chooses which one to run based on the types that are used.

```
struct Butter { }
struct Flour { }
struct Sugar { }

func makeCookies() {
    func add(item: Butter) {
        print("Adding butter…")
    }

    func add(item: Flour) {
        print("Adding flour…")
    }

    func add(item: Sugar) {
        print("Adding sugar…")
    }

    add(item: Butter())
    add(item: Flour())
    add(item: Sugar())
}
```

## Property wrappers are not supported for local variables

Property wrappers were first introduced in Swift 5.1 as a way of attaching extra functionality to properties in an easy, reusable way, but in Swift 5.4 their behavior got extended to support using them as local variables in functions.

```
import Foundation

@propertyWrapper struct NonNegative<T: Numeric & Comparable> {
    var value: T

    var wrappedValue: T {
        get { value }

        set {
            if newValue < 0 {
                value = 0
            } else {
                value = newValue
            }
        }
    }

    init(wrappedValue: T) {
        if wrappedValue < 0 {
            self.value = 0
        } else {
            self.value = wrappedValue
        }
    }
}

func playGame() {
    @NonNegative var score = 0

    // player was correct
    score += 4

    // player was correct again
    score += 8

    // player got one wrong
    score -= 15

    // player got another one wrong
    score -= 16

    print(score)
}

playGame()
```

The above line prints "0"

## Packages can now declare executable targets

SE-0294 adds a new target option for apps using Swift Packages manager, allowing us to explicity declare an executable target.

This is particularly import for folks who want to use SE-0281 (using @main to mark your program's entry point), because it didn't play nicely with Swift Package Manager - it would always look for a main.swift file.

With this change, we can now remove main.swift and use @main instead. **Note**: you must specify `// swift-tools-version:5.4` in your Package.swift file in order to get this new functionality.
