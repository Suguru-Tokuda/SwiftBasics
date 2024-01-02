# Swift 5.5

# Async/await

SE-0296 introduces asynchronous (async) functions into Swift, allowing us to run complex asyncrhonous code almost as if it were syncronous. This is done in two steps: marking async functions with the new `async` keyword, then calling them using the `await` keyword, similar toother languages such as C# and JavaScript.

With an escaping closure

```
func fetchWeatherHistory(completion: @escaping ([Double]) -> Void) {
    // Complex networking code here; we'll just send back 100,000 random temperatures
    DispatchQueue.global().async {
        let results = (1...100_000).map { _ in Double.random(in: -10...30) }
        completion(results)
    }
}

func calculateAverageTemperature(for records: [Double], completion: @escaping (Double) -> Void) {
    // Sum our array then divide by the array size
    DispatchQueue.global().async {
        let total = records.reduce(0, +)
        let average = total / Double(records.count)
        completion(average)
    }
}

func upload(result: Double, completion: @escaping (String) -> Void) {
    // More complex networking code; we'll just send back "OK"
    DispatchQueue.global().async {
        completion("OK")
    }
}
```

```
fetchWeatherHistory { records in
    calculateAverageTemperature(for: records) { average in
        upload(result: average) { response in
            print("Server response: \(response)")
        }
    }
}
```

From Swfit 5.5

```
func fetchWeatherHistory() async -> [Double] {
    (1...100_000).map { _ in Double.random(in: -10...30) }
}

func calculateAverageTemperature(for records: [Double]) async -> Double {
    let total = records.reduce(0, +)
    let average = total / Double(records.count)
    return average
}

func upload(result: Double) async -> String {
    "OK"
}
```

That has already removed a lot of the syntax around returning values asynchronously, but at the call site it's even cleaner:

```
func processWeather() async {
    let records = await fetchWeatherHistory()
    let average = await calculateAverageTemperature(for: records)
    let response = await upload(result: average)
    print("Server response: \(response)")
}
```

## Async/await: sequences

SE-0298 introduces the ability to loop over asynchronous sequences of values using a new `AsyncSequence` protocol. This is helpful for places when you want to process values in a sequence as they become available rather than precomputing them all at once - perhaps because they take time to calculate, or because they aren't available yet.

Using `AsyncSequence` is almost identical to using `Sequence`, with the exception that your types should conform to `AsyncSequence` and `AsyncInterator`, and your `next()` should be marked `async`. When it comes time for your sequence to end, make sure you send back `nil` from `next()`, just as with `Sequence`.

For example, we could make a `DoubleGenerator` sequence that starts from 1 and doubles its number every time it's called:

```
import Foundation

struct DoubleGenerator: AsyncSequence {
    typealias Element = Int

    struct AsyncIterator: AsyncIteratorProtocol {
        var current = 1

        mutating func next() async -> Int? {
            defer { current &*= 2 }

            if current < 0 {
                return nil
            } else {
                return current
            }
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator()
    }
}
```

Once you have your asynchronous sequence, you can loop over its values by using `for await` in an async context, like this:

```
func printAllDoubles() async {
    for await number in DoubleGenerator() {
        print(number)
    }
}
```

The `AsyncSequence` protocol also provides default implementations of a variety of common methods, such as `map()`, `compactMap()`, `allSatisfy()`, and more. For example, we could check whether our generator outputs a specific number like this:

```
func containsExactNumber() async {
    let doubles = DoubleGenerator()
    let match = await doubles.contains(16_777_216)
    print(match)
}
```

## Effectful read-only properties

SE-0310 upgrades Swift's read-only properties to support the `async` and `throws` keywords, either individually or together, making them significantly more flexible.

To demonstrate this, we could create a `BundleFile` struct that attempts to load the contents of a file in our app's resource bundle. Because the file might not be there, might be there but can't be read for some reason, or might be readable but so big it take time to read, we could mark the `contents` property as `async throws` like this:

```
enum FileError: Error {
    case missing, unreadable
}

struct BundleFile {
    let filename: String

    var contents: String {
        get async throws {
            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
                throw FileError.missing
            }

            do {
                return try String(contentsOf: url)
            } catch {
                throw FileError.unreadable
            }
        }
    }
}
```

