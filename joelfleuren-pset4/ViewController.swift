//
//  ViewController.swift
//  joelfleuren-pset4
//
//  Created by joel fleuren on 21-11-16.
//  Copyright © 2016 joel fleuren. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var new: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [Todo]()
    
    private let db = DatabaseHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        if db == nil{
            print("Error")
        }
        
        updateUI()
    }
    
    func updateUI() {
        
        do {
            // read all the information in the database
            todos = try db!.readAll()!
        }catch let error as NSError {
            print(error.userInfo)
        }
        // set Ui on diffrent treat
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func createButton(_ sender: Any) {
        do{
            try db!.create(todo: new.text!)
            updateUI()
        } catch{
            print (error)
        }
        
    }
    @IBAction func create (_sender: Any){
        do{
            // set the new todo item in the database
            try db!.create(todo: new.text!)
            updateUI()
        } catch{
            print (error)
        }
    }
    
    // database
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        // check if there should be a checks on or of
        if todos[indexPath.row].checkend == 0 {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    private func updateRowState(index: Int) {
        
        let id = todos[index].id
        
        do {
            // update if there is a check on or of in the database
            try db?.update(index: id!, state: todos[index].checkend)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    // delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            // set the check of if the row is clicked
            if todos[indexPath.row].checkend == 1 {
                
                cell.accessoryType = .none
                todos[indexPath.row].checkend = 0
                
            } else {
                // set the check oon if the row is clicked
                cell.accessoryType = .checkmark
                todos[indexPath.row].checkend = 1
            }
            
            updateRowState(index: indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, index) in
            
            // delete the row from the database
            do {
                try self.db?.delete(index: self.todos[index.row].id)
            } catch let error as NSError {
                print(error.userInfo)
            }
            
            // delete the array
            self.todos.remove(at: index.row)
            
            // delete the tablerow
            tableView.deleteRows(at: [index], with: .automatic)
            
        }
        
        return [deleteAction]
    }
}




