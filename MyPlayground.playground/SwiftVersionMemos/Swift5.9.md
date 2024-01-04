# Swift 5.9

## `if` and `switch` expressions

SE-0380 adds the ability for us to use `if` and `switch` as expressions in several situations. This produces syntax that will be a little surprising at first, but overall it does help reduce a little extra syntax in the language.

```
let score = 800
let simpleResult = if score > 500 { "Pass" } else { "Fail" }
print(simpleResult)
```

Or we could use a `switch` expression to get a wider range of values like this:

```
let complexResult = switch score {
    case 0...30: "Fail"
    case 301...500: "Pass"
    case 501...800: "Merit"
    default: "Distribution"
}

print(complexResult)
```

You don't need to assign the result somewhere in order to use this new expression syntax, and in fact it combines beautifully with SE-0255 from Swift 5.1 that allows us to omit the `return` keyword in a single expression functions that return a value.

So, because both `if` and `switch` can now both be used as expressions, we can write a function like ths one without using `return` in all four possible cases:

```
func rating(for scotre: Int) -> String {
    switch score {
    case 0...30: "Fail"
    case 301...500: "Pass"
    case 501...800: "Merit"
    default: "Distinction"
    }
}

print(rating(for: score))
```

You might be thinking this feature makes `if` work more like the ternary conditional operator, and you'd be at least partly right. For example, we could have written our simple `if` condition from earlier like this:

```
let ternaryResult = score > 500 ? "Pass" : "Fail"
print(ternaryResult)
```

However, the two are not identical, and there is one place in particular that might catch you out – you can see it in this code

```
let customerRating = 4
let bonusMultiplier1 = customerRating > 3 ? 1.5 : 1
let bonusMultiplier2 = if customerRating > 3 { 1.5 } else { 1.0 }
```

This is intentional: when using the ternary Swift checks the types of both values at the same time and so automatically considers 1 to be 1.0, whereas with the `if` expression the two options are type checked independently: if we use 1.5 for one case and 1 for the other then we'll be sending back a `Double` and an `Int`, which is't allowed:

## Value and Type Paramter Packs

SE-0393, SE-0398, and SE-0399 combined to form a rather dense knot of imporvements to Swift that allow us to use variadic generics.

As an example, we could have three different structs that represent different parts of our program:

```
struct FrontEndDev {
    var name: String
}

struct BackEndDev {
    var name: String
}

struct FullStackDev {
    var name: String
}
```

In practice they would have lots more properties that make those types unique, but you get the point - three different types exist.

```
let johnny = FrontEndDev(name: "Johnny Appleseed")
let jess = FrontEndDev(name: "Jessica Appleseed")
let kate = BackEndDev(name: "Kate Bell")
let kevin = BackEndDev(name: "Kevin Bell")

let derek = FullStackDev(name: "Derek Derekson")
```

And then when it came to actually doing work, we could pair developers together using a simple function like this one:

```
func pairUp1<T, U>(firstPeople: T..., secondPeople: U...) -> ([(T, U)]) {
    assert(firstPeople.count == secondPeople.count, "You must provide equal numbers of people to pair.")
    var result = [(T, U)]()

    for i in 0..<firstPeople.count {
        result.append((firstPeople[i], secondPeople[i]))
    }

    return result
}
```

```
let result1 = pairUp1(firstPeople: johnny, jess, secondPeople: kate, kevin)
```

```
func pairUp2<each T, each U>(firstPeople: repeat each T, secondPeople: repeat each U) -> (repeat (first: each T, second: each U)) {
    return (repeat (each firstPeople, each secondPeople))
}
```

1. `<each T, each U>` creates two type paramter packs, `T` and `U`.
2. `repeat each T` is a pack expansion, which is what expands the paramter pack into actual values - it's the equivalent of `T...`, but avoids some confusion with `...` being used as an operator.
3. The return type means we're sending back tuples of paired programmers, one each from `T` and `U`.
4. Our `return` keyword is what does the real work: it uses a pack expansion expression to take one value from `T` and one from `U`, putting them together into the returned value.

What it _doesn't_ show is that the return type automatically ensures both our `T` and `U` types have the same _shape_ - they have the same number of items inside them. So, rather than using `assert()` like we had in the first function, Swift will simply issue a compiler error if we try to pass in two sets of data of different sizes.

```
let result2 = pairUp2(firstPeople: johnny, derek, secondPeople: kate, kevin)
```

Now, what we’ve actually done is implement a simple `zip()` function, which means we can write nonsense like this:

```
let result3 = pairUp2(firstPeople: johnny, derek, secondPeople: kate, 556)
```

