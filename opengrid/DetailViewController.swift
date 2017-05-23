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
    
    @IBAction func tappedCloseButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion:nil)
    }
}



extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoint.dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = dataPoint.dataArray[row].0
        cell.detailTextLabel?.text = dataPoint.dataArray[row].1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
