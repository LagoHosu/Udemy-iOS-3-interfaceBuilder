//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lago on 2021/03/01.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //need to review this line of code

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

     @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            //CRUD - Create
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveItems()
            
        }

        alert.addAction(action)
        
        alert.addTextField { (i) in
            
            textField = i
            i.placeholder = "Write down the name of category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
    
//        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    
    
    
    
    
    
    //MARK: - TableView Delegate Method
    //~trigger the segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
        
        //CRUD - Delete
        context.delete(categoryArray[indexPath.row])
        categoryArray.remove(at: indexPath.row)
        
        //CRUD - Update
        categoryArray[indexPath.row].setValue("Completed", forKey: "name")
        
         saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        //~as! = downcasing
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    
    
    //MARK: - Data Manipulation Method
    
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print(error)
        }
        tableView.reloadData()
    }
    
    //CRUD - Read
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("there is an error, which is \(error)")
        }
        tableView.reloadData()
        
    }
}
