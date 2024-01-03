# Swift 5.7

## `if let` shorthanded for unwrapping optionals

SE-0345 introduces new shorthanded syntax for unwrapping optionals into shadowed variables of the same name using `if let` and `guard let`.

```
var name: String? = "Linda"

if let name {
    print("Hello, \(name)!)
}
```

Previoius code:

```
if let name = name {
    print("Hello, \(name)!")
}

if let unwrappedName = name {
    print("Hello, \(unwrappedName)!")
}
```

The change _doesn't_ extend to properties inside objects, which means the following code does _not_ work:

```
struct User {
    var name: String
}

let user: User? = User(name: "Linda")

if let user.name {
    print("Welcome, \(user.name)!")
}
```

## Multi-statement closure type inference

SE-0326 dramatically improves Swift's ability to use parameter and type inference for closures, meaning that many places where we had to specify explicit input and output types can now be removed.

```
let scores = [100, 80, 85]

let results = scores.map { score in
    if score >= 85 {
        return "\(score)%: Pass"
    } else {
        return "\(score)%: Fail
    }
}
```

Prior to Swift 5.7, explicit return type inside a closure was required:

```
let oldResults = scores.map { score -> String in
    if score >= 85 {
        return "\(score)%: Pass"
    } else {
        return "\(score)%: Fail"
    }
}
```

## Clock, Instant, and Duration

SE-0329 introduces a new, standarized way of referring to times and durations in Swift. As the name suggests, it's broken down into three main components:

- Clocks represent a way of measuring time passing. There are two built in: continuous clock keeps incrementing time even when the system is asleep, and the suspending clock does not.
- Instants represent an exact moment in time.
- Durations represent how much time elapased between two instants.

`Task` API is the newly upgraded and can affect many developers

```
try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
```

`tolerance` option lets the app to sleep extra time. The following code potentially puts the app sleep.

```
try await Task.sleep(unitl: .now + .seconds(1), tolerance: .seconds(0.5), clock: .continuous)
```

Clocks are also useful for measuring some specific work, which is helpful if you want to show your users something like how long a file export look like:

```
let clock = ContinuousCoock()

let time = clock.measure {
    // complex work here
}

print("Took \(time.components.seconds) seconds")
```

## Regular expressions

- SE-0350 introduces a new Regex type
- SE-0351 introduces a result builder-powered DSL for creating regular expressions.
- SE-0354 adds the ability to create a regular expression using `/.../` rather than going through `Regex` and a string.
- SE-0357 adds many new string processing algorithms based on regular expressions.

The following code is valid:

```
let message = "the cat sat on the mat"
print(message.ranges(of: "at"))
print(message.replacing("cat", with: "dog"))
print(message.trimmingPrefix("the "))
```

The following code is also supported:

```
print(message.ranges(of: /[a-z]at/))
print(message.replacing(/[a-m]at/, with: "dog"))
print(message.trimmingPrefix(/The/.ignoresCase()))
```

Along with regex literals, Swift provides a dedicated `Regex` type that works similarly:

```
do {
    let atSearch = try Regex["[a-z]at"]
    print(message.ranges(of: atSearch))
} catch {
    print("Failed to create regex" )
}
```

_Difference between regex literals and Regex_: when we create a regular expression from a string using `Regex`, Swift must parse the string at runtime to figure out the actual expression it should use. In comparison, using regex literals allows Siwft to check your regex at `compile time`: it can valid the regex contains no errors, and also understand exactly what mathces it will contain.

```
let search1 = /My name is (.+?) and I'm (\d+) years old./
let greeting1 = "My name is Taylor and I'm 26 years old."

if let result = try? search1.wholeMatch(in: greeting1) {
    print("Name: \(result.1)")
    print("Age: \(result.2)")
}
```

You can assign names to the result tuple:

```
let search2 = /My name is (?<name>.+?) and I'm (?<age>\d+) years old./
let greeting2 = "My name is Taylor and I'm 26 years old."

if let result = try? search2.wholeMatch(in: greeting2) {
    print("Name: \(result.name)")
    print("Age: \(result.age)")
}
```

```
import RegexBuilder

let search3 = Regex {
    "My name is"

    Capture {
        OneOrMore(.word)
    }

    " and I'm "

    Capture {
        OneOrMore(.digit)
    }

    " years old."
}
```

`TryCapture` should be used if there is a chance that the regex might fail.

