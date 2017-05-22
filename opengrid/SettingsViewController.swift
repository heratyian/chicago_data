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
    func giveStartAndEndDate(_ start:Date, end: Date)
}

class SettingsViewController: UIViewController  {
    
    // MARK: Delegates
    var delegate: SettingsViewControllerDelegate?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var todaysDate: Date!
    var tenYearsAgo: Date!
    var startDate: Date!
    var endDate: Date!
    
    // MARK: Constants
    let textCellIdentifier = "TextCell"
    let buttonTitles = ["From", "To"]
    
    let buttonDateString: NSMutableArray = []
    var buttonDates = [Date(), Date()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDates()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: IBActions
    @IBAction func tappedCloseButton(_ sender: AnyObject) {
        // dismiss view controller
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func tappedSearchButton(_ sender: AnyObject) {
        // send query to plenario with new dates
        // return to mapViewController
        // startDate and endDate objects
        
        self.dismiss(animated: true) {
            self.delegate?.giveStartAndEndDate(self.buttonDates[0], end: self.buttonDates[1])
        }
    }
    
    fileprivate func tappedDateEdit(_ indexPath: IndexPath) {
        //title
        //startDate
        //endDate
        var defaultDate = Date()
        var minDate = Date()
        var maxDate = Date()
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
        
        DatePickerDialog().show(title: titleString, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: defaultDate, minimumDate: minDate, maximumDate: maxDate, datePickerMode: .date) { (date) in
            
            if let date = date {
                
                // cell
                let cell = self.tableView.dequeueReusableCell(withIdentifier: self.textCellIdentifier, for: indexPath)
                
                cell.textLabel?.text = self.buttonTitles[indexPath.row]
                cell.detailTextLabel?.text = self.getFormattedStringFromDate(date)
                
                // vars
                self.buttonDates[indexPath.row] = date
                self.buttonDateString[indexPath.row] = self.getFormattedStringFromDate(date)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
}

// Dates
extension SettingsViewController {
    
    fileprivate func initDates() {
        // create dates
        todaysDate = Date()
        tenYearsAgo = Date(timeInterval: -315360000.0, since: todaysDate)
        
        buttonDates[0] = startDate
        buttonDates[1] = endDate
        
        buttonDateString[0] = getFormattedStringFromDate(buttonDates[0])
        buttonDateString[1] = getFormattedStringFromDate(buttonDates[1])
    }
    
    fileprivate func getFormattedStringFromDate(_ date: Date) -> String {
        // set date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = buttonTitles[row]
        cell.detailTextLabel?.text = buttonDateString[row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedDateEdit(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


















