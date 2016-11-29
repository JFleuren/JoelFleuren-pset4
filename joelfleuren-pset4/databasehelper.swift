//
//  databasehelper.swif.swift
//  joelfleuren-pset4
//
//  Created by joel fleuren on 22-11-16.
//  Copyright © 2016 joel fleuren. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    private let list = Table("list")
    
    private let id = Expression<Int64>("id")
    private let subject = Expression<String?>("subject")
    private let checks = Expression<Int64> ("checks")
    
    private var db: Connection?
    
    init?(){
        do{
            // setup the database
            try setupDatabase ()
        } catch{
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws{
        // set the path to the database
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask ,true).first!
        do{
            // db is the path to the database
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch{
            throw error
        }
    }
    
    private func createTable() throws{
        
        do{
            // create a sql table
            try db!.run(list.create(ifNotExists: true){
                t in
                // create the collums
                t.column(id, primaryKey: .autoincrement)
                t.column(subject)
                t.column(checks)
            })
        } catch{
                throw error
        }
    }
    // make a create function
    func create(todo: String) throws {
        // insert the subject and the cheks in the database
        let insert = list.insert(self.subject <- todo, self.checks <- 0)
        
        do {
            let rowId  = try db!.run(insert)
            print (rowId)
        } catch{  
            throw error
            
        }
    }
    // read the table
    func read (keyword:String) throws-> String? {
        var result: String?
        do{
            // read the items in the list
            for list in try db!.prepare(list.filter(self.subject.like("%\(keyword)%"))){
                result = "id: \(list[id]), todo:\(list[subject]))]"
                print(result!)
            }
        } catch{
            throw error
        }
        return result
    }
    
    // read all the information in the database
    func readAll() throws-> [Todo]? {
        
        var results = [Todo]()
        
        do {
            for todoItem in try db!.prepare(list) {
                
                let todo = Todo()
                todo.id = todoItem[id]
                todo.title = todoItem[subject]!
                todo.checkend = todoItem[checks]
                print(todoItem[checks])
                
                results.append(todo)
            }
        } catch {
            throw error
        }
        
        return results
    }
    // delete an item in the database
    func delete(index: Int64) throws {
        // make sure that is the correct row that is deleted
        let alice = list.filter(id == index)
        
        do {
            // delete the row
            try db?.run(alice.delete())
            print("deleted succesfully")
        } catch {
            print("deleted failed!")
            throw error
        }
        
    }
    // update changes in the database
    func update(index: Int64, state: Int64) throws {
        // update the correct row
        let list  = self.list.filter(id == index)
        do {
            // update the row
            try db!.run(list.update(checks <- state))
            print("updated succesfully")
        } catch {
            print("updated failed!")
            throw error
        }
    }
    
}





