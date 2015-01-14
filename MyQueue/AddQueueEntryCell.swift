//
//  AddQueueEntryCell.swift
//  MyQueue
//
//  Created by Han Solo on 14/01/2015.
//  Copyright (c) 2015 MyQueueApp. All rights reserved.
//

import UIKit

class AddQueueEntryCell: UITableViewCell {
    var delegate:AddQueueEntryCellDelegate! = nil
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBAction func addNewEntryPressed(sender: AnyObject) {
        delegate!.didAddNewQueueItem(nameField.text, phone: phoneNumberField.text)
        nameField.text = "";
        phoneNumberField.text = "";
    }
}

protocol AddQueueEntryCellDelegate{
    func didAddNewQueueItem(name:String, phone:String)
}