```
let search4 = Regex {
    "My name is "

    Capture {
        OneOrMore(.word)
    }

    " and I'm "

    TryCapture {
        OneOrMore(.digit)
    } transform: { match in
        Int(match)
    }

    " years old."
}
```

And you can even bring together named matches using variables with specific types like this:

```
let nameRef = Reference(Substring.self)
let ageRef = Reference(Int.self)

let search5 = Regex {
    "My name is "

    Capture(as: nameRef) {
        OneOrMore(.word)
    }

    " and I'm "

    TryCapture(as: ageRef) {
        OneOrMore(.digit)
    } transform: { match in
        Int(match)
    }

    " years old."
}

if let result = greeting1.firstMatch(of: search5) {
    print("Name: \(result[nameRef])")
    print("Age: \(result[ageRef])")
}
```

## Type inference from default expressions

SE-0347 expands Swift ability to use default values with generic parameter types. What it allows seems quite riche, but it does matter: if you have a generic type of function you can now provide a concrete type for a default expression, in places where previously Swift would have thrown up a compiler error.

As an example, we might have a function that returns `count` number of random items from any kind of sequence:

```
func drawLotto1<T: Sequence>(from options: T, count: Int = 7) -> [T.Element] {
    Array(options.shuffled().prefix(count))
}
```

That allows us to run a lottery using any kind of sequence, such as an array of names or an integer range:

```
print(drawLotto1(from: 1...49))
print(drawLotto1(from: ["Jenny", "Trixie", "Cynthia"], count: 2))
```

SE-0347 extends this to allow us to provide a concrete type as default value for the `T` parameter in our function, allowing us to keep the flexibility to use string arrays or any other kind of collection, while also defaulting to the range option that we want most of the time:

```
func drawLotto2<T: Sequence>(from options: T = 1...49, count: Int = 7) -> [T.Element] {
    Array(options.shuffled().prefix(count))
}
```

```
print(drawLotto2(from: ["Jenny", "Trixie", "Cynthia"], count: 2))
print(drawLotto2())
```

## Concurrency in top-level code

SE-0343 upgrades Swift's support for top-level code - this main.swift in a macOS Command Line Tool project - so that it supports concurrency out of the box. This is one of those changes that might seem trivial on the surface, but `took` a lot of `work` to make `happen`.

In practice, the typical code in main.swift:

```
import Foundation

let url = URL(string: "https://hws.dev/readings.json")!
let (data, _) = try await URLSession.shared.data(from: url)
let readings = try JSONDecoder().decode([Double].self, from: data)
print("Found \(readings.count) temperature readings")
```

Previously, we had to create a new `@main` struct that had an asynchronous `main()` function, so this new, simpler approach is a big improvement.

## Opaque parameter declarations

SE-0341 unlocks the ability to use `some` with parameter declarations in places where simpler generics were being used.

From Swift 5.7, the following code is valid:

```
func isSorted(array: [some Comparable]) -> Bool {
    array = array.sorted()
}
```

The `[some Comparable]` parameter type means this function works with an array counting elements of one type that conforms to the `Comparable` protocol, which is synthetic sugar for the equivalent generic code:

```
func isSortedOld<T: Comparable>(array: [T]) -> Bool {
    array = array.sorted()
}
```

Of course, we could also write the even longer constrained extension:

```
extension Array where Element: Comparable {
    func isSorted() -> Bool {
        self = self.sorted()
    }
}
```

## Structual opaque result types

SE-0328 widens the range of places that opaque result types can be used.

```
import SwiftUI

func showUserDetails() -> (some Equatable, some Equatable) {
    (Text("Username"), Text("@twostraws))
}
```

We can also return opaque type:

```
func createUser() -> [some View] {
    let usernames = ["@frankefoster", "@mikaela__caron", "@museumshuffle"]
    return usernames.map(Text.init)
}
```

Or even send back a function that itself returns an opaque type when called:

```
func createDiceRoll() -> () -> some View {
    return {
        let diceRoll = Int.random(in: 1...6)
        return Text(String(diceRoll))
    }
}
```

## Unlock existentials for all products

SE-0309 significantly loosens Swift's ban on using protocols as types when they have `Self` or associated type requirements, moving to a model where only specific properties or methods are off limits based on what they do.

In simple terms, this means the following code becomes legal:

```
let firstName: any Equatable = "Paul"
let lastName: any Equatable = "Hudson"
```

`Equatable` is a protocol with `Self` requirements, which means it provides functionality that refers to the specific type that adopts it. For example, `Int` conforms to `Equatable`, so when we say `4 == 4` we're actually running a function that accepts two integers and returns true if they match.

