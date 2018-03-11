//
//  ViewController.swift
//  Todoey
//
//  Created by Anand Agrawal on 01/03/18.
//  Copyright © 2018 Anand Agrawal. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

   var itemArray = [Item]()
 
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       loadItems()
    
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        
        
        
        return cell
    }

    //MARK: - Table view deligate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
      
//       
//      context.delete(itemArray[indexPath.row])
//       itemArray.remove(at: indexPath.row)
        
     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()
     
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    //MARK: - Add new Todo list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController.init(title: "Add to Todo list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Todo", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion : nil)
    }
    
    //MARK: - Model Manupulation Method
    func saveItems() {
        
        
        do {
            try context.save()
        } catch {
            print("Error in Saving Data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item>  = Item.fetchRequest()) {

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error in fetching the data \(error)")
        }
         tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       loadItems(with: request)
        
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



