//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anand Agrawal on 10/03/18.
//  Copyright © 2018 Anand Agrawal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      loadCategories()
      
    }

    //MARK: - TableView Datasource Methods
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving data : \(error)")
        }
        
        tableView.reloadData()
       
    }
    
    func loadCategories (with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
           categories =  try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
     //MARK: - TableView Deligate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    //MARK:- Add new Category

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add new Category", message: nil, preferredStyle: .alert)
        alert.addTextField { (addedCategory) in
            addedCategory.placeholder = "Enter new Category"
            textField = addedCategory
        }
        
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
           let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
           self.saveCategories()
        }
   
        alert.addAction(action)
     
        present(alert, animated: true, completion: nil)
    
    }
    
    
   
}
