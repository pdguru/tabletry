//
//  BasketTableViewController.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 23/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import UIKit
import CoreData

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
    
    
    var itemsInBasket: [NSManagedObject] = []

    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Items in basket"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            itemsInBasket = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        
        cell.basketItemId?.text = "\(localItem.value(forKeyPath: "id") as! Int? ?? 0)"
        cell.basketNameLabel?.text = (localItem.value(forKeyPath: "name") as! String)
        cell.basketSubLabel?.text = (localItem.value(forKeyPath: "subtitle" ) as! String)
        cell.basketQtyLabel?.text = "\(localItem.value(forKeyPath: "price") as! Float? ?? 0)"
        
        cell.basketImageView?.image  = UIImage(named: localImage[indexPath.row%5])

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let itemToDelete = itemsInBasket[indexPath.row]
            context.delete(itemToDelete)
            
            let indexPaths = [indexPath]
//            tableView.deleteRows(at: indexPaths, with: .fade)
            appDelegate.saveContext()
//            tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func clearBasket(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Items in basket", message: "Are you sure to empty your basket?" , preferredStyle: .alert)
        
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
        print("Basket is empty")
    }

}