```
func pairUp3<each T: WritesFrontEndCode, each U: WritesBackEndCode>(firstPeople: repeat each T, secondPeople: repeat each U) -> (repeat (first: each T, second: each U)) {
    return (repeat (each firstPeople, each secondPeople))
}
```

## Macros

SE-0382, SE-0389, and SE-0397 combine to add macros to Swift, which allow us to create code that transforms syntax at compile time.

**Note**: Macros are complicated and rather tricky to work with right now: below is my best understanding of them having worked with them for a few weeks.

Macros in something like C++ are a way to pre-process your code - to effectively perform text replacement on the code before it's seen by the main compiler, so that you can generate code you really don't want to write by hand.

Swift's macros are similar, but significantly more powerful - and thus also significantly more complex. They also allow us to dynamically manipulate our project's Swift code before it's complied, allowing us to inject extra functionality a compile time.

- They are type-safe ratherthan simple string replacements, so you need to tell your macro exactly what data it will work with.
- They run as external programs during the build phase, and do not like in your main app target.
- Macros are broken down into multiple smaller types, such as `ExpressionMacro` to generate a single expression, `AccessorMacro` to add getters and setters, and `ConformanceMacro` to make a type conform to a protocol.
- Macros work with your parsed source code - we can query individual parts of the code, such as the name of a property we're manipulating or it types, or the various properties inside a struct.

The last part is particularly important: Swift's macros support are built around Apple's SwiftSyntax library for understanding and manipulating source code. You must add this as a dependency for your macros.

The following code turns `#buildDate` into something like **2023-06-05T18:00:00Z**:

```
public struct BuildDateMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) -> ExprSyntax {
        let date = ISO8601DateFormatter().string(from: .now)
        return "\"\(row: date)\""
    }
}
```

**Important**: This code should not be in your main app target; we don’t want that code being compiled into our finished app, we just want the finished date string in there.

Inside that same module we create a struct that conforms to the `CompilerPlugin` protocol, exporting our macro:

```
import SwiftCompilerPlugin
import SwiftSyntaxMacros


@main
struct MyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BuildDateMacro.self
    ]
}
```

We would then add that to our list of targets in Package.swift:

```
.macro(
  name: "MyMacrosPlugin",
  dependencies: [
    .product(name: "SwiftSyntax", package: "swift-syntax"),
    .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
    .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
  ]
),
```

This takes two steps, starting with

```
@freestanding(expression)
macro buildDate() -> String = #externalMacro(module: "MyMacroPlugin", type: "BuildDateMacr")
```

And the second step is to actually use the maro, like this:

```
print(#buildDate)
```

When you read through this code, the most important thing to take away is that the main macrofunctionality - all that code inside the `BuildDateMacro` struct - is run at build time, with its results being injected back into the call sites. So, our little `print()` call above would be rewritten to something like this

```
print("2023-06-05T18:00:00Z")
```

```
public struct AllPublishedMaro: MemberAttributeMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingAttributesFor member: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AttributeSyntax] {
        [AttributeSyntax(attributeName: SimpleTypeIdentifierSyntax(name: .identifier("Published")))]
    }
}
```

Second, include that in your list of provided macros:

```
struct MyMacroPlugin: CompilerPuglin {
    let providingMacros: [Macro.Type] = [
        BuildDateMacro.self,
        AllPublishedMacro.self
    ]
}
```

Third, declare the macro in your main app target, this time making it as in atached member-attribue macro:

```
@attached(memberAttribute)
macro AllPublished() = #externalMacro(module: "MyMacrosPlugin", type: "AllPublishedMacro")
```

And now use it to annotate your observable object class:

```
@AllPublished class User: ObservableObject {
    var username = "Taylor"
    var age = 26
}
```

## Noncopyable strucs and enums

SE-0390 introduces the concept of structs and enums that cannot be copied, which in turn allows a single instance of a struct or enum to be shared in many places - they still ultimately have one owner, but can now be accessed in various parts of your code.

```
struct User: ~Copyable {
    var name: String
}
```

Note: Noncoyable types cannot conform to any protocols other than `Sendable`.

Once you create a `User` instance, its noncopyable nature means that it's used very differently from previous versions of Swift. For example, this kind of code might read like nothing special:

```
func createUser() {
    let newUser = User(name: "Anonymous")

    var userCopy = newUser
    print(userCopy.name)
}

createUser()
```

First, here's some code that uses a deinitializer with a class:

```
class Movie {
    var name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("\(name) is no longer available")
    }
}

func watchMovie() {
    let movie = Movie(name: "Godzilla Minums One")
    print("Watching \(movie.name)")
}

watchMovie()
```

