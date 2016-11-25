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
            try setupDatabase ()
        } catch{
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask ,true).first!
        do{
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch{
            throw error
        }
    }
    
    private func createTable() throws{
        
        do{
            try db!.run(list.create(ifNotExists: true){
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(subject)
                t.column(checks)
            })
        } catch{
                throw error
        }
    }
    
    func create(todo: String) throws {
        let insert = list.insert(self.subject <- todo, self.checks <- 0)
        
        do {
            let rowId  = try db!.run(insert)
            print (rowId)
        } catch{  
            throw error
            
        }
    }
    
    func read (keyword:String) throws-> String? {
        var result: String?
        do{
            for list in try db!.prepare(list.filter(self.subject.like("%\(keyword)%"))){
                result = "id: \(list[id]), todo:\(list[subject]))]"
                print(result!)
            }
        } catch{
            throw error
        }
        return result
    }
    
    
    func readAll() throws-> [Todo]? {
        
        var results = [Todo]()
        
        do {
            for todoItem in try db!.prepare(list) {
                
                let todo = Todo()
                todo.id = todoItem[id]
                todo.title = todoItem[subject]!
                todo.checkend = 0
                
                results.append(todo)
            }
        } catch {
            throw error
        }
        
        return results
    }
    
    func delete(index: Int64) throws {
        let alice = list.filter(id == index)
        
        do {
            try db?.run(alice.delete())
            print("deleted succesfully")
        } catch {
            print("deleted failed!")
            throw error
        }
        
    }
    func update(index: Int64, state: Int64) throws {
        let list  = self.list.filter(id == index)
        do {
            try db!.run(list.update(self.checks <- state))
            print("updated succesfully")
        } catch {
            print("updated failed!")
            throw error
        }
    }
    
}





