//
//  ViewController.swift
//  toDo's
//
//  Created by Gaurav Gaikwad on 8/6/19.
//  Copyright © 2019 anuja. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UITableViewController {
    var  itemArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        
    
    
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items,plistitem")
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        loadItems()
    }
    // Do any additional setup after loading the view.
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func AddItems(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Items to List", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item ", style: .default) { (action) in
            
               let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newItem = Item(context: context)
            newItem.title = textfield.text!
            newItem.done = false
           newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            
            
            self.saveItems()
        }
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do{
            try context.save()
            
            
        }catch{
            print("error")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicaye = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicaye])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        
        
        
        
        do
        { itemArray = try context.fetch(request)
        }
        catch{
            print("error")
            
            
            
            
        }
        
    }
    
}

extension TodolistViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate =  predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do
        { itemArray = try context.fetch(request)
        }
        catch{
            print("error")
            
            
            
            
        }
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
}


