//
//  BasketTableViewController.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 23/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import UIKit

class AddToBasketViewController: UIViewController {

    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add to basket view"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

}
