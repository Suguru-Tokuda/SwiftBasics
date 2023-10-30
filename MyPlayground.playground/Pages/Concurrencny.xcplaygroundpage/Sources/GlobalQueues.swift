import Foundation


func globalQueues() {
    // 3. Global Queue - system provided queues, and are ALWAYS concurrent
    // Priority of this queue is decided by factor called as QOS - Quality of Service
    
    /*
     QOS: priority
     1. User Interactive
     2. User Initiated
     3. Utility
     4. Background
     5. Default
     6. Unspecified
     */
    // 1. userInteractive
    DispatchQueue.global(qos: .userInteractive).async {
        print("userInteractive") // animations, event handling, or updating your app
    }
    
    // 2. userInitiated
    DispatchQueue.global(qos: .userInitiated).async {
        print("userInitiated") // any work which user has started.
        // user requires immediate results - pull to refresh
    }
    
    // 3. Utility
    DispatchQueue.global(qos: .utility).async {
        print("Utility")
        // any long running task, which user is aware and those tasks are not of that much priority
        // downloading songs, statements, movies,
        // api calls can be in the utlity thread
    }
    
    // 4. Background
    DispatchQueue.global(qos: .background).async {
        print("Background")
        // Thesse are the tasks which user is not at all aware as well. 
    }
    
    // 5. Default
    DispatchQueue.global(qos: .default).async {
        print("Default")
        // this falls in between userIntiated and utility
    }
    
    // 6. Unspecified
    DispatchQueue.global(qos: .unspecified).async {
        print("unspecified")
        // this has the least priority
    }
}
