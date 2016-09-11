//
//  DetailViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 9/11/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var caseNumberLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var wardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    
    
    var caseNumberString: String!
    var typeString: String!
    var descriptionString: String!
    var wardInt: Int!
    var dateString: String!
    var communityString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caseNumberLabel.text = caseNumberString
        typeLabel.text = typeString
        descriptionLabel.text = descriptionString
        wardLabel.text = String(wardInt)
        dateLabel.text = dateString
        communityLabel.text = communityString
    }
    
    @IBAction func tappedCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}
