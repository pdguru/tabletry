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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var qtyInBasketButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var basketQty = 0
    var totalPrice: Float = 0.0
    var items = [MyItem]()
    
    //    var db: OpaquePointer? = nil
    var dbInstance: DatabaseHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        activityIndicator.stopAnimating()
        
        downloadJsonFromUrl(url: "https://my.api.mockaroo.com/items.json?key=f2324050")
        
        // set labels
        qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
        totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
        
        //        setupDatabase()
        dbInstance = DatabaseHelper.instance
        if dbInstance?.openDatabase() == SQLITE_OK {
            if dbInstance?.createTable(tableName: "BasketSchema") == SQLITE_OK {
                print("Database opened and table created")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Items: \(items.count)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil{
            
            //save selected item to database
            if dbInstance?.insertIntoBasketTable(id: items[indexPath.row].id, name: items[indexPath.row].name, subtitle: items[indexPath.row].subtitle, image: items[indexPath.row].image, price: items[indexPath.row].price, description: items[indexPath.row].description) == SQLITE_OK{
                basketQty+=1
                totalPrice = totalPrice + items[indexPath.row].price
                
                qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
                totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
            }
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
    
    func downloadJsonFromUrl(url: String){
        print("Begin downloading data")
        if !self.activityIndicator.isAnimating{
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        
        guard let downloadUrl  = URL(string: url) else {return}
        URLSession.shared.dataTask(with: downloadUrl) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error loading data from URL")
                self.showErrorAlert()
                return
            }
            print("Json downloaded successfully")
            do{
                let decoder = JSONDecoder()
                //                let downloadedItems = try decoder.decode([MyItem].self, from: data)
                //                print("Downloaded data: \(downloadedItems[0].name)")
                self.items = try decoder.decode([MyItem].self, from: data)
                print("Downloaded data size: \(self.items.count)")
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            } catch {
                print("Error after downloading data")
                self.showErrorAlert()
            }
            }.resume()
        
        if self.activityIndicator.isAnimating{
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Uh oh!", message: "Unfortunately, data could not be downloaded at this time.\nPlease try again" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ItemTableViewCell
        
        let localItem = items[indexPath.row]
        let localImage = ["Apple", "Apricot", "Cantaloupe", "Banana", "Blueberry"]
        
        
        cell.cellItemId?.text = "\(localItem.id)"
        cell.cellNameLabel?.text = localItem.name
        cell.cellSubLabel?.text = localItem.subtitle
        cell.cellPriceLabel?.text = "£\(localItem.price)"
        
        //load image from URL
        if let imageURL = URL(string: localItem.image){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if data != nil {
                    DispatchQueue.main.async {
                        cell.cellImageView?.image  = UIImage(data: data!)
                    }
                }else {
                    DispatchQueue.main.async {
                        cell.cellImageView?.image = UIImage(named: localImage[indexPath.row%5])
                    }
                }
            }
        }
        return cell
    }
}

//    func setupDatabase(){
////        let database = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("PurchaseDB.sqlite")
//
//        let database = Bundle.main.resourceURL?.appendingPathComponent("PurchaseDB.sqlite")
//
//        //open database
//        if sqlite3_open(database?.path, &db) == SQLITE_OK{
//            print("Database opened")
//            print(database?.path)
//        } else {
//            print("Error opening database")
//        }
//    }

//    func createTable(tableName: String){
//        //create tables
//        var createStmtPointer: OpaquePointer? = nil
//        let createStmt = "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT NOT NULL , name TEXT, subtitle TEXT, image TEXT, price NUMERIC, description TEXT, PRIMARY KEY( id ));"
//        if sqlite3_exec(db, createStmt, nil, &createStmtPointer, nil) == SQLITE_OK{
//            print("\(tableName) table in database created/exists")
//        } else {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error creating \(tableName) table: \(errmsg)")
//        }
//        
//        sqlite3_finalize(createStmtPointer)
//    }

//    func readDatabase(tableName: String){
//        items.removeAll()
//
//        let query = "select * from \(tableName)"
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
//            items.append(dbItem)
//        }
//        sqlite3_finalize(statement)
//    }

//    func insertIntoBasketTable(id: Int, name: String, subtitle: String, image: String, price: Float, description: String){
//        let insertQuery = "insert into BasketSchema (id, name, subtitle, image, price, description) values (?,?,?,?,?,?);"
//        print(insertQuery)
//        
//        var insertStmt: OpaquePointer? = nil
//        let execReturnCode = sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil)
//        print(insertQuery)
//        
//        if execReturnCode == SQLITE_OK {
//                        let id: Int = id
//                        let name: String = name
//                        let subtitle: String = subtitle
//                        let image: String = image
//                        let price: Float = price
//                        let description: String = description
//            
//                        sqlite3_bind_int(insertStmt, 1, Int32(id))
//                        sqlite3_bind_text(insertStmt, 2, name, -1, nil)
//                        sqlite3_bind_text(insertStmt, 3, subtitle, -1, nil)
//                        sqlite3_bind_text(insertStmt, 4, image, -1, nil)
//                        sqlite3_bind_double(insertStmt, 5, Double(price))
//                        sqlite3_bind_text(insertStmt, 6, description, -1, nil)
//            
//            if sqlite3_step(insertStmt) == SQLITE_DONE {
//                print("Successfully inserted row. \(execReturnCode)")
//            } else {
//                print("Could not insert row. \(execReturnCode)")
//            }
//        } else {
//            print("INSERT statement could not be prepared.")
//        }
//        sqlite3_finalize(insertStmt)
//    }
//}