Because `contents` is both async and throwing, we must use `try await` when trying to read it:

```
func printHighScores() async throws {
    let file = BundleFile(filename: "highscores")
    try await print(file.contents)
}
```

## Structured concurrency

SE-0304 introduces a whole range of approaches to execute, cancel, and monitor operations in Swift, and builds upon the work introduced by async/await and async sequences.

For easier demonstration purposes, here are a couple of example functions we can work with - an async function to simulate fetching a certain number of weather readings for a particular location, and a synchronous function to calculate which number lies at a particular position in the Fibonacci sequence:

```
enum LocationError: Error {
    case unknown
}

func getWeatherReadings(for location: String) async throws -> [Double] {
    switch location {
    case "London":
        return (1...100).map { _ in Double.random(in: 6...26) }
    case "Rome":
        return (1...100).map { _ in Double.random(in: 10...32) }
    case "San Francisco":
        return (1...100).map { _ in Double.random(in: 12...20) }
    default:
        throw LocationError.unknown
    }
}

func fibonacci(of number: Int) -> Int {
    var first = 0
    var second = 1

    for _ in 0..<number {
        let previous = first
        first = second
        second = previous + first
    }

    return first
}
```

The simplest async approach introduced by structured concurrency is the ability to use the `@main` attribute to go immediately into an async context, which is done simply by making the `main()` method with `async`, like this:

```
@main
struct Main {
    static func main() async throws {
        let readings = try await getWeatherReadings(for: "London")
        print("Readings are: \(readings)")
    }
}
```

The main changes introduced by structured concurrency are backed by two new types, `Task` and `TaskGroup`, which allow us to run concurrent operations either individually or in a coordinated way.

In its simplest form, you can start concurrent work by creating a new `Task` object and passing it the operation you want to run. This will start running on a background thread immediately, and you can use `await` to wait for its finished value to come back.

So, we might call `fibonaci(of:)` many times on a background thread, in order to calculate the first 50 numbers in the sequence.

```
func printFibonacciSequence() async {
    let task1 = Task { () -> [Int] in
        var numbers = [Int]()

        for i in 0..<50 {
            let result = fibonacci(of: i)
            numbers.append(result)
        }

        return numbers
    }

    let result1 = await task1.value
    print("The first 50 numbers in the Fibonacci sequence are: \(result1)")
}

Task {
    await printFibonacciSequence()
}
```

Again, the task starts running as soon as it's created, and the `printFibonacciSequence()` function will continue running on whichever thread it was while the Fibonacci number are being calculated.

**Tip**: Our task's operation is a non-escaping closure because the task immediately runs it rather than storing it for later, which means if you use `Task` inside a class or a struct you don't need to use `self` to acces properties or methods.

When it comes to reading the finished numbers, `await task1.value` will make sure execution of `printFibonaccieSequence()` pauses until the task's output is ready, at which point it will be returned. If you don't actually care what the task returns - if you just want the code to start running and finish whenever - you don't need to store the task anywhere.

For task operations that throw uncaught errors, reading your task's `value` property will automatically also throw errors. So, we could write a function that performs two pieces of work at the same time then waits for them both to complete:

```
func runMultipleCalculations() async throws {
    let task1 = Task {
        (0..<50).map(fibonacci)
    }

    let task2 = Task {
        try await getWeatherReadings(for: "Rome")
    }

    let result1 = await task1.value
    let result2 = try await task2.value

    print("The first 50 numbers in the Fibonacci sequence are: \(result1)")
    print("Rome weather readings are: \(result2)")
}
```

Swift provides us with the built-in task priorities of `high`, `medium` (`default` is deprecated), `low`, `utility`, `userInitiated`, and `background`. The code above doesn't specificially set on so it will get `medium`, but we could have said something like `Task(priority: .high)` to customize that. If you're writing just for Apple's platforms, you can also use the more familiar priorites of `userInitiated` in place of `high`, and `utility` in place of `low`, but you can't acess `userInteractive` because that is reversed for the main thread.

As well as just running operations, `Task` also provides us with a handlful of static methods to control the way our code runs:

