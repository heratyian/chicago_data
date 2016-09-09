//
//  SettingsViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 8/26/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit
import DatePickerDialog

class SettingsViewController: UIViewController {
    
    // Properties
    var todaysDate: NSDate!
    var ninetyDaysAgo: NSDate!
    var tenYearsAgo: NSDate!
    
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        // create dates
        todaysDate = NSDate()
        ninetyDaysAgo = NSDate(timeInterval: -7776000.0, sinceDate: todaysDate)
        tenYearsAgo = NSDate(timeInterval: -315360000.0, sinceDate: todaysDate)
        
        
        
        startDateLabel.text = getStringFromDate(ninetyDaysAgo)
        endDateLabel.text = getStringFromDate(todaysDate)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func getStringFromDate(date: NSDate) -> String {
        // set date formatter
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        return formatter.stringFromDate(date)
    }
    
    
    // dismiss view controller
    @IBAction func tappedCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    

    @IBAction func tappedStartDateEditButton(sender: AnyObject) {
        
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: ninetyDaysAgo, minimumDate: tenYearsAgo, maximumDate: todaysDate, datePickerMode: .Date) { (date) in
            
            if let date = date {
                self.startDateLabel.text = self.getStringFromDate(date)
            }
        }
    }
    
    
    @IBAction func tappedEndDateEditButton(sender: AnyObject) {
       
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: todaysDate, minimumDate: tenYearsAgo, maximumDate: todaysDate, datePickerMode: .Date) { (date) in
            
            if let date = date {
                self.endDateLabel.text = self.getStringFromDate(date)
            }
        }
    }
    
    
    @IBAction func tappedSearchButton(sender: AnyObject) {
        // send query to plenario with new dates
        // return to mapViewController
        
    }
    
    
}
