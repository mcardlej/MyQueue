//
//  QueueItem.swift
//  MyQueue
//
//  Created by Han Solo on 15/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import Foundation

class QueueItem  {
    var name        = String()
    var phoneNumber = String()
    var timeAdded   = NSDate()
    
    init(name:String = "", phoneNumber:String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
        self.timeAdded = NSDate()
    }
    
   
}