- Calling `Task.sleep()` will cause the current task to sleep for a specific number of nanoseconds. Until something better comes along, this means writing 1_000_000_000 to mean 1 second.
- Calling `Task.checkCancellation()` will check whether someone has asked for this task to be cancelled by calling its `cancel()` method, and if so throw a `CancellationError`.
- Calling `Task.yeidl()` will suspend the current task for a few moments in order to give some time to any tasks that might be waiting, which is particularly import if you're doing intensive work in a loop.

You can see both sleeping and cancellation in the following code example, which puts a task to sleep for one second then cancels it before it completes:

```
func cancelSleepingTask() async {
    let task = Task { () -> String in
        print("Starting")
        try await Task.sleep(nanoseconds: 1_000_000_000)
        try Task.checkCancellation()
        return "Done"
    }

    // The task has started, but we'll cancel it while it sleeps
    task.cancel()

    do {
        let result = try await task.value
        print("Result: \(result)")
    } catch {
        print("Task was cancelled.")
    }
}
```

The above code prints:

```
Task was cancelled.
```

In the code, `Task.checkCancellation()` will realize the task has been cancelled and immediately throw `CancellationError`, but that won't reach us until we attemp to read `task.value`.

**Tip**: Use `task.result` to get a `Result` value containing the task's success and failure values. For example, in the code above we'd get back a `Result<String, Error>`. This does _not_ a `try` call because you still need to handle the success or failure case.

For more complex work, you should create _task_ groups instead - collections of tasks that work together to produce a finished value.

To minimize the risk of programmers using task groups in dangerous ways, they don't have a simple public initializer. Instead, task groups are created using functions such as `withTaskGroup()`: call this with the body of work you want done, and you'll be passed in the task group instance to work with. Once inside the group you can add work using the `addTask()` method, and it will start executing immediately.

**Important**: You should not attempt to copy that task group outside the body of `withTaskGroup()` - the compiler can't stop you, but you're just going to make problems for youself.

```
func printMessage() async {
    let string = await withTaskGroup(of: String.self) { group -> String in
        group.addTask { "Hello" }
        group.addTask { "From" }
        group.addTask { "A" }
        group.addTask { "Task" }
        group.addTask { "Group" }

        var collected = [String]()

        for await value in group {
            collected.append(value)
        }

        return collected.joined(separator: " ")
    }

    print(string)
}
```

That creates a task group desined to produce one finished string, then queues up several closures using the addTask() function of the task group. Each of those closures returns a single string, which then gets collected into an array of strings, before being joined into one single and returned for printing.

**Tip**: All tasks in a task group must return the same type of data.

Each call to `addTask()` can be any kind of function you like, as long as it returns in a string, however, although task groups automatically wait for all the child tasks to complete before returning, when that code rusn it's a bit of a toss up what it will print because the chid tasks can complete in any order.

Use `withThrowingTaskGroup()` if your code throws an error. `try` is a must.

```
func printAllWeatherReadings() async {
    do {
        print("Calculating average weather...")

        let result = try await withThrowingTaskGroup(of: [Double].self) { group -> String in
            group.addTask {
                try await getWeatherReadings(for: "London")
            }

            group.addTask {
                try await getWeatherReadings(for: "Rome")
            }

            group.addTask {
                try await getWeatherReadings(for: "San Francisco")
            }

            // Convert our array of arrays into a single array of doubles
            let allValues = try await group.reduce([], +)

            // Calculate the mean average of all our doubles
            let average = allValues.reduce(0, +) / Double(allValues.count)
            return "Overall average temperature is \(average)"
        }

        print("Done! \(result)")
    } catch {
        print("Error calculating data.")
    }
}

Task { await printAllWeatherReadings() }
```

Task groups have a `cancelAll()` method that cancels any tasks inside the group, but using `addTask()` afterwards will continue to add work of the group. As an alternative, you can use `addTaskUnlessCancelled()` to skip adding work if the group has been cancelled - check its returned Boolean to see whether the work has addded sucessfully or not.

## `async let` bindings

SE-0317 introduced the ability to create and await child tasks using the simple syntax `async let`. This is particularly useful as an alternative to task groups where you're dealing with heterogeneous result types i.e. if you want tasks in a group to return different kinds of data.

To demonstrate this, we could create a struct that has three different types of properties that will come from three different async functions:

