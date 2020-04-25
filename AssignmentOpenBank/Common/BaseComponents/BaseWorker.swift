//
//  BaseWorker.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}

class BaseWorker <I, R> {
    
    private let respondQueue: DispatchQueue
    
    init(respondQueue: DispatchQueue = DispatchQueue.main) {
        self.respondQueue = respondQueue
    }
    
    /**
     It starts the execution of the current worker.
     - Parameters:
     - completion: completion block to be invoked when the result is available
     */
    final func execute(completion: @escaping ((R) -> Void)) {
        job { (result) in
            self.respondQueue.async {
                completion(result)
            }
        }
    }
    
    /**
     It starts the execution of the current worker.
     - Parameters:
     - input: input params
     - completion: completion block to be invoked when the result is available
     */
    final func execute(input: I, completion: @escaping ((R) -> Void)) {
        job(input: input) { (result) in
            self.respondQueue.async {
                completion(result)
            }
        }
    }
    
    /**
     This method must be implemented by the subclass and it represents the job to be done by the worker. It shouldn't be called directly by any client.
     - Parameters:
     - completion: completion block to be invoked when the result is available
     */
    public func job(completion: @escaping ((R) -> Void) ) {
        fatalError("Worker is an abstract class, you should implement your own")
    }
    
    /**
     This method must be implemented by the subclass and it represents the job to be done by the worker. It shouldn't be called directly by any client.
     - Parameters:
     - input: input params
     - completion: completion block to be invoked when the result is available
     */
    public func job(input: I, completion: @escaping ((R) -> Void) ) {
        fatalError("Worker is an abstract class, you should implement your own")
    }
    
    /**
     This method must be implemented by the subclass and it should allow to cancel the workers job.
     */
    public func cancel() { }
}
