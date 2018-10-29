//
//  DatabaseHelper.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 29/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import Foundation
import SQLite3

class DatabaseHelper{
    
    /*fileprivate let dbPointer: OpaquePointer?
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    func setupDatabase(){
        let database = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("PurchaseDB.sqlite")
        
        //open database
        if sqlite3_open(database.path, dbPointer) == SQLITE_OK{
            print("Database opened")
            print("\(database.path)")
        } else {
            print("Error opening database")
        }
    }
    func createItemTable(){
        //create tables
        var createStmtPointer: OpaquePointer? = nil
        let createStmt = "CREATE TABLE IF NOT EXISTS ItemSchema (id TEXT NOT NULL UNIQUE, name TEXT, subtitle TEXT, image TEXT, price NUMERIC, description TEXT, PRIMARY KEY( id ));"
        if sqlite3_exec(db, createStmt, nil, &createStmtPointer, nil) == SQLITE_OK{
            print("Item table in database created/exists")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error creating item table: \(errmsg)")
        }
        
        sqlite3_finalize(createStmtPointer)
    }
    
    func createBasketTable(){
        var createStmtPointer: OpaquePointer? = nil
        let createStmt = "CREATE TABLE IF NOT EXISTS BucketSchema (id TEXT NOT NULL UNIQUE, name TEXT, subtitle TEXT, image TEXT, price NUMERIC, description TEXT, PRIMARY KEY( id ));"
        if sqlite3_exec(dbPointer, createStmt, nil, &createStmtPointer, nil) == SQLITE_OK{
            print("basket table in database created/exists")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error creating bucket table: \(errmsg)")
        }
        
        sqlite3_finalize(createStmtPointer)
    }
    
    func readDatabase(tableName: String){
        items.removeAll()
        
        let query = "select * from \(tableName)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(dbPointer, query, -1, &statement, nil) == SQLITE_OK{
            print("Reading from database")
            print("\(query)")
        }else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
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
            
            print("ID: \(id) Name: \(name) Subtitle: \(subtitle) Price: \(price) Image: \(image) Description: \(description1)")
            
            //adding values to list
            items.append(dbItem)
        }
        sqlite3_finalize(statement)
    }
    
    func insertDatabase(){
        let insertQuery = "Insert into BucketSchema (id, name, subtitle, image, price, description) values (?,?,?,?,?,?);"
        
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(dbPointer, insertQuery, -1, &insertStmt, nil) == SQLITE_OK {
            let id: Int32 = 21
            let name: NSString = "Hyundai"
            let subtitle: String = "i20"
            let image: String = "https://robohash.org/innonsuscipit.bmp?size=50x50&set=set1"
            let price: Float = 1.12
            let description: String = "Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis."
            
            sqlite3_bind_int(insertStmt, 1, id)
            sqlite3_bind_text(insertStmt, 2, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, subtitle, -1, nil)
            sqlite3_bind_text(insertStmt, 4, image, -1, nil)
            sqlite3_bind_double(insertStmt, 5, Double(price))
            sqlite3_bind_text(insertStmt, 6, description, -1, nil)
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStmt)
    }
    
    func deleteDatabaseTable(){
        let deleteStatementStirng = "DELETE FROM ItemSchema WHERE Id = 21;"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(dbPointer, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }*/
}
