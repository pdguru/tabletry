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
    static let instance = DatabaseHelper()
    var db: OpaquePointer? = nil
    
    private init(){
        self.db=nil
    }
    
    func openDatabase() -> Int32{
        
        do{
            let dbDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = dbDir.appendingPathComponent("purchases").appendingPathExtension("sqlite")
            print("Database path: \(fileUrl.path)")
            
            //open database
            let execReturnCode = sqlite3_open(fileUrl.path, &db)
            if execReturnCode == SQLITE_OK{
                print("Database opened: \(execReturnCode)")
                return execReturnCode
            } else {
                print("Error opening database \(execReturnCode)")
                return execReturnCode
            }
        } catch {
            print("error locating database")
            return SQLITE_FAIL
        }
    }
    
    func createTable(tableName: String) -> Int32{
        //create tables
        var createStmtPointer: OpaquePointer? = nil
        let createStmt = "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT NOT NULL , name TEXT, subtitle TEXT, image TEXT, price NUMERIC, description TEXT);"
        let execReturnCode = sqlite3_exec(db, createStmt, nil, &createStmtPointer, nil)
        if  execReturnCode == SQLITE_OK{
            print("\(tableName) table in database created/exists")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating \(tableName) table: \(errmsg)")
        }
        
        sqlite3_finalize(createStmtPointer)
        return execReturnCode
    }
    
    func insertIntoBasketTable(id: Int, name: String, subtitle: String, image: String, price: Float, description: String) -> Int32 {
        let insertQuery = "insert into BasketSchema (id, name, subtitle, image, price, description) values (?,?,?,?,?,?);"
        
        print("inserting \(name) + \(subtitle)")
        
        var insertStmt: OpaquePointer? = nil
        let execReturnCode = sqlite3_prepare_v2(db, insertQuery, -1, &insertStmt, nil)
        
        if execReturnCode == SQLITE_OK {
            let id: Int = id
            let name: String = name
            let subtitle: String = subtitle
            let image: String = image
            let price: Float = price
            let description: String = description
            
            if sqlite3_bind_int(insertStmt, 1, Int32(id)) != SQLITE_OK { print("Binding ID failed") }
            if sqlite3_bind_text(insertStmt, 2, name, -1, nil) != SQLITE_OK { print("Binding NAME failed") }
            if sqlite3_bind_text(insertStmt, 3, subtitle, -1, nil) != SQLITE_OK { print("Binding SUBTITLE failed") }
            if sqlite3_bind_text(insertStmt, 4, image, -1, nil) != SQLITE_OK { print("Binding IMAGE failed") }
            if sqlite3_bind_double(insertStmt, 5, Double(price)) != SQLITE_OK { print("Binding PRICE failed") }
            if sqlite3_bind_text(insertStmt, 6, description, -1, nil) != SQLITE_OK { print("Binding DESCRIPTION failed") }
            
//            print("Exec query: \(insertQuery)")
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted row. \(execReturnCode)")
            } else {
                print("Could not insert row. \(execReturnCode)")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStmt)
        return execReturnCode
    }
    
    func deleteDatabaseTable(tableName: String, id: Int) -> Int32{
        var deleteStatementStirng: String
        var successMessage: String
        var errorMessage: String
        
        if id == -1 {
            deleteStatementStirng = "drop table \(tableName);"
            successMessage = "Table \"\(tableName)\" dropped."
            errorMessage = "Error dropping table."
        } else {
            deleteStatementStirng = "DELETE FROM \(tableName) WHERE id = \(id);"
            successMessage = "Row deleted in \"\(tableName)\"."
            errorMessage = "Error deleting row."
        }
        
        var deleteStatement: OpaquePointer? = nil
        let execReturnCode = sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil)
        if  execReturnCode == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print(successMessage)
            } else {
                print(errorMessage)
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
        return execReturnCode
    }
    
    func readDatabase(_ tableName: String) -> [MyItem]?{
        var itemsInBasket: [MyItem] = []
        
        let query = "select * from \(tableName)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            print("Reading from database")
            print("\(query)")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing reading: \(errmsg)")
            return nil
        }
        
        //parsing read data
        print("Sql Read result: \(sqlite3_step(statement))")
        var counter = 0
        
        repeat{
            counter+=1
            print("Counter in loop \(counter)")
            
            let id = sqlite3_column_int(statement, 0)
            let name = String(cString: sqlite3_column_text(statement, 1))
            let subtitle = String(cString: sqlite3_column_text(statement, 2))
            let image = String(cString: sqlite3_column_text(statement, 3))
            let price = String(cString: sqlite3_column_text(statement, 4))
            let description1 = String(cString: sqlite3_column_text(statement, 5))
            
            let dbItem = MyItem(id: Int(id), name: String(describing: name), subtitle: String(describing: subtitle), image: String(describing: image), price: (String(describing: price) as NSString).floatValue, description: String(describing: description1))
            
            itemsInBasket.append(dbItem)
        }while(sqlite3_step(statement) == SQLITE_ROW);
        
        sqlite3_finalize(statement)
        return itemsInBasket
    }
}
