//
//  SettingsViewController.swift
//  MyQueue
//
//  Created by Han Solo on 14/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var saveButtonPressed: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let message: Message = Message.getLatestMessage() as Message
        messageText.text = message.valueForKey("text") as String
    }
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if (Message.createNewMessage(messageText.text)){
            return
        }
        else{
            var alert = UIAlertController(title: "Oh Snap!", message: "An error occurred saving this message!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dang it!", style: UIAlertActionStyle.Default, handler: nil))
        }
    }
}
