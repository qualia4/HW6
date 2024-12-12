//
//  ViewController.swift
//  HW6
//
//  Created by Максим Поздняков on 12.12.2024.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Task 1: Prime Number Checker")

        // Task 1

        let numbers = Array(1...1000)

        let group = DispatchGroup()
        group.enter()
        findPrimes(in: numbers) { primes in
            print("Prime numbers found: \(primes)")
            print("Total prime numbers: \(primes.count)")

            group.leave()
        }

        group.notify(queue: .main) {
            self.transitionToTask2Controller()
        }
    }

    private func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        if number == 2 { return true }
        if number % 2 == 0 { return false }
        let sqrtNum = Int(Double(number).squareRoot())
        for divisor in stride(from: 3, through: sqrtNum, by: 2) where number % divisor == 0 {
            return false
        }
        return true
    }

    func findPrimes(in numbers: [Int], completion: @escaping ([Int]) -> Void) {
        let processorCount = ProcessInfo.processInfo.activeProcessorCount
        let chunkSize = max(1, numbers.count / processorCount)
        let resultQueue = DispatchQueue(label: "com.primecheck.resultqueue")
        var primes = [Int]()
        let group = DispatchGroup()
        for chunkIndex in stride(from: 0, to: numbers.count, by: chunkSize) {
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                let endIndex = min(chunkIndex + chunkSize, numbers.count)
                let chunk = Array(numbers[chunkIndex..<endIndex])
                let chunkPrimes = chunk.filter { self.isPrime($0) }
                resultQueue.async {
                    primes.append(contentsOf: chunkPrimes)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            let sortedPrimes = primes.sorted()
            completion(sortedPrimes)
        }
    }

    private func transitionToTask2Controller() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let task2Controller = storyboard.instantiateController(
            withIdentifier: "Task2Controller"
        ) as? Task2Controller else {
            print("Failed to instantiate Task2Controller")
            return
        }

        self.presentAsModalWindow(task2Controller)
    }
}
