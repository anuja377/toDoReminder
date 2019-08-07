//
//  CatgeoryTableViewController.swift
//  toDo's
//
//  Created by Gaurav Gaikwad on 8/6/19.
//  Copyright © 2019 anuja. All rights reserved.
//

import UIKit
import CoreData

class CatgoryTableViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        
        return cell
        
    }
    
    // tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dstinationVC = segue.destination as! TodolistViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            dstinationVC.selectedCategory = categories[indexpath.row]
        }
        
    }
    

    
    func saveCategories(){
        do {
            try context.save()
            
        }
        catch{
            print("error")
            
            
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    
    
    
    
    
    // add new categories
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        var textspace = UITextField()
        let alert = UIAlertController(title: "Add Categories ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textspace.text
            self.categories.append(newCategory)
            self.saveCategories()
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textspace = field
            textspace.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

