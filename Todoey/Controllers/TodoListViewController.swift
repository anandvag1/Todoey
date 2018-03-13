//
//  ViewController.swift
//  Todoey
//
//  Created by Anand Agrawal on 01/03/18.
//  Copyright © 2018 Anand Agrawal. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    //var itemArray = [Item]()
    var todoItems : Results<Item>?
   
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    //MARK: - Table view deligate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)
                }
                } catch {
                    print("Error updating data \(error)")
                }
            }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        //      context.delete(todoItems[indexPath.row])
        //       todoItems.remove(at: indexPath.row)

        }
        
    
 
    //MARK: - Add new Todo list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController.init(title: "Add to Todo list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Todo", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error in Saving Data \(error)")
                }
            }
       
            self.tableView.reloadData()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion : nil)
    }
    
    //MARK: - Model Manupulation Method
    func saveItems(item : Item) {

    }
    
    func loadItems() {
        
       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            todoItems = try context.fetch(request)
//        } catch {
//            print("error in fetching the data \(error)")
//        }
        
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//       loadItems(with: request, predicate: predicate)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }

        }
    }
}



