//
//  ViewController.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 19/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import UIKit
import CoreData

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
    
//    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var basketQty = 0
    var totalPrice: Float = 0.0
    var basket: [NSManagedObject] = []
    
    var items: [MyItem] = [MyItem(id:1,name:"Ford",subtitle:"E-Series",image:"https://robohash.org/quisquamquiqui.jpg?size=50x50&set=set1",price:4.74,description:"Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh."),
                           MyItem(id:2,name:"Maserati",subtitle:"GranTurismo",image:"https://robohash.org/evenietadipisciblanditiis.bmp?size=50x50&set=set1",price:3.72,description:"In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi."),
                           MyItem(id:3,name:"Volvo",subtitle:"850",image:"https://robohash.org/itaquetemporibusaut.png?size=50x50&set=set1",price:3.26,description:"Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus."),
                           MyItem(id:4,name:"Acura",subtitle:"RL",image:"https://robohash.org/omnisabipsa.jpg?size=50x50&set=set1",price:4.77,description:"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus."),
                           MyItem(id:5,name:"Buick",subtitle:"Electra",image:"https://robohash.org/expeditadeseruntpraesentium.jpg?size=50x50&set=set1",price:3.58,description:"Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui."),
                           MyItem(id:6,name:"Porsche",subtitle:"911",image:"https://robohash.org/recusandaevoluptatemsequi.png?size=50x50&set=set1",price:3.03,description:"Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus."),
                           MyItem(id:7,name:"Volkswagen",subtitle:"Jetta",image:"https://robohash.org/autemvelitqui.png?size=50x50&set=set1",price:3.54,description:"Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."),
                           MyItem(id:8,name:"Audi",subtitle:"5000CS",image:"https://robohash.org/cupiditateestid.png?size=50x50&set=set1",price:4.99,description:"Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus."),
                           MyItem(id:9,name:"Pontiac",subtitle:"Grand Prix",image:"https://robohash.org/nonvoluptatumcorporis.png?size=50x50&set=set1",price:4.71,description:"Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem."),
                           MyItem(id:10,name:"Lexus",subtitle:"IS",image:"https://robohash.org/estpossimusquasi.bmp?size=50x50&set=set1",price:3.06,description:"Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus."),
                           MyItem(id:11,name:"Toyota",subtitle:"Tacoma",image:"https://robohash.org/sedsintsequi.bmp?size=50x50&set=set1",price:3.20,description:"Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est."),
                           MyItem(id:12,name:"Buick",subtitle:"LeSabre",image:"https://robohash.org/doloremquequisquamaccusamus.jpg?size=50x50&set=set1",price:4.93,description:"In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus."),
                           MyItem(id:13,name:"Subaru",subtitle:"Loyale",image:"https://robohash.org/magnamautemanimi.png?size=50x50&set=set1",price:3.11,description:"Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio."),
                           MyItem(id:14,name:"Honda",subtitle:"Accord Crosstour",image:"https://robohash.org/maximequododit.jpg?size=50x50&set=set1",price:4.45,description:"Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui."),
                           MyItem(id:15,name:"Jeep",subtitle:"Wrangler",image:"https://robohash.org/saepealiquidminus.png?size=50x50&set=set1",price:3.26,description:"Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem."),
                           MyItem(id:16,name:"Ford",subtitle:"Tempo",image:"https://robohash.org/quianesciuntodio.bmp?size=50x50&set=set1",price:3.38,description:"Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus."),
                           MyItem(id:17,name:"Audi",subtitle:"S6",image:"https://robohash.org/voluptatequamipsam.png?size=50x50&set=set1",price:4.01,description:"Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem."),
                           MyItem(id:18,name:"Acura",subtitle:"NSX",image:"https://robohash.org/natusautvoluptatem.bmp?size=50x50&set=set1",price:3.92,description:"Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est."),
                           MyItem(id:19,name:"Kia",subtitle:"Spectra",image:"https://robohash.org/nullablanditiisid.jpg?size=50x50&set=set1",price:4.7,description:"Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem."),
                           MyItem(id:20,name:"Pontiac",subtitle:"Sunfire",image:"https://robohash.org/omnisquifacere.bmp?size=50x50&set=set1",price:3.62,description:"Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum."),]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        do {
            basket = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        basketQty = basket.count
        qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil{
            
            addToBasket(basketItem: items[indexPath.row])
            
            basketQty+=1
            totalPrice = totalPrice + items[indexPath.row].price
            
            qtyInBasketButton.setTitle("Basket: \(basketQty)", for: .normal)
            totalPriceLabel.text = String(format: "Total: £ %.2f", totalPrice)
            
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
        detailVC.detailImage = "Apple"

        self.navigationController?.pushViewController(detailVC, animated: true)
        
        print("passed name: \(items[indexPath.row].name) subtitle: \(items[indexPath.row].subtitle)")
        
    }
    
    func addToBasket(basketItem: MyItem){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        
        let sItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        sItem.setValue(basketItem.id, forKeyPath: "id")
        sItem.setValue(basketItem.name, forKeyPath: "name")
        sItem.setValue(basketItem.subtitle, forKeyPath: "subtitle")
        sItem.setValue(basketItem.price, forKeyPath: "price")
        sItem.setValue(basketItem.image, forKeyPath: "image")
        sItem.setValue(basketItem.description, forKeyPath: "desc")
        print("sItem: Name: \(basketItem.name) + Subtitle: \(basketItem.subtitle)")
        
        do {
            try managedContext.save()
            basket.append(sItem)
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
        
        
        //        let url = URL(string: localItem.image)
        //
        //        DispatchQueue.global().async {
        //            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        //            DispatchQueue.main.async {
        //                cell.cellImageView?.image = UIImage(data: data!)
        //            }
        //        }
        return cell
    }
}

