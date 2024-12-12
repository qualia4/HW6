Hi there!
Today we'll be doing concurrency 🙂🙂🙂. 

# Info
*Do not forget to include SwiftLint into your project. Works without this package wont be accepted. You should create a new project for this homework. You may create either iOS or macOS project.
Please use one project for all tasks

# Task 1: Prime Number Checker (3 points)
Build a concurrent program that checks whether numbers in a large list are prime.

Requirements:
* Divide the work into multiple concurrent tasks using DispatchQueue or OperationQueue.
* Each task should check a subset of numbers.
* Combine results from all tasks and print the prime numbers in the original order

# Task 2: Shared Resource Race (3 points)
Simulate a race condition scenario where multiple threads are trying to withdraw money from a shared bank account. Create a BankAccount class with deposit and withdraw methods. Add 
Implement a solution to prevent over-withdrawal.

Requirements:

* Use DispatchQueue to simulate concurrent withdrawals.
* Start without synchronization to demonstrate a race condition.
* Fix the race condition using a thread-safe approach (e.g., a serial queue or locks). You can create a separate class to demonstrate the thread-safe approach.
* Print the final account balance.

# Task 3: (4 points)
Apply multiple image filters (grayscale, blur, contrast adjustment) to a batch of images concurrently. You can take one image but create several instances of UIImage class.
Each filter should run in its own queue, and an image should only proceed to the next filter after the previous one completes.
Check the filters documentation here: https://developer.apple.com/documentation/coreimage/color_effect_filters

Requirements:

* Use DispatchWorkItem to chain tasks for each filter.
* Ensure images are processed independently but maintain the filter sequence.
* Show processed images in the UI (you can use collection view or just a few UIImageViews).

# Task 4 (optional): Concurrent Graph Traversal (3 points)
The goal of this task is to implement a system to traverse a Directed Acyclic Graph (DAG) while respecting dependency constraints. Each node in the graph represents a computational task, and nodes can only execute once all their dependencies (other nodes) have completed.

To test this, make next graphs:
```
A -> B -> C
↓
D -> E
↓
F
```

```
A -> B -> C -> D -> E
↓    ↓    ↓    ↓    ↓
F    G    H    I    J
```

## Graph Representation:
The graph consists of nodes and edges:
* Nodes: Represent individual tasks that need to be executed. Let's say operation is a print of unique emoji and sleep for a random time (1-3 seconds).
* Edges: Represent dependencies. An edge from Node A to Node B means that Node B depends on Node A (Node A must finish before Node B can start).
The graph is a DAG, meaning it contains no cycles and has a clear order in which tasks can be executed.

## Dependency Management:
* Nodes with no dependencies can start execution immediately.
* A node can execute only after all its dependencies have been completed.

## Concurrency:
* Nodes that are independent of each other (i.e., have no common dependencies) can execute concurrently to maximize efficiency.
* Use Swift’s concurrency tools like DispatchGroup or OperationQueue to manage parallel execution.

## Execution Control:
* Ensure each node executes exactly once.
* Print results of each node’s computation in the correct logical order, even if they execute concurrently.
