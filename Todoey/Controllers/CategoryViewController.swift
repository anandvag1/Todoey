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
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         let category1 = Category(context: context)
//         category1.name = "Test123"
//        categoryArray.append(category1)
//        let category2 = Category(context: context)
//        category2.name = "Test321"
//        categoryArray.append(category2)
      
       loadCategoryData()
      
    }

    //MARK: - TableView Datasource Methods
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategoryData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving data : \(error)")
        }
        
        tableView.reloadData()
       
    }
    
    func loadCategoryData (with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
           categoryArray =  try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:- Add new Categorries

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
            self.categoryArray.append(newCategory)
           self.saveCategoryData()
        }
   
        alert.addAction(action)
     
        present(alert, animated: true, completion: nil)
    
    }
    
    
    //MARK: - TableView Deligate Methods
}
