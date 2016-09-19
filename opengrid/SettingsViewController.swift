//
//  SettingsViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 8/26/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit
import DatePickerDialog
import SwiftyButton

@objc protocol SettingsViewControllerDelegate: class {
    func giveStartAndEndDate(start:NSDate, end: NSDate)
}

class SettingsViewController: UIViewController  {
    
    // Delegate
    var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    var todaysDate: NSDate!
    var tenYearsAgo: NSDate!
    
    var startDate: NSDate!
    var endDate: NSDate!
    
    // date labels
//    @IBOutlet weak var startDateLabel: UILabel!
//    @IBOutlet weak var endDateLabel: UILabel!
    
    let textCellIdentifier = "TextCell"
    let buttonTitles = ["From", "To"]
    let buttonDateString: NSMutableArray = []
    var buttonDates = [NSDate(), NSDate()]
    
    
    override func viewWillAppear(animated: Bool) {
        
        initDates()
        
//        buttonDates.append(startDate)
//        buttonDates.append(endDate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func initDates() {
        // create dates
        todaysDate = NSDate()
        tenYearsAgo = NSDate(timeInterval: -315360000.0, sinceDate: todaysDate)
//        let thirtyDaysAgo = NSDate(timeInterval: -2592000.0, sinceDate: todaysDate)
        
//        startDate = thirtyDaysAgo
//        endDate = todaysDate
        
        buttonDates[0] = startDate
        buttonDates[1] = endDate
        
        buttonDateString[0] = getFormattedStringFromDate(buttonDates[0])
        buttonDateString[1] = getFormattedStringFromDate(buttonDates[1])

    }
    
    private func setDates() {
        
        
        // set date strings
        
        // set nsdate values
    }
    
    
    
    private func getFormattedStringFromDate(date: NSDate) -> String {
        // set date formatter
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.stringFromDate(date)
    }
    
    
    // dismiss view controller
    @IBAction func tappedCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    

//    @IBAction func tappedStartDateEditButton(sender: AnyObject) {
//        
//        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: startDate, minimumDate: tenYearsAgo, maximumDate: endDate, datePickerMode: .Date) { (date) in
//            
//            if let date = date {
//                self.startDateLabel.text = self.getFormattedStringFromDate(date)
//                self.startDate = date
//                
//            }
//        }
//    }
//    
//    
//    @IBAction func tappedEndDateEditButton(sender: AnyObject) {
//       
//        DatePickerDialog().show("End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: endDate, minimumDate: startDate, maximumDate: todaysDate, datePickerMode: .Date) { (date) in
//            
//            if let date = date {
//                self.endDateLabel.text = self.getFormattedStringFromDate(date)
//                self.endDate = date
//            }
//        }
//    }
    
    
    @IBAction func tappedSearchButton(sender: AnyObject) {
        // send query to plenario with new dates
        // return to mapViewController
        
        // startDate and endDate objects
        
        self.dismissViewControllerAnimated(true) { 
            self.delegate?.giveStartAndEndDate(self.buttonDates[0], end: self.buttonDates[1])
        }
    }
    
    func tappedDateEdit(indexPath: NSIndexPath) {
        //title
        //startDate
        //endDate
        var defaultDate = NSDate()
        var minDate = NSDate()
        var maxDate = NSDate()
        var titleString = String()
        
        if indexPath.row == 0 {
            // start
            titleString = "Start Date"
            defaultDate = buttonDates[0]
            minDate = tenYearsAgo
            maxDate = buttonDates[1]
        } else {
            // end
            titleString = "End Date"
            defaultDate = buttonDates[1]
            minDate = buttonDates[0]
            maxDate = todaysDate
        }
        
        DatePickerDialog().show(titleString, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: defaultDate, minimumDate: minDate, maximumDate: maxDate, datePickerMode: .Date) { (date) in
            
            if let date = date {
                
                // cell
                let cell = self.tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath)
                
                cell.textLabel?.text = self.buttonTitles[indexPath.row]
                cell.detailTextLabel?.text = self.getFormattedStringFromDate(date)
                
                // vars
                self.buttonDates[indexPath.row] = date
                self.buttonDateString[indexPath.row] = self.getFormattedStringFromDate(date)
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            }
        }
        
        
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = buttonTitles[row]
        cell.detailTextLabel?.text = buttonDateString[row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tappedDateEdit(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}


