```
struct UserData {
    let name: String
    let friends: [String]
    let highScores: [Int]
}

func getUser() async -> String {
    "Taylor Swift"
}

func getHighScores() async -> [Int] {
    [42, 23, 16, 15, 8, 4]
}

func getFriends() async -> [String] {
    ["Eric", "Maeve", "Otis"]
}

func printUserDetails() async {
    async let username = getUser()
    async let scores = getHighScores()
    async let friends = getFriends()

    let user = await UserData(name: username, friends: friends, highScores: scores)
    print("Hello, my name is \(user.name), and I have \(user.friends.count)")
}
```

**Import** `async let` can be used inside `async` context.

When working with throwing functions, you _don't_ need to use `try` with `async let` - that can automatically be pushed back to where you await the result. Similarly, the `await` keyword is also implied, so rather than typing `try await someFunction()` with an `async let` you can just write `someFunction()`.

```
enum NumberError: Error {
    case outOfRange
}

func fibonaci(of number: Int) async throws -> Int {
    if number < 0 || number > 22 {
        throw NumberError.outOfRange
    }

    if number < 2 { return number }
    async let first = fibonaci(of: number - 2)
    async let second = fibonacci(of: number - 1)
    return try await first + second
}
```

## Continuations for interfacing async tasks with asynchronous code

SE-0300 introduces new functions to help us adapt older, completion handler-style APIs to modern async code.

A regular function with a completion handler:

```
func fetchLatestNews(completion: @escaping ([String]) -> Void) {
    DispatchQueue.main.async {
        completion(["Swift 5.5 release", "Apple acquires Apollo"])
    }
}
```

Continuations allows to create a shim between the completion handler and async functions so that we wrap up the older code in a more modern API. For example, the `withCheckedContinuation()` function creates a new continuation that can run whatever code you want, the call `resume(returning:)` to send a value back whenever you're ready - even if that's part of a completion handlder closure.

```
func fetchLatestNews() async -> [String] {
    await withCheckedContinuation { continuation in
        fetchLatestNews { items in
            continuation.resume(returning: items)
        }
    }
}

func printNews() async {
    let items = await fetchLatestNews()

    for item in items {
        print(item)
    }
}

Task {
    await printNews()
}
```

`withUnsafeContinuation()` works example the same way except does _not_ perform runtime checks on your behalf. This means Swift won't warn you if you forget to resume the continuation, and if you call it twice then the behavior is undefined.

## Actors

SE-0306 introduces actors, which are conceptually similar to classes that are safe to use in concurrent environment. This is possible because Swift ensures that mutable state inside your actor is only ever accessed by a single thread at any given time, which helsp eliminate a variety of serious bugs right at the compiler level.

Regular class:

```
class RiskyCollector {
    var deck: Set<String>

    init(deck: Set<String>) {
        self.deck = deck
    }

    func send(card selected: String, to person: RiskyCollector) -> Bool {
        guard deck.contains(selected) else { return false }

        deck.remove(selected)
        person.transfer(card: selected)
        return true
    }

    func transfer(card: String) {
        deck.insert(card)
    }
}
```

```
actor SafeCollector {
    var deck: Set<String>

    init(deck: Set<String>) {
        self.deck = deck
    }

    func send(card selected: String, to person: SafeCollector) async -> Bool {
        guard deck.contains(selected) else { return false }

        deck.remove(selected)
        await person.transfer(card: selected)
        return true
    }

    func transfer(card: String) {
        deck.insert(card)
    }
}
```

1. Actors are created by new `actor` keyword. This is a new concerete nominal type in Swift, joining structs, classes, and enums.
2. The `send()` function is marked with `async`, because it will need to suspend its work while waiting for the transfer to complete.
3. Althrough the `transfer(card:)` function is _not_ marked with `async`, we still need to call it with `await` because it will wait until the other `SafeController` actor is able to handle the request.

Similarites between actors Actors and Classes:

- Both are reference type, so they can be used for shared state.
- They can have functions, properties, initializers, and subscirpts.
- They can conform to protocols and be generic.
- Any properties and methods that are static behave the same in both types, because they have no concept of `self` and therefore don't get isolated.

Beyound actor isolation, there are two other import differences between them:

- Actors do not currently support inheritance, which makes their initializers much simpler - there is no need for convenience initializers, overriding, the `final` keyword, and more. This might change in the future.
- All actors implicitly conform to a new `Actor` protocol; no other concrete type can use this. This allows your to restrict other parts of your code so it can work only with actors.

