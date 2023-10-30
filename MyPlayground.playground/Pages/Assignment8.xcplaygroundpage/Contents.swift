import Foundation

/*
 MARK: GCD - Grand Central Dispatch
 
 Global Queues
 1. User Interactive
 2. User Initiated
 3. Utility
 4. Background
 5. Default
 6. Unspecified
 */

/* 
    MARK: 1. User Interactive
    Animations, event handling, updating the app should be done in .userInteractive thread.
*/
DispatchQueue.global(qos: .userInteractive).async {}

/*
    MARK: 2. User Initiated
    Any work that user initialited should be done in the userInitiated threads.
*/
DispatchQueue.global(qos: .userInitiated).async {}

/*
    MARK: 3. Utility
    Any long running tasks such as downloading songs, statements, movies, and api calls should be done in the utility thread. The user is aware and those tasks are not of that much priority.
*/
DispatchQueue.global(qos: .utility).async {}

/*
    MARK: 4. Background
    Should have tasks that a user is not even aware of during the code execusions.
 */
DispatchQueue.global(qos: .background).async {}

/* 
    MARK: 5. Default
    This thread is treated between userInitiated and utility threads.
 */
DispatchQueue.global(qos: .default).async {}

/* 
    MARK: 6. Unspecified
    Thread that has the least priority.
 */
DispatchQueue.global(qos: .unspecified).async {}

/*
    MARK: OperationQueues
    OperationQueue lets a developer have better controls of tasks. Each task is defined with BlockOperation {}. You can add dependencies, pause, resume and start tasks. It is a good choice for the situation when the task needs to pause during the execusion due to network connectivity issues and needs to resume when the network is available.
 */

let downloadSong = BlockOperation {
    print("Downloading a song...")
    
    for _ in 0...500 { }
}

let playSong = BlockOperation {
    print("Playing a song")
}

let downloadSong2 = BlockOperation {
    print("Download song 2")
}

let operationQueue = OperationQueue()
operationQueue.addOperations([downloadSong, playSong], waitUntilFinished: false)

let operationQueue2 = OperationQueue()
operationQueue2.addOperations([downloadSong2], waitUntilFinished: true)

/*
    MARK: Async Await
    Available from iOS 13. The calling function needs to have async keyword. To call async functions, the function call needs to be inside Task {} and await keyword is required.
 */

// mocking an api call with a closure
func fakeApiCall(_ completion: @escaping ([String]) -> Void) {
    let retVal: [String] = ["Michelle", "Doug", "Chris"]
    
    DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 1) {
        completion(retVal)
    }
}

// Creating a async function.
// Inside the function, call withCheckedContinuation.
func fetchAccountData() async -> [String] {
    return await withCheckedContinuation { continuation  in
        fakeApiCall { val in
            continuation.resume(returning: val)
        }
    }
}

// Demo for async await
Task {
    let accounts = await fetchAccountData()
    print(accounts)
}

/*
    MARK: Actors
    Actor is similar to class; reference type, can have properties and functions, however, actors do not support inheritance. The biggest difference between classes and actors are that properties in an actor is thread safe. Only one thread can access/modify the property at the same time. This helps to implement thread safe application. If you want to do the same thing with class, you need to use serial queue so that the property is thread safe.
 */

actor AccountInfo {
    private var isLoggedIn: Bool = false
    
    init() {}
    
    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
    
    func getLogInStatus() -> Bool {
        return isLoggedIn
    }
    
    func logIn(email: String, password: String) -> Bool {
        if email.lowercased() == "email" && password == "password" {
            isLoggedIn = true
        } else{
            isLoggedIn = false
        }
        
        return isLoggedIn
    }
    
    func logout() -> Bool {
        if isLoggedIn == true {
            isLoggedIn = false
            
            return true
        } else {
            return false
        }
    }
}

let myAccountInfo = AccountInfo()

// Test actor functions.
Task {
    let wasAbleToLogin = await myAccountInfo.logIn(email: "email", password: "password")
    print("Was able to login: \(wasAbleToLogin)")
    let logInStatus = await myAccountInfo.getLogInStatus()
    print("Log in status: \(logInStatus)")
    let logOutStatus = await myAccountInfo.logout()
    print("Logged out: \(logOutStatus)")
}
