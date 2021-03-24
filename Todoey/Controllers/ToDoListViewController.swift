//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreData
import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var selectedCategory : Category? {
        //~as soon as the category gets value, the code inside didSet will be done
        didSet {
            loadItems()
        }
    }
    
    
    
    // ~~> call the method in AppDelegate.swift, ==permenant storage
    //~ this makes the app be able to CRUD
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // ~through defaults, we can save the data each of the user's plist file
    //var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //where the data file(SQLite) is saved
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        //retrieve the item out of itemArray
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
        loadItems()
    }
    //MARK: - tableView Datasource Methods
    
    //to know more about the tableView details, you should review the chat app on lesson15
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //this is printed as much as the nunmber of arrays, because tableView is reloaded for every rows as we click one cell
        //print("cellForRowAtIndexpath called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        
        //by using ternary operator, e can make the code below much shorter
        /*ternary operator format
                      value = condition ? valueIfTrue : valueIfFalse*/
        cell.accessoryType = item.done == true ? .checkmark : .none
        /*if item.done == true {
         cell.accessoryType = .checkmark
         } else {
         cell.accessoryType = .none
         }
         */
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    
    //when the cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //CRUD - Delete
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        //CRUD - Update
        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //make the checkmark as once clicked, and remove when the cell  clicked again
        //can't find why the error comes up with the code below even if this line of code is same as the if statement below :(
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
        //the bool of current item which is selected is changed
        
        saveItems()
        //tableView.reloadData()
        
        //to make the cell original color after click
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //alert tap appears
        let alert = UIAlertController(title: "Add new item!", message: "", preferredStyle: .alert)
        //the button on the alert tap
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen as we press the add button
            
            //CRUD - Create
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
        }
        
        //texted one adds into the Alert
        alert.addTextField { (i) in
            i.placeholder = "Write down the new item"
            //self.itemArray.append(alertTextField.text!)
            //print(alertTextField.text!)
            
            //alertTextField expands as UITextField
            textField = i
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - model manipulation methods
    
    func saveItems() {
        //~the latest itemArray gets as a default by connecting TodoListArray
        //~append the data of the plist file
        //~persisted data
        //self.defaults.set(self.itemArray, forKey: "TodoListArray")
        //let encoder = PropertyListEncoder()
        
        
        //~in the dataFilePath, itemArray is written and file is made
        //~besides the UserDefault.plist, Items.plist is able to save the custom item objecvts(due to the encoder)
        //        do {
        //            let data = try encoder.encode(itemArray)
        //            try data.write(to: dataFilePath!)
        //        } catch {
        //            print(error)
        //        }
        
        do {
            try context.save()
        } catch  {
            print(error)
        }
        tableView.reloadData()
        
    }
    
    //~this part is about encoding and decoding
    //    func loadItems() {
    //        if let data = try? Data(contentsOf: dataFilePath!) {
    //            let decoder = PropertyListDecoder()
    //            do {
    //                itemArray = try decoder.decode([Item].self, from: data)
    //            } catch {
    //                print(error)
    //            }
    //        }
    //    }
    
    //CRUD - Read
    //this function has external, internal parameter and default value
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        //~ this if statement is same as below
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("there is an error, which is \(error)")
        }
        tableView.reloadData()
        
    }
    
    /*
     Try ->  Requires a do-catch clause. Do-catch will provide a detailed error message if an error occurs.
     Try? -> Does not use a do-catch and only gives nil if there is an error.
     Try! -> Does not use a do-catch. Developer is confident that an error will not occur.
     */
    
}
//MARK: - Search Bar Delegate

extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //to get back the data which the user is looking for
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //~ fielter added to query the data
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //~[cd] means it is careless if the text filtered by case or 표시
        
        //to sort the data we requested as alphabetical order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
    
    //when the text in searchbar is changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //go back to the original page(show all content)
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
    
}
