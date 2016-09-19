//
//  DetailViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 9/11/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var dataPoint: PlenarioDataPoint!
    
    let textCellIdentifier = "TextCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func tappedCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}



extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoint.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = dataPoint.dataArray[row].0
        cell.detailTextLabel?.text = dataPoint.dataArray[row].1
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}
