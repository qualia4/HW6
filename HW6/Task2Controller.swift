//
//  Task2Controller.swift
//  HW6
//
//  Created by Максим Поздняков on 12.12.2024.
//

import Cocoa

class Task2Controller: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nTask 2: Shared Resource Race")
        // Demonstrating Unsafe Bank Account Race Condition
        print("\nUnsafe Bank Account Demonstration:")
        self.demonstrateBankAccount(accountType: .unsafe) {
            // After unsafe demonstration, demonstrating thread-safe account
            print("\nThread-Safe Bank Account Demonstration:")
            self.demonstrateBankAccount(accountType: .safe) {
                print("All demonstrations complete.")
                self.transitionToTask3Controller()
            }
        }
    }

    enum AccountType {
        case unsafe
        case safe
    }

    func demonstrateBankAccount(accountType: AccountType, completion: @escaping () -> Void) {
        let account: BankAccountProtocol

        switch accountType {
        case .unsafe:
            account = UnsafeBankAccount(initialBalance: 1000.0)
        case .safe:
            account = ThreadSafeBankAccount(initialBalance: 1000.0)
        }

        let group = DispatchGroup()

        for withdrawalNumber in 1...20 {
            group.enter()
            DispatchQueue.global().async {
                let withdrawalAmount = 50.0
                let success = account.withdraw(withdrawalAmount)

                if success {
                    let message = "\(accountType == .unsafe ? "Unsafe" : "Safe") Withdrawal #\(withdrawalNumber) of $"
                    print("\(message)\(withdrawalAmount) successful")
                } else {
                    let message = "\(accountType == .unsafe ? "Unsafe" : "Safe") Withdrawal #\(withdrawalNumber) of $"
                    print("\(message)\(withdrawalAmount) failed")
                }

                group.leave()
            }
        }

        group.notify(queue: .main) {
            print("\(accountType == .unsafe ? "Unsafe" : "Safe") Account Final Balance: $\(account.getBalance())")
            completion()
        }
    }

    private func transitionToTask3Controller() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let task3Controller = storyboard.instantiateController(
            withIdentifier: "Task3Controller"
        ) as? Task3Controller else {
            print("Failed to instantiate Task3Controller")
            return
        }

        self.presentAsModalWindow(task3Controller)
    }
}
