//
//  BankAccount.swift
//  HW6
//
//  Created by Максим Поздняков on 12.12.2024.
//

import Foundation

protocol BankAccountProtocol {
    var initialBalance: Double { get }
    func withdraw(_ amount: Double) -> Bool
    func deposit(_ amount: Double)
    func getBalance() -> Double
}

class BaseBankAccount: BankAccountProtocol {
    var balance: Double
    let initialBalance: Double

    init(initialBalance: Double) {
        self.balance = initialBalance
        self.initialBalance = initialBalance
    }

    func deposit(_ amount: Double) {
        balance += amount
    }

    func withdraw(_ amount: Double) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }

    func getBalance() -> Double {
        return balance
    }
}

class UnsafeBankAccount: BaseBankAccount {
    override func withdraw(_ amount: Double) -> Bool {
        Thread.sleep(forTimeInterval: 0.01)
        let currentBalance = balance

        if currentBalance >= amount {
            Thread.sleep(forTimeInterval: 0.005)
            balance = currentBalance - amount
            return true
        }
        return false
    }
}

class ThreadSafeBankAccount: BaseBankAccount {
    private let queue: DispatchQueue

    override init(initialBalance: Double) {
        self.queue = DispatchQueue(label: "com.bankaccount.serialqueue")
        super.init(initialBalance: initialBalance)
    }

    override func withdraw(_ amount: Double) -> Bool {
        return queue.sync {
            Thread.sleep(forTimeInterval: 0.01)

            guard balance >= amount else { return false }
            balance -= amount
            return true
        }
    }
}
