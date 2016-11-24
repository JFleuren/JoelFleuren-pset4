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
            todos = try db!.readAll()!
        }catch let error as NSError {
            print(error.userInfo)
        }
        
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
            try db!.create(todo: new.text!)
            updateUI()
        } catch{
            print (error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(todos[indexPath.row].id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, index) in
            
            // Database verwijderen
            do {
                try self.db?.delete(index: self.todos[index.row].id)
            } catch let error as NSError {
                print(error.userInfo)
            }
            
            // Array verwijderen
            self.todos.remove(at: index.row)
            
            // Tablerow verwijderen
            tableView.deleteRows(at: [index], with: .automatic)
            
        }
        
        return [deleteAction]
    }
}



