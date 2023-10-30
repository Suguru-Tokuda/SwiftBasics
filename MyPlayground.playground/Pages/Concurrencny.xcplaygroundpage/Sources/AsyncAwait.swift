import Foundation

/*
 Await Async - iOS 13, 2019
 */

func asyncAwait() {
    Task {
        let output = await task1()
        // task 2 will start only after task1 finishes
        await task2(num: output)
        print("task2 finished")
    }
}

func task1() async -> Int {
    print("Task 1")
    var res = 0
    for _ in 0...(Int8.max / 4) { res += 1}
    return res
}

func task2(num: Int) async {
    print("Task 2")
    for _ in 0...num {}
}
