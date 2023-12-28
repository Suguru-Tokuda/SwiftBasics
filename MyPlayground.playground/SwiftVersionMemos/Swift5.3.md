# Swift 5.3

## SE-0276 Multi-pattern catch clauses

```
import Foundation

enum TemperatureError: Error {
    case tooCold, tooHot
}

func getReactorTemperature() -> Int {
    90
}

func checkReactorOperational() throws -> String {
    let temp = getReactorTemperature()

    if temp < 10 {
        throw TemperatureError.tooCold
    } else if temp > 90 {
        throw TemperatureError.tooHot
    } else {
        return "OK"
    }
}

do {
    let result = try checkReactorOperational()
    print("Result: \(result)")
} catch TemperatureError.tooHot, TemperatureError.tooCold {
    print("Shut down the reactor!")
} catch {
    print("An unknown error occured.")
}
```

## SE-0279 Multiple trailing closures

```
import SwiftUI

struct OldContentView: View {
    @State private var showOptions = false

    var body: some View {
        Button(action: {
            self.showOptions.toggle()
        }) {
            Image(systemName: "gear")
        }
    }
}

struct NewContentView: View {
    @State private var showOptions = false

    var body: some View {
        Button {
            self.showOptions.toggle()
        } label: {
            Image(systemName: "gear")
        }
    }
}
```

## SE-0266 Synthesized Comparable conformance for enums

```
import Foundation

enum Size: Comparable {
    case small
    case medium
    case large
    case extraLarge
}

let shirtSize = Size.small
let personSize = Size.large

if shirtSize < personSize {
    print("This shirt is too small")
}

enum WorldCupResult: Comparable {
    case neverWon
    case winner(stars: Int)
}

let americanMen = WorldCupResult.neverWon
let americanWoman = WorldCupResult.winner(stars: 4)
let japaneseMen = WorldCupResult.neverWon
let japaneseWomen = WorldCupResult.winner(stars: 1)

let teams = [americanMen, americanWoman, japaneseMen, japaneseWomen]
let sortedByWins = teams.sorted()
print(sortedByWins)
```

## SE-0269 `self` is no longer required in many places

```
import SwiftUI

struct OldContentView: View {
    var body: some View {
        List(1..<5) { number in
            self.cell(for: number)
        }
    }

    func cell(for number: Int) -> some View {
        Text("Cell \(number)")
    }
}

struct NewContentView: View {
    var body: some View {
        List(1..<5) { number in
            cell(for: number)
        }
    }

    func cell(for number: Int) -> some View {
        Text("Cell \(number)")
    }
}
```

## SE-0281 Type-Based Program Entry Points

```
import SwiftUI

struct OldApp {
    func run() {
        print("Running!")
    }
}

let app = OldApp()
app.run()

@main
struct NewApp {
    static func main() {
        print("Running")
    }
}
```

## SE-0267 `where` clauses on contextually generic declarations

```
import Foundation

struct Stack<Element> {
    private var array = [Element]()

    mutating func push(_ obj: Element) {
        array.append(obj)
    }

    mutating func pop() -> Element? {
        array.popLast()
    }
}

extension Stack {
    func sorted() -> [Element] where Element: Comparable {
        array.sorted()
    }
}
```

## SE-0280 Enum cases as protocol witnesses

```
import Foundation

protocol Defaultable {
    static var defaultValue: Self { get }
}

// make integers have a default value of 0
extension Int: Defaultable {
    static var defaultValue: Int { 0 }
}

// make arrays have a default of an empty array
extension Array: Defaultable {
    static var defaultValue: Array { [] }
}

// make dictionaries have a default of an empty dictionary
extension Dictionary: Defaultable {
    static var defaultValue: Dictionary { [:] }
}
```

What SE-0280 allows us to do is exactly the same thing just for enums. For example, you want to create a `padding` enum that can take some number of pixels, some number of centimeters, or a default value decided by the system:

```
enum Padding: Defaultable {
    case pixels(Int)
    case cm(Int)
    case defaultValue
}
```

## SE-0268 Refined `didSet` Semantics

Internally, this change makes Swift not retrieve the previous value when setting a new value in any instance where you weren’t using the old value, and if you don’t reference `oldValue` and don’t have a `willSet` Swift will change your data in-place.

```
didSet {
    _ = oldValue
}
```

## SE-0277 A new Float 16 type

```
let first: Float16 = 5
let second: Float32 = 11
let third: Float64 = 7
let fourth: Float80 = 13
```

## Swift Package Manager gains binary dependencies, resources, and more

Swift 5.3 introduced many improvements for Swift Package Manager (SPM). Although it’s not possible to give hands-on examples of these here, we can at least discuss what has changed and why.

First, SE-0271 (Package Manager Resources) allows SPM to contain resources such as images, audio, JSON, and more. This is more than just copying files into a finished app bundle – for example, we can apply a custom processing step to our assets, such as optimizing images for iOS. This also adds a new `Bundle.module` property for accessing these assets at runtime. SE-0278 (Package Manager Localized Resources) builds on this to allow for localized versions of resources, for example images that are in French.

Second, SE-0272 (Package Manager Binary Dependencies) allows SPM to use binary packages alongside its existing support for source packages. This means common closed-source SDKs such as Firebase can now be integrated using SPM.

Third, SE-0273 (Package Manager Conditional Target Dependencies) allows us to configure targets to have dependencies only for specific platforms and configurations. For example, we might say that we need some specific extra frameworks when compiling for Linux, or that we should build in some debug code when compiling for local testing.

It’s worth adding that the “Future Directions” section of SE-0271 mentions the possibility of type-safe access to individual resource files – the ability for SPM to generate specific declarations for our resource files as Swift code, meaning that things like `Image("avatar") `become something like `Image(module.avatar)`.
