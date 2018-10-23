//
//  CategoryTableViewController.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 18..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    //MARK: - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    
    //MARK: - Data manipulation methods
    func save(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving into realm: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete data model
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category: \(error)")
            }
        }
    }
    
    //MARK: - add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //have a popup with a textfield...
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if textField.text != ""{
                let newCategory = Category()//Category(context: self.context)
                newCategory.name = textField.text!
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let destinationVC = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
        
    }
   
}
