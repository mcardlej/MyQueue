//
//  MyQueueTableViewController.swift
//  MyQueue
//
//  Created by Han Solo on 14/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import UIKit
//Used for the Text Messaging component of this app..
import MessageUI

class MyQueueTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, AddQueueEntryCellDelegate {
    
    
    /// Array for QueueItems in this VC
    var items : [QueueItem] = []
    
    /// Index of the currently selected QueueItem
    var selectedIndex : Int = 0
    
    /**
    Redef of the init method for this class.
    
    :param: aDecoder The Storyboard used to generate this VC.
    
    :returns: ViewController
    */
    required init(coder aDecoder: NSCoder) {
        //Overriding something? Alway be super'ing that business.
        super.init(coder: aDecoder)
    }
    
    /**
    Method called AFTER the view has appeared.
    */
    override func viewDidLoad() {
        //Overriding something? Alway be super'ing that business.
        super.viewDidLoad()
        
        //Not sure why, but this apparently makes the rows stop squishing up...
        self.tableView.estimatedRowHeight = 100.0;
        
        // TODO Change Navigation Background, more work needed. --JMC
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
    }
    
    //MARK: - UITableViewController Protocol Implementation
    /**
    Method called to determine the number of sections in a table view.
    
    :param: tableView TableView calling the protocol method.
    
    :returns: Number of Sections in a TableView.
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //2 Sections: 1 for the Add QueueItem Cell, 1 for the QueueItem Cells themselves.
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check which section
        if (section == 0) {
            //Only return 1 row for the 
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
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "queueItemCell")
            
            
            if (self.items.count > 0) {
                cell.textLabel?.text = self.items[indexPath.row].name;
                cell.detailTextLabel?.text = self.items[indexPath.row].phoneNumber;
                
                
                let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedRightOnCellAction:")
                swipeLeft.direction = UISwipeGestureRecognizerDirection.Right
                
                cell.addGestureRecognizer(swipeLeft)
                
            }
            else
            {
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
            
            return cell;
        }
    }
    
    
    /**
    This method setups up the fancy slide out buttons on a UITableViewCell.
    
    :param: tableView The Table View calling this method
    :param: indexPath The IndexPath of the Cell in the Table View calling this method.
    
    :returns: A UITableViewRowAction for the cell.
    */
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        //Check if this is the a QueueItem Cell.
        if (indexPath.section > 0) {
            //Setup the dele action with methods.
            var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
                
                //Not sure what this does...
                tableView.editing = false
                
                //Check to make sure there is an item to remove.
                if (indexPath.row < self.items.count){
                    //Remove the Item.
                    self.didRemoveQueueItemAt(indexPath.row)
                }
            }
            
            //Return the action for the cell.
            return [deleteAction]
        }
        else {
            //Return nothing! Good day sir!
            return nil;
        }
    }
    
    
    /**
    This method has to be implemented to allow for the fancy slide out UITableViewRowActions. No reason given as to why.
    
    :param: tableView tableView to use in this method
    */
    override func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
    }
    
    /**
    This method is fired when a cell in the tableView for this view controller is selected.
    
    :param: tableView tableView calling this method.
    :param: indexPath indexPath of the cell selected from the tableView
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        if (indexPath.section > 0){
            self.selectedIndex = indexPath.row
        }
    }
    
    
    //MARK: - MFMessageComposeViewControllerDelegate Protocol Implementations
    /**
    Method to setup and launch the Message View Controller. This is being revised.
    @TODO - Revise me.
    */
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
    
    
    /**
    Implementation Method for the MFMessageComposeViewControllerDelegate protocol.
    Is called when the MessageComposeViewController has completed.
    
    :param: controller Message Compose View Controller that was displayed.
    :param: result     Result from the Message Compose View Controller.
    */
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        //Dismiss the Message Compose View Controller as user has finished.
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //Check the result to see if the Message was sent.
        if result.value == MessageComposeResultSent.value {
            //The message was sent, remove item from Queue and Refresh the table.
            self.didRemoveQueueItemAt(self.selectedIndex);
        }
    }
    
    
    //MARK: - Gesture Recognizer Actions
    /**
    Method that is called then the UIGestureRecognizer attached to UITableViewCells is fired.
    
    :param: gesture The gesture object of the action.
    */
    func swipedRightOnCellAction(gesture: UIGestureRecognizer)
    {
        //Get the cell that called the action.
        let cell = gesture.view as UITableViewCell?
        //Get the indexPath of the cell.
        let indexPath = self.tableView.indexPathForCell(cell!) as NSIndexPath?
        //Get the row from the index path.
        let row = indexPath?.row
        //Set the VC's selectedIndex to the row, this is used later on in
        //launchMessageComposeViewController and
        //messageComposeViewController to remove the QueueItem.
        self.selectedIndex =  row!
        //Prep and Show the Message Composer View Controller.
        self.launchMessageComposeViewController()
    }
    
    
    //MARK: - Queue Management Functions
    /**
    Method to add a new item to the current queue.
    
    Method creates a new QueueItem object and adds the Name and Phone Number properties to it,
    adds the QueueItem to the current queue and refreshes the tableView.
    
    :param: name  Name of the Person to add to the Queue
    :param: phone Phone Number to send the Message to.
    */
    func didAddNewQueueItem(name:String, phone:String) {
        //Create the new QueueItem
        var i = QueueItem()
        i.name = name
        i.phoneNumber = phone
        
        //Add it to the current queue.
        self.items.append(i)
        
        //Update the tableView in the Main Thread.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    
    /**
    Method to remove an item from the current queue.
    
    Method removes the item from the queue at removedIndex the refreshes the tableView
    
    :param: removedIndex Index of the current Queue to remove the QueueItem from.
    */
    func didRemoveQueueItemAt(removedIndex: Int) {
        //Remove the item from the current queue.
        self.items.removeAtIndex(removedIndex)
        
        //Refresh the tableView in the Main Thread.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
}