## Global Actors

SE-0316 allows global state to be isolated from data races by using actors.

Although in theory this could result in many global actors, the main benefit at least right now is the introduction of an `@MainActor` global actor you can use to mark properties and methods that should be access only on the main thread.

```
class OldDataController {
    func save() -> Bool {
        guard Thread.isMainThread else {
            return false
        }

        print("Saving data…")
        return true
    }
}
```

`@MainActor` can guanratee that `save()` is always called on the main thread as if we specifially ran it using `DispatchQueue.main`

```
class NewDataController {
    @MainActor func save() {
        print("Saving data…")
    }
}
```

## Sendable and `@Sendable` closure

SE-0302 adds support for "sendable" data, which is data that can safely be transfered to another thread. This is accomplished through a new `Sendable` protocol, and an `@Sendable` attribute for functions.

Many things are inherently safe to send across threads:

- All Swift's code value types, including Bool, Int, String, and similar.
- Optionals, where the wrapped data is value type.
- Standard library collections that contain value types, such as `Array<String>` or `Dictionary<Int, String>`
- Tuples where the elements are all value types.
- Matatypes, such as String.self.

These have been updated to conform to the `Sendable` protocl.

As for custom types, it depends what you're making:

- Actors automatically conform to `Sendable` because they handle their synchronization internally.
- Custom structs and enums you define will also automatically conform to `Sendable` if they contain only values that also conform to `Sendable`, similar to how `Codable` works.
- Custom classes can conform to `Sendable` as long as they either inherits from `NSObject` or from nothing at all, all properties are constant and themselves comform to `Sendable`, and they are marked as `final` to stop further inheritance.

Swift lets us usethe `@Sendable` attribute on functions or clolsure to mark them as working concurrently, and will enforce various rules to stop us shooting ourself in the foot. For example, the operation we pass into the `Task` initializer is marked `@Sendable`, which means this kind of code is allowed because the value captured by `Task` is constant:

```
func printScore() async {
    let score = 1
    Task { print(score) }
    Task { print(score) }
}
```

However, that code would _not_ be allowed if `score` were a variable, becuase it could be accessed by one of the tasks while the other was changing its value.

You can mark your own functions and closure using `@Sendable`, which will enforce similar rules around captured values:

```
func runLater(_ function: @escaping @Sendable () -> Void) -> Void {
    DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: function)
}
```

## #if for postfix member expressions

SE-0308 allows Swift to use #if conditions with postfix member expressions. This sounds a bit obscure, but it solves a problem commonly seen with SwiftUI: you can now optionally add modifiers to a view.

For example, this change allows us to create a text view with two different font sizes depending on whether we're using iOS or another platform:

```
Text("Welcome")
#if os(iOS)
    .font(.largeTitle)
#else
    .font(.headline)
#endif
```

You can nest these if you want, although it's a bit hard on your eyes:

```
Text("Welcome")
#if os(iOS)
    .font(.largeTitle)
    #if DEBUG
        .foregroundStyle(.red)
    #endif
#else
        .font(.headline)
#endif
```

You could use wildly different postfix expressions if you wanted:

```
let result = [1, 2, 3]
#if os(iOS)
    .count
#else
    .reduce(0, +)
#endif

print(result)
```

Technically you could make `result` end up as two completely different types if you wanted, but that seems a bad idea. What you _definitely_ can't do is use other kinds of expressions such as using `+ [4]` instead of `.count` - if it doesn't start with `.` with it's not a postfix member expression.

## Allow interchangeable use of `CGFloat` and `Double` types

SE-0307 introduces a small but important quality of life improvement: Swift is able to implicityly convert between `CGFloat` and `Duble` together to produce a new `Double`, like this:

```
let first: CGFloat = 42
let second: Double = 19
let firstPlusSecond = first + second
print(firstPlusSecond) // "61.0\n"
print(type(of: firstPlusSecond)) // "Double\n"
```

## Codable synthesis for enums with associated values

SE-0295 upgrades Swift's `Codable` system to support writing enums with associated values. Previously enums were only supported if they conformed to `RawRepresentable`, but this extends support to general enums as well as enum cases with any number of `Codable` associated values.

