//
//  Message.swift
//  MyQueue
//
//  Created by Han Solo on 18/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Message: NSManagedObject {
    //The text of the message to be sent.
    @NSManaged var text: String
    
    
    //The date it was created.
    @NSManaged var dateCreated: NSDate

    
    /**
    Class Method to create a new Message Object and save it.
    
    :param: text The text for the message object
    
    :returns: TRUE if the message was saved successfully, FALSE otherwise.
    */
    class func createNewMessage(text: String) -> Bool {
        //Get the AppDelegate & ManagedContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let moc = appDelegate.managedObjectContext!
        
        //Create the new message
        let newItem = NSEntityDescription.insertNewObjectForEntityForName( "Message", inManagedObjectContext: moc) as Message
        
        //Set the text on the message as the text input
        newItem.text = text
        
        //Set the date on the message as today.
        newItem.dateCreated = NSDate()
        
        //Save
        var error: NSError?
        if !moc.save(&error) {
            //An error occurred. Snap.
            return false
        }
        else {
            //Everything went A-Ok with the save.
            return true
        }
    }
    
    
    /**
    Class Method to check if the initial (default) message has been setup in the database yet.
    
    :returns: TRUE if it has, FALSE if it hasnt.
    */
    class func initialMessageCheck() -> Bool {
        //Get the AppDelegate & ManagedContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let moc = appDelegate.managedObjectContext!
        
        //Generate the fetch request.
        let fetchRequest = NSFetchRequest(entityName: "Message")
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Message] {
            //Results Found
            if (fetchResults.count < 1){
                //Query executed, but no result in the set.
                return false
            }
            else{
                //Results in the set.
                return true
            }
        }
        else {
            //No results found, return false.
            return false;
        }
    }
    
    
    
    /**
    Class Method to get the last (current) Message from the databse
    
    :returns: Message - The last (current) message from the database.
    */
    class func getLatestMessage() -> AnyObject?{
        //Get the AppDelegate & ManagedContext
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let moc = appDelegate.managedObjectContext!
        
        //Generate the fetch request.
        let fetchRequest = NSFetchRequest(entityName: "Message")
        
        //Add Predicates - i.e. Sort the business.
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Message] {
            //Results Found, return true.
            return fetchResults.first
        }
        else {
            //No results found, return false.
            return nil;
        }
    }
    
}
