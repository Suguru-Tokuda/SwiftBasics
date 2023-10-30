import Foundation

func serialConcurrentQueues() {
    let queue1 = DispatchQueue(label: "queue1")

    queue1.async {
        print(Thread.current)
        print("a Task")
    }

    // task a has to complete before b can start
    queue1.async {
        print("b Task started")
        for i in 0..<100 {
            if i % 2 == 0 {
                print(i)
            }
        }
        print("b Task ended")
    }

    queue1.async {
        print("c task")
    }

    let concurrentQueue = DispatchQueue(label: "concurrentQueue123", attributes: .concurrent)

    concurrentQueue.async {
        for i in 0...150 {
            print("a - \(i)")
        }
        
        print("a Task")
    }

    concurrentQueue.async {
        print("b Task")
    }

    concurrentQueue.async {
        for i in 0...10 {
            print("c - \(i)")
        }
        print("c Task")
    }
}
