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
    
    var items: [NSManagedObject] = []
    
//        var items = [(id: "54-2206271",name: "Jeep",subtitle: "Liberty",price: 14,image: "https://robohash.org/explicabocumquemolestiae.png?size=50x50&set=set1",description: "In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris."), (id: "23-5688258",name: "Mitsubishi",subtitle: "Precis",price: 57,image: "https://robohash.org/dolorevoluptatemtemporibus.png?size=50x50&set=set1",description: "Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus."), (id: "13-4647922",name: "Jeep",subtitle: "Commander",price: 17,image: "https://robohash.org/quaeetenim.png?size=50x50&set=set1",description: "In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi."), (id: "13-2920809",name: "Bentley",subtitle: "Continental GT",price: 6,image: "https://robohash.org/doloremaliquamprovident.png?size=50x50&set=set1",description: "Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl."), (id: "67-9720121",name: "Chevrolet",subtitle: "Express 1500",price: 8,image: "https://robohash.org/voluptatemfugiatsunt.png?size=50x50&set=set1",description: "Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet."), (id: "38-4056512",name: "Plymouth",subtitle: "Neon",price: 9,image: "https://robohash.org/magnamcorruptiadipisci.png?size=50x50&set=set1",description: "Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros."), (id: "40-7664045",name: "Volvo",subtitle: "S80",price: 4,image: "https://robohash.org/idharumautem.png?size=50x50&set=set1",description: "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.")]
    

    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Items in basket"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
//            print(items[indexPath.row].id)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketItem", for: indexPath) as! BasketItemTableViewCell
        
        let localItem = items[indexPath.row]
        let localImage = ["Apple", "Apricot", "Cantaloupe", "Banana", "Blueberry"]
        
        
        cell.basketItemId?.text = "\(localItem.value(forKeyPath: "id") as! Int? ?? 0)"
        cell.basketNameLabel?.text = (localItem.value(forKeyPath: "name") as! String)
        cell.basketSubLabel?.text = (localItem.value(forKeyPath: "subtitle" ) as! String)
        cell.basketQtyLabel?.text = "\(localItem.value(forKeyPath: "price") as! Int? ?? 0)"
        
        cell.basketImageView?.image  = UIImage(named: localImage[indexPath.row%5])

        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            items.remove(at: indexPath.row)
            
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .fade)
//            tableView.reloadData()
        } //else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