Swift _could_ implement this functionality using a function similar to `func ==(first: Int, second: Int) -> Bool`, but that wouldn't scale well - they would need to write doezens of such functions to handle Boolean, strings, arrays, and so on. So, instead the `Equatable` protocol has a requirement like this: `func ==(lhs: Self, rhs: Self) -> Bool`.

To avoid this problem and similar ones, any time `Self` appeared in a protocol before Swift 5.7 the compiler would simply not allow us to use it in code such as this:

```
let tvShow: [any Equatable] = ["Brookly", 99]
```

From Swift 5.7 onwards, this code _is_ allowed, and now the restrictions are pushed back to situations where you attempt to use the typein a place where Swift must actually enforce its restrictions. This means we _can't_ write `firstName == lastName` because as I said `==` must be sure it has two instances of the same type in order to work, and by using `any Equatable` we're hiding the exact types of our data.

However, what we have gained is the ability to do runtime checks on our data to identify specifically what we're working with. In the case of our mixed way, we could write this:

```
for item in tvShow {
    if let item = item as? String {
        print("Found string: \(item)")
    } else if let item = item as? Int {
        print("Found integer: \(item)")
    }
}
```

Or in the case in our two strings, we could use this:

```
if let firstName = firstName as? String,
   let lastName = lastName as? String {
    print(firstName == lastName)
}
```

We can write code to check whether all items in any sequence conform to the `Identifiable` protocol:

```
func canBeIdentified(_ input: any Sequence) -> Bool {
    input.allSatisfy { $0 is any Identifiable }
}
```

## Lightweight same-type requirements for primary associated types

SE-0346 adds newer, simpler syntax for referring to protocols that have specific associated types.

```
protocol Cache<Content> {
    associatedtype Content

    var items: [Content] { get set }

    init(items: [Content])
    mutating func add(item: Content)
}
```

Notice that the protocol now looks like both a protocol and a generic type - it has an associated type declaring some kind of hole that conforming types must fill, but also lists that type in angle brackets: `Cache<Content>`.

The part in angle brackets is what Swift calls its _primary associated type_, and it's important to understand that not all associated types should be declared up there. Instead, you should list only the ones that calling cod normally cares about specifically, e.g. the types of dictionary keys have values or the identifier type in the `Identifiable` protocol. In our case we've said that our cache's content - strings, images, users, etc - is its primary associated type.

At this point, we can go ahead and use our protocol as before - we might create some kind of data we want to cache, and then create a concrete cache type conforming to the protocol, like this:

```
struct File {
    let name: String
}

struct LocalFileCache: Cache {
    var items = [File]()

    mutating func add(item: File) {
        items.append(item)
    }
}
```

Now the clever part: when it comes to creating a cache, we can obviously create a specific one directly, like this:

```
func loadDefaultCache() -> LocalFileCache {
    LocalFileCache(items: [])
}
```

But very often we want to hide the specifics of what we're doing, like this:

```
func loadDefaultCacheOld() -> some Cache {
    LocalFileCache(items: [])
}
```

Using `some Cache` gives us the flexibility of changing our mind about what specific cache is sent back, but what SE-0346 lets us do is provide a middle gorund between being absolutely specific with a concrete type, and being rather vague with an opaque return type. So, we can specialize the protocol, like this:

```
func loadDefaultCacheNew() -> some Cache<File> {
    LocalFileCache(items: [])
}
```

So we're still retaining the ability to move to a different `Cache`-conforming type in the future, but we've made it clear that whatever is chosen here will store files internally.

This smarter syntax extends to other places too, including things like extensions:

```
extension Cache<File> {
    func clean() {
        print("Deleting all cached files...")
    }
}
```

And generic constraints:

```
func merge<C: Cache<File>>(_ lhs: C, _ rhs: C) -> C {
    print("Copying all files into a new location...")
    // now send back a new cache with items from both other caches
    return C(items: lhs.items + rhs.items)
}
```

But what will prove most helpful of all is that SE-0358 brings these primary associated types of Swift's standard library too, so `Sequence`, `Collection`, and more with benefit - we can write `Sequence<String>` to write code thatis agnostic of whatever exact sequence type is being used.

## Constrained existential types

SE-0353 provides the ability to compose SE-0309 ("Unlock existentials for all protocols") and SE-0346 ("Lightweight same-type requirements for primary associated types") to write code such as `any Sequence<String>`.

## Distributed actor isolation

