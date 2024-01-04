# Swift 5.8

## List all liminations on variables in result builders

SE-0373 relaxes some of the restrictions on variables when used inside result builders, allowing us to write code that previously have been disallowed by the compiler.

```
struct ContentView: View {
    var body: some View {
        VStack {
            lazy var user = fetchUserName()
            Text("Hello, \(user).")
        }
        .padding()
    }

    func fetchUsername() -> String {
        "@twostraws"
    }
}
```

That shows the _concept_, but doesn't provide any benefit because the lazy variable is always used - there's no difference between using `lazy var` and `let` in that code. To see where it's actually useful takes a longer code example, like this one:

```
// The user is an active subscriber, not an active subscriber, or we don't know their status yet.
enum UserState {
    case subscriber, nonsubscriber, unknown
}

// Two small pieces of information about the user
struct User {
    var id: UUID
    var username: String
}

struct ContentView: View {
    @State private var state = UserState.unknown

    var body: some View {
        VStack {
            lazy var user = fetchUsername()

            switch state {
            case .subscriber:
                Text("Hello, \(user.username). Here's what's new for subscribers…")
            case .nonsubscriber:
                Text("Hello, \(user.username). Here's why you should subscribe…")
                Button("Subscribe now") {
                    startSubscription(for: user)
                }
            case .unknown:
                Text("Sign up today!")
            }
        }
        .padding()
    }

    // Example function that would do complex work
    func fetchUsername() -> User {
        User(id: UUID(), username: "Anonymous")
    }

    func startSubscription(for user: User) {
        print("Starting subscription…")
    }
}
```

- If we didn't use `lazy`, then `fetchUsername()` would be called in all three cases of `state`, even when it isn't used in one.
- If we removed `lazy` and placed the call to `fetchUsername()` _inside_ the two cases then we would be duplicating code - not a massive problem with a simple one liner, but you can imagine how this would cause problems in more complex code.
- If we moved `user` out to a computed property, it would be called a second time when the user clicked the "Subsribe now" button.

```
struct ContentView: View {
    var body: some View {
        @AppStorage("counter") var tapCount = 0

        Button("Count: \(tapCount)") {
            tapCount += 1
        }
    }
}
```

However, although that will cause the underlying `UserDefaults` value to change with each tap, using `@AppStorage` in this way _won't_ cause the `body` property to be reinvoked every time `tapCount` changes - our UI won't automatically be updated to refrect the change.

## Function back deployment

SE-0376 adds a new `@backDeployed` attribute that makes it possible to allow new APIs to be used on older versions of frameworks. It works by writing the code for a function into your app's binary then performing a runtime check: if your user is on suitably new version of the operating system then the system's own version of the function will be used, otherwise the version copied into your app's binary will be used instead.

`@backDeployed` applies only to functions, methods, subscripts, and computed properties, so while it might work great for smaller API changes such as the `fontDesing()` modifier introduced in iOS 16.1, it wouldn't work for any code that requires new types to be used, such as the new `scrollBounceBehavior()` modifier that relies on a new `ScrollBounceBehaviour` struct.

As an example, iOS 16.4 introduced a `monospaced(_ isActive:)` variant for `Text`. If this were using `@backDeployed`, the SwiftUI team might ensure the modifier is available to whatever earliest version of SwiftUI supports the implementation code they actually need:

```
extension Text {
    @backDeployed(before: iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4)
    @available(iOS 14.0, macOS 11, tvOS 14,0, watchOS 7.0, *)
    public func monospaced(_ isActive: Bool) -> Text {
        fatalError("Implementation here")
    }
}
```

## Allow implicit self for weak self captures, after self is unwrapped

SE-0365 takes another step towards letting us remove `self` from closures by allowing an implicit `self` in places where a `weak self` capture has been unwrapped.

```
class TimerController {
    var timer: Timer?
    var fireCount = 0

    init() {
        timer = Timer.shceduledTimer(withTimeInterval, 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            print("Timer has fired \(fireCount) times")
            fireCount += 1
        }
    }
}
```

This code would not compile before Swift 5.8, because both instances of `fireCount` in the closure would need to be written `self.fireCount`.

## Concise magic file names

SE-0274 adjusts the `#file` magic identifier to use the format Module/Filename, e.g. MyApp/ContentView.swift. Previoulsy, `#file` contained the whole path to the Swift file, e.g. `/Users/twostraws/Desktop/WhatsNewInSwift/WhatsNewInSwift/ContentView.swift`, which is unnecessarily long and also likely to contain things you'd rather not reveal.

**Important**: Right now this behavior is not enabled by default. SE-0362 adds a new `-enable-upcoming-feature` compiler flag designed to let developers opt into new features before they are fully enabled in the language, so to enable the new `#file` behavior you should add `-enable-upcoming-feature ConciseMagicFile` to Other Swift Flags in Xcode.

If you want to have the old behavior after this flag is enabled, you should use

```
// New behavior, when enabled
print(#file)

// Old behavior, when needed
print(#filePath)
```

## Opening existential arguments to optinal paramters

SE-0375 extends a Swift 5.7 feature that allowed us to call generic functions using a protocol, fixing a small but annoying inconsistency: Swift 5.7 would not allow this behavior with optionals, whereas Swift 5.8 does.

For example, this code worked great in Swift 5.7, because it uses a non-optional `T` parameter:

```
func double<T: Numeric>(_ number: T) -> T {
    number * 2
}

let first = 1
let second = 2.0
let third: Float = 3

let numbers: [any Numeric] = [first, second, third]

for number in numbers {
    print(double(number))
}
```

In Swift 5.8, that same parameter can now be optional:

```
func optionalDouble<T: Numeric>(_ number: T?) -> T {
    let numberToDouble = number ?? 0
    return  numberToDouble * 2
}

let first = 1
let second = 2.0
let third: Float = 3

let numbers: [any Numeric] = [first, second, third]

for number in numbers {
    print(optionalDouble(number))
}
```

## Collection downcasts in cast patterns are now supported

This resolves another small but potentially annoying inconsistency in Swift where downcasting a collection - e.g. casting an array of `ClassA` to an array of another type that inherits from `ClassA` - would not be alloed in some circumstances.

The following code is valid in Swift 5.8:

```
class Pet { }
class Dog: Pet {
    func bark() { print("Woof!") }
}

func bark(using pets: [Pet]) {
    switch pets {
    case let pets as [Dog]:
        for pet in pets {
            pet.bark()
        }
    default:
        print("No barking today.")
    }
}
```
