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

class MainListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var qtyInBasketButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var basketQty = 0
    var totalPrice: Float = 0.0
    var items = [MyItem]()
    
    var alert: UIAlertController? = nil
    
//        var db: OpaquePointer? = nil
    var dbInstance: DatabaseHelper?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get stored data
        getSavedData()
        
        // set labels
        qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
        totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
        
        if(basketQty == 0){
            qtyInBasketButton.isEnabled = false
        }else{
            qtyInBasketButton.isEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJsonFromUrl(url: "https://my.api.mockaroo.com/items.json?key=f2324050")
        
        dbInstance = DatabaseHelper.instance
        if dbInstance?.openDatabase() == SQLITE_OK {
            if dbInstance?.createTable(tableName: "BasketSchema") == SQLITE_OK {
                print("Database opened and table created")
            }
        }else{
            print("Database could not be opened.")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Items: \(items.count)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil{
            
            //check if table exists
            if dbInstance?.createTable(tableName: "BasketSchema") == SQLITE_OK {
                print("Database table created")
            } else {
            print("Database could not be opened.")
        }
            
            //save selected item to database
            if dbInstance?.insertIntoBasketTable(id: items[indexPath.row].id, name: items[indexPath.row].name, subtitle: items[indexPath.row].subtitle, image: items[indexPath.row].image, price: items[indexPath.row].price, description: items[indexPath.row].description) == SQLITE_OK{
                

                basketQty+=1
                totalPrice = totalPrice + items[indexPath.row].price
                
                qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
                totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
                
                if(basketQty == 0){
                    qtyInBasketButton.isEnabled = false
                }else{
                    qtyInBasketButton.isEnabled = true
                }
                
                updateSavedData(bQty: basketQty, tPrice: totalPrice)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ItemTableViewCell
        
        let localItem = items[indexPath.row]
//        let localImage = ["loading"]
        
        
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
                        cell.cellImageView?.image = UIImage(named: "loading")
                    }
                }
            }
        }
        return cell
    }
    
    func getSavedData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Basket")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                basketQty = data.value(forKey: "quantity") as! Int
                totalPrice = data.value(forKey: "price") as! Float
            }
        } catch {
            print("Could not fetch values from core data")
        }
    }
    
    func updateSavedData(bQty: Int, tPrice: Float){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Basket", in: managedContext)!
        
        let basket = NSManagedObject(entity: entity, insertInto: managedContext)
        
        basket.setValue(bQty, forKeyPath: "quantity")
        basket.setValue(tPrice, forKeyPath: "price")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func downloadJsonFromUrl(url: String){
        if !InternetConnection.isConnectedToNetwork(){
            showAlert(title: "Internet connection", message: "Could not connect to the internet to fetch data.", action: true);
        }else{
            print("Internet Connection Available!")
        }
        
        print("Begin downloading data")
        showAlert(title: "Initialising", message: "Fetching required data...", action: false)
        
        guard let downloadUrl  = URL(string: url) else {return}
        URLSession.shared.dataTask(with: downloadUrl) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error loading data from URL")
                self.showAlert(title: "Uh oh!", message: "Unfortunately, data could not be downloaded at this time.\nPlease try again.", action: true)
                return
            }
            print("Json downloaded successfully")
            do{
                let decoder = JSONDecoder()
                self.items = try decoder.decode([MyItem].self, from: data)
                print("Downloaded data size: \(self.items.count)")
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            } catch {
                print("Error after downloading data")
                self.showAlert(title: "Uh oh!", message: "Unfortunately, data could not be downloaded at this time.\nPlease try again", action: true)
            }
            }.resume()
        if(self.alert != nil){
            self.alert!.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String, action: Bool){
        alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        if(action){
            alert!.addAction(alertAction)
        }
        
        present(alert!, animated: true, completion: nil)
    }
}