1. Swit's approach of _location transparentcy_ effectively forces us to assume the actors are remote, and in fact provides no way of determining at compile time whether an actor is local or remote - we just use the same `await` calls we would no matter what, and if the actor happens to be local then the call is handled as a regular locdal actor function.
2. Rather than forcing us to build our own actor transport systems, Apple is providing a **ready-made implementation** for us to use. Apple has **said** they "only expect a handful of mature implementations to take the stage eventually," but helpfully all the distributded actor features in Swift are agnostic of whatever actor transport you are.
3. To move from an actor to distributed actor we mostly just need to write `distributed actor` then `distributed func` as needed.

```
import Distributed

typealias DefaultDistributedActorSystem = ClusterSystem

distributed actor CardCollector {
    var deck: Set<String>

    init(deck: Set<String>) {
        self.deck = deck
    }

    distributed func send(card selected: String, to person: CardCollector) async -> Bool {
        guard deck.contains(selected) else { return false }

        do {
            try await person.transfer(card: selected)
            deck.remove(selected)
            return true
        } catch {
            return false
        }
    }

    distributed func transfer(card: String) {
        deck.insert(card)
    }
}
```

## `buildPartialBlock` for result builders

SE-0348 dramatically simplifies the overloads required to implement complex result builders, which is part of the reason Swift's advanced regular expression support was possible. However, it also theoretically removes the 10-view limit for SwiftUI without needing to add variadic generics, so if it's adopted y the SwiftUI team it will make a lot of folks happy.

Simplied version of what SwiftUI's `ViewBuilder` looks like:

```
import SwiftUI

@resultBuilder
struct SimpleViewBuilderOld {
    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleView<(C0, C1)> where C0 : View, C1 : View {
        TupleView((c0, c1))
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView<(C0, C1, C2)> where C0: View, C1: View, C2: View {
        TupleView((c0, c1, c2))
    }
}
```

```
@SimpleViewBuilderOld func createTextOld() -> some View {
    Text("1")
    Text("2")
    Text("3")
}
```

That will accept all three `Text` views using the `buildBlock<C0, C1, C2>()` variant, and return a single `TupleView` containing them all. However, in this simplified example there's no way to add a _fourth_ `Text` view, because I didn't provide any more overloads in just the same way that SwiftUI doesn't support 11 or more.

This is where the new `buildPartialBlock()` comes in, because it works like the `reduce()` function of sequences: it has an initial value, then updates that by adding whatever it has already to whatever comes next.

So, we could create a new result builder that knows how to accept a single view, and how to combine that view with another one:

```
@resultBuilder
struct SimpleViewBuilderNew {
    static func buildPartialBlock<Content>(first content: Content) -> Content where Content: View {
        content
    }

    static func buildPartialBlock<C0, C1>(accumulated: C0, next: C1) -> TupleView<(C0, C1)> where C0: View, C1: View {
        TupleView((accumulated, next))
    }
}
```

Even though we only have variants accepting one or two views, because they _accumulate_ we can actually use as many as we want:

```
@SimpleViewBuilderNew func createTextNew() -> some View {
    Text("1")
    Text("2")
    Text("3")
}
```

## Implicitly opened existentials

SE-0352 allows Swift to call generic functions using a protocol in many situations, which removes a somewhat odd barrier that existed previoulsly.

As an example, here's a simple generic function that is able to work with any kind of `Numeric` value:

```
func double<T: Numeric>(_ number: T) -> T {
    number * 2
}
```

```
let first = 1
let second = 2.0
let third: Float = 3

let numbers: [any Numeric] = [first, second, third]

for number in numbers {
    print(double(number))
}
```

```
func areEqual<T: Numeric>(_ a: T, _ b: T) -> Bool {
    a == b
}

print(areEqual(numbers[0], numbers[1]))
```

## Unavailable from async attribute

To mark something as being unavailable in async context, use `@available` with your normal selection of platforms, then add `noasync` to the end. For example, we might have a function that works on any platform, but might cause problems when called asynchronously, so we'd mark it like this:

```
@available(*, noasync)
func doRiskyWork() {

}
```

```
func synchronousCaller() {
    doRiskyWork()
}
```

The following code shows a warning:
Global function 'doRiskyWork' is unavailable from asynchronous contexts; this is an error in Swift 6

```
func asynchronousCaller() async {
    doRiskyWork()
}
```

```
func sneakyCaller() async {
    synchronousCaller()
}
```

Thatrusn in an async context, but calls a _synchronous_ function, which can in turn call the `noasync` function `doRiskeyWork()`
