//
//  ViewController.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 19/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import UIKit
import CoreData
import SQLite3

class ItemTableViewCell: UITableViewCell{
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellSubLabel: UILabel!
    @IBOutlet weak var cellPriceLabel: UILabel!
    @IBOutlet weak var cellItemId: UILabel!
    
}

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var qtyInBasketButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var basketQty = 0
    var totalPrice: Float = 0.0
    //    var basket: NSManagedObject
    var items: [MyItem] = []
    //    var idsInBasket: [String] = []
    
    var db: OpaquePointer? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Basket")
        //
        //        do {
        ////            basket = try context.object(with: fetchRequest)
        //            basket = try context.value(forKey: "Basket") as! NSManagedObject
        //        } catch let error as NSError {
        //            print("Could not fetch. \(error), \(error.userInfo)")
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatabase()
        createTable(tableName: "ItemSchema")
        createTable(tableName: "BasketSchema")
        readDatabase(tableName: "ItemSchema")
        //        createBasketTable()
        
        // set labels
        qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
        totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil{
            
            basketQty+=1
            totalPrice = totalPrice + items[indexPath.row].price
            
            qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
            totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
            
            //save basketQty and totalPrice to coredata
//            saveToCD()
            
            //save selected item to database
            createTable(tableName: "BasketSchema")
            insertIntoBasketTable(id: items[indexPath.row].id)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        print("passing name: \(items[indexPath.row].name) subtitle: \(items[indexPath.row].subtitle)")
        
        detailVC.detailName = items[indexPath.row].name
        detailVC.detailSubtitle = items[indexPath.row].subtitle
        detailVC.detailPrice = items[indexPath.row].price
        detailVC.detailDesc = items[indexPath.row].description
        detailVC.detailImage = items[indexPath.row].image
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        print("passed name: \(items[indexPath.row].name) subtitle: \(items[indexPath.row].subtitle)")
        
    }
    
    func saveToCD(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Basket", in: managedContext)!
        
        let bItem = NSManagedObject(entity: entity, insertInto: managedContext)
        bItem.setValue(totalPrice, forKeyPath: "price")
        bItem.setValue(basketQty, forKeyPath: "quantity")
        
        print("bItem: price: \(totalPrice) + qty: \(basketQty)")
        
        do {
            try managedContext.save()
            //            basket.save(bItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ItemTableViewCell
        
        let localItem = items[indexPath.row]
        let localImage = ["Apple", "Apricot", "Cantaloupe", "Banana", "Blueberry"]
        
        
        cell.cellItemId?.text = "\(localItem.id)"
        cell.cellNameLabel?.text = localItem.name
        cell.cellSubLabel?.text = localItem.subtitle
        cell.cellPriceLabel?.text = "£\(localItem.price)"
        
        cell.cellImageView?.image  = UIImage(named: localImage[indexPath.row%5])
        
        return cell
    }
    
    func setupDatabase(){
        let database = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("PurchaseDB.sqlite")
        
        //open database
        if sqlite3_open(database.path, &db) == SQLITE_OK{
            print("Database opened")
            print("\(database.path)")
        } else {
            print("Error opening database")
        }
    }
    
    func createTable(tableName: String){
        //create tables
        var createStmtPointer: OpaquePointer? = nil
        let createStmt = "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT NOT NULL UNIQUE, name TEXT, subtitle TEXT, image TEXT, price NUMERIC, description TEXT, PRIMARY KEY( id ));"
        if sqlite3_exec(db, createStmt, nil, &createStmtPointer, nil) == SQLITE_OK{
            print("\(tableName) table in database created/exists")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating \(tableName) table: \(errmsg)")
        }
        
        sqlite3_finalize(createStmtPointer)
    }
    
    func readDatabase(tableName: String){
        items.removeAll()
        
        let query = "select * from \(tableName)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            print("Reading from database")
            print("\(query)")
        }else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing reading: \(errmsg)")
            return
        }
        
        //parsing read data
        print("Sql Read result: \(sqlite3_step(statement))")
        var counter = 0
        
        while(sqlite3_step(statement) == SQLITE_ROW){
            counter+=1
            print("Counter in loop \(counter)")
            
            let id = sqlite3_column_int(statement, 0)
            let name = String(cString: sqlite3_column_text(statement, 1))
            let subtitle = String(cString: sqlite3_column_text(statement, 2))
            let image = String(cString: sqlite3_column_text(statement, 3))
            let price = String(cString: sqlite3_column_text(statement, 4))
            let description1 = String(cString: sqlite3_column_text(statement, 5))
            
            let dbItem = MyItem(id: Int(id), name: String(describing: name), subtitle: String(describing: subtitle), image: String(describing: image), price: (String(describing: price) as NSString).floatValue, description: String(describing: description1))
            
//            print("ID: \(id) Name: \(name) Subtitle: \(subtitle) Price: \(price) Image: \(image) Description: \(description1)")
            
            //adding values to list
            items.append(dbItem)
        }
        sqlite3_finalize(statement)
    }
    
    func insertIntoBasketTable(id: Int){
        let insertQuery = "insert into BasketSchema select * from ItemSchema where id = \(id);"
        print(insertQuery)
        
        var insertStmt: OpaquePointer? = nil
        let execReturnCode = sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil)
        if execReturnCode == SQLITE_OK {
            //            let id: Int = id
            //            let name: String = name
            //            let subtitle: String = subtitle
            //            let image: String = image
            //            let price: Float = price
            //            let description: String = description
            //
            //            sqlite3_bind_int(insertStmt, 1, Int32(id))
            //            sqlite3_bind_text(insertStmt, 2, name, -1, nil)
            //            sqlite3_bind_text(insertStmt, 3, subtitle, -1, nil)
            //            sqlite3_bind_text(insertStmt, 4, image, -1, nil)
            //            sqlite3_bind_double(insertStmt, 5, Double(price))
            //            sqlite3_bind_text(insertStmt, 6, description, -1, nil)
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted row. \(execReturnCode)")
            } else {
                print("Could not insert row. \(execReturnCode)")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStmt)
    }
}
