//
//  Utility.swift
//  Aphelion
//
//  Created by Christopher Scalcucci on 10/25/15.
//  Copyright © 2015 Aphelion. All rights reserved.
//

import Foundation

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}


//User presses button
//Computes player's attack & enemy defense
//Determines enemy health after attack
//Checks if enemy is dead
//Updates enemy health (and player exp if match ends)
//Computers enemy's attack & players defense
//Determines player health after attack
//Checks if player is dead
//Updates player health (and if game is over)

//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//    let someString = ... //some long running operations
//
//        dispatch_async(dispatch_get_main_queue()) {
//            self.someTextField.text = someString
//    }
//}