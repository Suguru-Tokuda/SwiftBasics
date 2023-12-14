import Foundation

func mainQueues() {
    // Main Queue - Main Thread
    //let isMainThread = true

    DispatchQueue.main.async {
        print("Main thread a")
    }

    DispatchQueue.main.async {
        print("Main thread b")
    }

}
