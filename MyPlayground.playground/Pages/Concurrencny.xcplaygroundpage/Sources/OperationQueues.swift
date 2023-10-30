import Foundation

/*
    Operation Queues - were built on top of GCD
    it gives more control to user.
    pause, resume, stop, start task
    add or define dependencies within your task
 */

func operationQueues() {
    let taskLettuce = BlockOperation {
        print("Adding Lettuce to Salad")
    }
    
    let taskTomato = BlockOperation {
        print("Adding Tomato to Salad")
    }
    
    let taskOnion = BlockOperation {
        print("Adding Onion to Salad")
    }
    
    let operationQueue = OperationQueue()
    
    taskTomato.addDependency(taskOnion)
    taskLettuce.addDependency(taskTomato)
    
    operationQueue.addOperations([taskLettuce, taskTomato, taskOnion], waitUntilFinished: false)
    operationQueue.maxConcurrentOperationCount = 1
    
    operationQueue.cancelAllOperations()
    _ = operationQueue.isSuspended
    operationQueue.name = "My Operation Queue 1"
    
    let operationQueue2 = OperationQueue()
    operationQueue.name = "My Operation Queue 2"
}