```
enum Weather: Codable {
    case sun
    case Wind(speed: Int)
    case rain(amount: Int, cache: Int)
}
```

That has one simple case, one case with a single associated values, and a third case with two associated values - all are integers, but you could use strings or other `Codable` types.

With that enum defined, we can create an array of weather to make a forecast, then use `JSONEncoder` or similar and convert the result to a printable string:

```
enum Weather: Codable {
    case sun
    case wind(speed: Int)
    case rain(amount: Int, chance: Int)
}

let forecast: [Weather] = [
    .sun,
    .wind(speed: 10),
    .sun,
    .rain(amount: 5, chance: 50)
]

do {
    let result = try JSONEncoder().encode(forecast)
    let jsonString = String(decoding: result, as: UTF8.self)
    print(jsonString)
} catch {
    print("Encoding error: \(error.localizedDescription)")
}
```

print out:

```
[{"sun":{}},{"wind":{"speed":10}},{"sun":{}},{"rain":{"chance":50,"amount":5}}]
```

Behind the scene, this is implemented using multiple `CodingKey` enums capable of handling the nested structure that results from having values attached to enum cases, which means writing your own custom coding functions to do the same is a little more work.

## `lazy` now works in local contexts

The `lazy` keyword has always allowed us to write stored properties that are only calculated when first used, but from Swift 5.5 onwards we can use `lazy` locally inside a function to create values that work similarly.

This code demonstrates local `lazy` in action:

```
func printGreeting(to: String) -> String {
    print("In printGreeting()")
    return "Hello, \(to)"
}


func lazyTest() {
    print("Before lazy")
    lazy var greeting = printGreeting(to: "Suguru")
    print("After lazy")
    print(greeting)
}

lazyTest()
```

Swift only runs the `printGreeting(to:)` code when its result is accessed on the `print(greeting)` line.

## Extend property wrappers to function and closure parameters

SE-0293 extends property wrappers so they can be applied to parameters for functions and closures. Parameters passed this way are still immutable unless you take a copy of them, and you are still able to access the underlying property wrapper type using a leading underscore if you want.

If we wanted our scores to lie only within the range 0...100 we could write a simple property wrapper that champs numbers as they are created:

```
@propertyWrapper
struct Clamped<T: Comparable> {
    let wrappedValue: T

    init(wrappedValue: T, range: ClosedRange<T>) {
        self.wrappedValue = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
}
```

Now we can write and calla new function using that wrapper

```
func setScore2(@Clamped(range: 0...100) to score: Int) {
    print("Setting score to \(score)")
}

setScore2(to: 50)
setScore2(to: -50) // will be converted to 0
setScore2(to: 500) // will be converted to 100
```

## Extending static member lookup in generic contexts

SE-0299 allows Swift to perform static member lookup for members of protocols in generic functions, which sounds obscure but actually fixes a small but important ledibility problem that hit SwiftUI particularly hard.

At this time SwiftUI hasn't been updated to support this change, but everything goes to plan we can stop writing this:

```
Toggle("Example", isOn: .constant(true))
    .toggleStyle(SwitchToggleStyle())

```

And instead write something like this:

```
Toggle("Example", isOn: .constant(true))
    .toggleStyle(.switch)
```

```
protocol Theme {}
struct LightTheme: Theme {}
struct DarkTheme: Theme {}
struct RainbowTheme: Theme {}

protocol Screen {}

extension Screen {
    func theme<T: Theme>(_ style: T) -> Screen {
        print("Activating new theme!")
        return self
    }
}
```

And now we could create a instance of a screen:

```
struct HomeScreen: Screen {}
```

Following older SwiftUI code, we could enable a light theme on that screen by specifying `LightTheme()`

```
let lightScreen = HomeScreen().theme(LightTheme())
```

If we wanted to make that eaiser to access, we could try adding a static `light` property to our `Theme` protocol like this:

```
extension Theme where Self == LightTheme {
    static var light: LightTheme { .init() }
}
```

However, _using_ that with the `theme()` function of our generic protocol was what caused the problem: before Swift 5.5 it was not possible and you had to use `LightTheme()` every time. However, in Swift 5.5 or later this is now possible:

```
let lightTheme = HomeScreen().theme(.light)
```
