//
//  QueueItem.swift
//  MyQueue
//
//  Created by Han Solo on 15/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import Foundation


/**
*  Data representing an Item on the Queue
*/
class QueueItem  {
    /// The Persons Name
    var name        = String()
    
    /// Their Contact Phone Number
    var phoneNumber = String()
    
    /// The Time they were added to the Queue
    var timeAdded   = NSDate()
    
    
    /**
    Init method for the QueueItem Class
    
    :param: name        zero length NSString
    :param: phoneNumber zero length NSString
    
    :returns: New QueueItem
    */
    init(name:String = "", phoneNumber:String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
        self.timeAdded = NSDate()
    }
}