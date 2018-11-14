//
//  BasketTableViewController.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 23/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import UIKit
import CoreData
import SQLite3

class BasketItemTableViewCell: UITableViewCell{
    
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var basketNameLabel: UILabel!
    @IBOutlet weak var basketSubLabel: UILabel!
    @IBOutlet weak var basketQtyLabel: UILabel!
    @IBOutlet weak var basketItemId: UILabel!
}

class BasketTableViewController: UITableViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemsInBasket: [MyItem] = []
    
    //    var db: OpaquePointer? = nil
    var dbInstance: DatabaseHelper?
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Items in basket"
        
        dbInstance = DatabaseHelper.instance
        if dbInstance?.openDatabase() == SQLITE_OK {
            itemsInBasket = (dbInstance?.readDatabase("BasketSchema"))!
            print("Items read: \(itemsInBasket.count)")
        } else {
            print("Error opening database.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInBasket.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil{
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketItem", for: indexPath) as! BasketItemTableViewCell
        
        let localItem = itemsInBasket[indexPath.row]
        let localImage = ["Apple", "Apricot", "Cantaloupe", "Banana", "Blueberry"]
        
        cell.basketItemId?.text = "\(localItem.id)"
        cell.basketNameLabel?.text = (localItem.name)
        cell.basketSubLabel?.text = (localItem.subtitle)
        cell.basketQtyLabel?.text = "\(localItem.price)"
        
        cell.basketImageView?.image  = UIImage(named: localImage[indexPath.row%5])
        
        return cell
    }
    
    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            if dbInstance?.deleteDatabaseTable(tableName: "BasketSchema", id: itemsInBasket[indexPath.row].id) == SQLITE_OK{
                itemsInBasket.remove(at: indexPath.row)
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .fade)
            }
        }
    }
    
    @IBAction func clearBasket(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Empty basket?", message: "Are you sure to empty your basket? \n (Swipe left on an item to remove it from the basket)" , preferredStyle: .alert)
        
        let positiveAction = UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            self.emptyBasket()
        })
        
        let negativeAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(positiveAction)
        alert.addAction(negativeAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func emptyBasket(){
        if dbInstance?.deleteDatabaseTable(tableName: "BasketSchema", id: -1) == SQLITE_OK{
            done()
        }
    }
}
