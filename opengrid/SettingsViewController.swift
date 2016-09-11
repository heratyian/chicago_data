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

class SettingsViewController: UIViewController {
    
    // Delegate
    var delegate: SettingsViewControllerDelegate?
    
    // Properties
    var todaysDate: NSDate!
    var tenYearsAgo: NSDate!
    
    var startDate: NSDate!
    var endDate: NSDate!
    
    
    
    @IBOutlet weak var typeStackView: UIStackView!
    @IBOutlet weak var timeframeStackView: UIStackView!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var typeCrimeLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        setDates()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeStackView.hidden = true
        timeframeStackView.hidden = false
        
    }
    
    private func setDates() {
        // create dates
        todaysDate = NSDate()
        tenYearsAgo = NSDate(timeInterval: -315360000.0, sinceDate: todaysDate)
        startDateLabel.text = getFormattedStringFromDate(startDate)
        endDateLabel.text = getFormattedStringFromDate(endDate)
    }
    
    private func getFormattedStringFromDate(date: NSDate) -> String {
        // set date formatter
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.stringFromDate(date)
    }
    
    
    
    @IBAction func tappedCrimeButton(sender: AnyObject) {
        
    }
    
    @IBAction func tappedTypeButton(sender: AnyObject) {
        // move timeframeStackView to the left of screen
        // move typeStackView on screen
        

        
//        var frame = timeframeStackView.frame
//        frame.origin.x = self.view.frame.size.width
//        timeframeStackView.frame = frame
        timeframeStackView.hidden = true
        typeStackView.hidden = false
        
        
    }
    
    @IBAction func tappedTimeframeButton(sender: AnyObject) {
        timeframeStackView.hidden = false
        typeStackView.hidden = true
    }
    
    // dismiss view controller
    @IBAction func tappedCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    

    @IBAction func tappedStartDateEditButton(sender: AnyObject) {
        
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: startDate, minimumDate: tenYearsAgo, maximumDate: endDate, datePickerMode: .Date) { (date) in
            
            if let date = date {
                self.startDateLabel.text = self.getFormattedStringFromDate(date)
                self.startDate = date
                
            }
        }
    }
    
    
    @IBAction func tappedEndDateEditButton(sender: AnyObject) {
       
        DatePickerDialog().show("End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: endDate, minimumDate: startDate, maximumDate: todaysDate, datePickerMode: .Date) { (date) in
            
            if let date = date {
                self.endDateLabel.text = self.getFormattedStringFromDate(date)
                self.endDate = date
            }
        }
    }
    
    
    @IBAction func tappedSearchButton(sender: AnyObject) {
        // send query to plenario with new dates
        // return to mapViewController
        
        // startDate and endDate objects
        
        self.dismissViewControllerAnimated(true) { 
            self.delegate?.giveStartAndEndDate(self.startDate, end: self.endDate)
        }
    }
    
    
}