```
struct HighScore: ~Copyable {
    var value = 0

    consuming func finalize() {
        print("Saving score to disk…")
        discard self
    }

    deinit {
        print("Deinit is saving score to disk…")
    }
}

func createHighScore() {
    var highScore = HighScore()
    highScore.value = 20
    highScore.finalize()
}

createHighScore()
```

- Classes and actors cannot be noncopyable.
- Noncopyable types don't support generics at this time, wich rules out optional noncopyable objects and also arrays of noncopyable objects for the time being.
- If you use a noncopyable type as a property inside another struct or enum, that parent struct or enum must also be noncopyable.
- You need to be very careful adding or removing `Copyable` from existing types, because it dramatically changes how they are used.

## `consume` operator to end the lifetime of a variable binding

```
struct User {
    var name: String
}

func createUser() {
    let newUser = User(name: "Anonymous")
    let userCopy = consume newUser
    print(userCopy.name)
}

createUser()
```

1. It copies the value from `newUser` into `userCopy`.
2. It ends the lifetime of `newUser`, so any further attempt to access it will throw up an error.

```
func consumeUser() {
    let newUser = User(name: "Anonymous")
    _ = consume newUser
}
```

```
func createAndProcessUser() {
    let newUser = User(name: "Anonymous")
    process(user: consume newUser)
}

func process(user: User) {
    print("Processing \(name)…")
}

createAndProcessUser()
```

```
func greetRandomly() {
    let user = User(name: "Taylor Swift")

    if Bool.random() {
        let userCopy = consume user
        print("Hello, \(userCopy.name)")
    } else {
        print("Greetings, \(user.name)")
    }
}

greetRandomly()
```

## Convenience Async[Throwing]Stream.makeStream

SE-0388 adds a new `makeStream()` function to both `AsyncStream` and `AsyncThrowingStream` that sends back both the stream itself alongside its continuation.

```
var continuation: AsyncStream<String>.Continuation!
var stream = AsyncStream<String> { continuation = $0 }
```

We can now get both at the same time:

```
let (stream, continuation) = AsyncStream.makeStream(of: String.self)
```

```
struct OldNumberGenerator {
    private var continuation: AsyncStream<Int>.Continuation!
    var stream: AsyncStream<Int>!

    init() {
        stream = AsyncStream(Int.self) { continuation in
            self.continuation = continuation
        }
    }

    func queueWork() {
        Task {
            for i in 1...10 {
                try await Task.sleep(for: .seconds(1))
                continuation.yield(i)
            }

            continuation.finish()
        }
    }
}
```

## Add sleep(for:) to Clock

SE-0374 adds a new extension function to Swift's `Clock` protocol.

```
class DataController: ObservableObject {
    var clock: any Clock<Duration>

    init(clock: any Clock<Duration>) {
        self.clock = clock
    }

    func delayedSave() async throws {
        try await clock.sleep(for: .seconds(1))
        print("Saving...")
    }
}
```

Old code:

```
try await Task.sleep(until: .now + .seconds(1), tolerance: .seconds(0.5))
```

New code:

```
try await Task.sleep(for: .seconds(1), tolerance: .seconds(0.5))
```

## Discarding task groups

```
struct FileWatcher {
    // The URL we're watching for file changes.
    let url: URL

    // The set of URLs we've already returned.
    private var handled = Set<URL>()

    init(url: URL) {
        self.url = url
    }

    mutating func next() async throws -> URL? {
        while true {
            // Read the latest contents of our directory, or exist if a problem occured.
            guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
                return nil
            }

            // Figure out which URLs we haven't already handled.
            let unhandled = handled.symmetricDifference(contents)

            if let newURL = unhandled.first {
                // If we already handled this URL then i must be deleted.
                if handled.contains(newURL) {
                    handled.remove(newURL)
                } else {
                    // Otherwise this URL is new, so mark it as handled.
                    handled.insert(newURL)
                    return newURL
                }
            } else {
                // No file difference: sleep for a few seconds then try again.
                try await Task.sleep(for: .microseconds(1000))
            }
        }
    }
}

struct FileProcessor {
    static func main() async throws {
        var watcher = FileWatcher(url: URL(filePath: "/Users/twostraws"))

        // new code
        try await withThrowingDiscardingTaskGroup { group in
            while let newURL = try await watcher.next() {
                group.addTask {
                    process(newURL)
                }
            }
        }

        // with this code, group.next() needed to be called in order to discard the current task.
        try await withThrowingTaskGroup(of: Void.self) { group in
            while let newURL = try await watcher.next() {
                group.addTask {
                    process(newURL)
                }
            }
        }
    }

    static func process(_ url: URL) {
        print("Processing \(url.path())")
    }
}

```
