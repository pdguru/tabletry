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
    
    var dbInstance: DatabaseHelper?
    
    var itemsInBasket: [MyItem] = []
    
    //    var db: OpaquePointer? = nil
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Items in basket"
        
        let status = dbInstance?.openDatabase()
        if status == SQLITE_OK {
            itemsInBasket = (dbInstance?.readDatabase("BasketSchema"))!
            print("Items read: \(itemsInBasket.count)")
        }else {
            print("Error opening database: \(status)")
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            if dbInstance?.deleteDatabaseTable(tableName: "BasketSchema", id: itemsInBasket[indexPath.row].id) == SQLITE_OK{
                itemsInBasket.remove(at: indexPath.row)
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .fade)
            }
        }
    }
    
    @IBAction func clearBasket(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Items in basket", message: "Are you sure to empty your basket? \n (Swipe left on item to remove it from the basket)" , preferredStyle: .alert)
        
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

//    func setupDatabase(){
//        let database = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("PurchaseDB.sqlite")
//
//        //open database
//        let sqlExecReturn = sqlite3_open(database.path, &db)
//        print("Basket sqlExecReturn: \(sqlExecReturn)")
//        if  sqlExecReturn == SQLITE_OK{
//            print("Database opened")
//            print("\(database.path)")
//        } else {
//            print("Error opening database")
//        }
//    }

//    func readDatabase(){
//        itemsInBasket.removeAll()
//
//        let query = "select * from BasketSchema"
//        var statement: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
//            print("Reading from database")
//            print("\(query)")
//        }else {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing reading: \(errmsg)")
//            return
//        }
//
//        //parsing read data
//        print("Sql Read result: \(sqlite3_step(statement))")
//        var counter = 0
//
//        while(sqlite3_step(statement) == SQLITE_ROW){
//            counter+=1
//            print("Counter in loop \(counter)")
//
//            let id = sqlite3_column_int(statement, 0)
//            let name = String(cString: sqlite3_column_text(statement, 1))
//            let subtitle = String(cString: sqlite3_column_text(statement, 2))
//            let image = String(cString: sqlite3_column_text(statement, 3))
//            let price = String(cString: sqlite3_column_text(statement, 4))
//            let description1 = String(cString: sqlite3_column_text(statement, 5))
//
//            let dbItem = MyItem(id: Int(id), name: String(describing: name), subtitle: String(describing: subtitle), image: String(describing: image), price: (String(describing: price) as NSString).floatValue, description: String(describing: description1))
//
////            print("ID: \(id) Name: \(name) Subtitle: \(subtitle) Price: \(price) Image: \(image) Description: \(description1)")
//
//            //adding values to list
//            itemsInBasket.append(dbItem)
//        }
//        sqlite3_finalize(statement)
//    }
//
//    func deleteDatabaseTable(tableName: String, id: Int){
//        var deleteStatementStirng: String
//        var successMessage: String
//        var errorMessage: String
//
//        if id == -1 {
//            deleteStatementStirng = "drop table \(tableName);"
//            successMessage = "Table dropped."
//            errorMessage = "Error dropping table."
//        } else {
//            deleteStatementStirng = "DELETE FROM \(tableName) WHERE id = \(id);"
//            successMessage = "Row deleted."
//            errorMessage = "Error deleting row."
//        }
//
//        var deleteStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//            if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                print(successMessage)
//            } else {
//                print(errorMessage)
//            }
//        } else {
//            print("DELETE statement could not be prepared")
//        }
//
//        sqlite3_finalize(deleteStatement)
//    }

