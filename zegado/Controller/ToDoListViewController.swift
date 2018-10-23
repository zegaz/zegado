//
//  ViewController.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 15..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{

            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadItems()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            //value = condition ? value_if_true : value_if_not_true
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status into realm: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //have a popup with a textfield...
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if textField.text != ""{
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                            
                    }
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
  
    
    func loadItems() {
        //check whether file is av?
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Can not remove item: \(error)")
            }
        }
    }
    
    
}
//MARK: - SearchBar methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        //triggered when SB text changed and user hit cancel..
        if searchBar.text?.count == 0{ //if the text is empty...
            loadItems()
            //async way dismiss the keyboard...
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //set the request and fetch from Items
        
        
//            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
    }
}

