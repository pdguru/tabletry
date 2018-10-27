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
    @IBOutlet weak var detailSubtitleLbl: UILabel!
    @IBOutlet weak var detailPriceLbl: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDescTV: UITextView!
    
    
    var detailSubtitle: String = ""
    var detailPrice: Float = 0.0
    var detailImage: String = ""
    var detailDesc: String = ""
    var detailName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VIEW DID LOAD detail name: \(detailName) subtitle: \(detailSubtitle)")
        
        detailSubtitleLbl?.text = "\(detailName) \(detailSubtitle)"
        detailDescTV?.text = detailDesc
        detailPriceLbl?.text = "£ \(detailPrice)"
        detailImageView?.image = UIImage(named: detailImage)
    }
    
    @IBAction func done(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    
}
