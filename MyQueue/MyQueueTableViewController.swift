//
//  MyQueueTableViewController.swift
//  MyQueue
//
//  Created by Han Solo on 14/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import UIKit
import MessageUI

class MyQueueTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, AddQueueEntryCellDelegate {
    
    
    
    var items : [QueueItem] = []
    var selectedIndex : Int = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Number of Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //2 Sections
        //1. New Queue Input
        //2. The actual queue.
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Static for the moment.
        if (section == 0) {
            return 1;
        }
        else {
            if (self.items.count > 0){
                return self.items.count;
            }else{
                return 1
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            
            var cell:AddQueueEntryCell = self.tableView.dequeueReusableCellWithIdentifier("addQueueCell") as AddQueueEntryCell
            cell.delegate = self
            if (self.items.count < 1){
                cell.nameField.becomeFirstResponder()
                cell.setupTextFieldDelegates()  
            }
            return cell;
            
        }else {
            var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("queueItemCell") as UITableViewCell
            
            if (self.items.count > 0) {
                cell.textLabel?.text = self.items[indexPath.row].name;
                cell.detailTextLabel?.text = self.items[indexPath.row].phoneNumber;
            }
            else
            {
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
            
            return cell;
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if (indexPath.section > 0) {
            var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
                tableView.editing = false
                println("deleteAction")
                if (indexPath.row < self.items.count){
                    self.items.removeAtIndex(indexPath.row)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            
            return [deleteAction]
        }
        else {
            return nil;
        }
    }
    
    
    //Not sure why, but apparently this has to be here...who knew?
    override func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
    }
    
    func didAddNewQueueItem(name:String, phone:String) {
        var i = QueueItem()
        i.name = name
        i.phoneNumber = phone
        
        
        self.items.append(i)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section > 0){
            self.selectedIndex = indexPath.row
            self.launchMessageComposeViewController()
        }
    }
    
    
    func launchMessageComposeViewController() {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = [self.items[selectedIndex].phoneNumber]
            messageVC.body = self.items[selectedIndex].name + ", your order is ready for pickup!"
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            var alert = UIAlertController(title: "Oh Snap!", message: "You cant send messages from your device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dang it!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if result.value == MessageComposeResultSent.value {
            self.items.removeAtIndex(self.selectedIndex)
        }
    }
}
