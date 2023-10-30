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
