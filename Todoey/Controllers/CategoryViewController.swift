//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anand Agrawal on 10/03/18.
//  Copyright © 2018 Anand Agrawal. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //var categories = [Category]()
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext -- used for Core Data
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      loadCategories()
      
    }

    //MARK: - TableView Datasource Methods
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories created yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(category : Category) {
        
        do {
           // try context.save()  -- in case of Core Data
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data : \(error)")
        }
        
        tableView.reloadData()
       
    }
    
    func loadCategories () {
        
        categories = realm.objects(Category.self)
        
     //    request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//           categories =  try context.fetch(request)
//        } catch {
//            print("Error fetching data \(error)")
//        }
        tableView.reloadData()
    }
    
     //MARK: - TableView Deligate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
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
           //let newCategory = Category(context: self.context) -- used in case of Core Date
            let newCategory = Category()
            newCategory.name = textField.text!
        //    self.categories.append(newCategory)
           self.saveCategories(category: newCategory)
        }
   
        alert.addAction(action)
     
        present(alert, animated: true, completion: nil)
    
    }
    
    
   
}
