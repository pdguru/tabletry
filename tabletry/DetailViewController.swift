//
//  DetailViewController.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 22/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UIViewController {
        
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Item name"
    }
    
    @IBAction func done(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         super.prepare(for: segue, sender: sender)
    }
    

}
