//
//  ViewController.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 15..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            loadItems(predicate: categoryPredicate)
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadItems()

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //value = condition ? value_if_true : value_if_not_true
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        // selection disappear...
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        // this order has to be kept!!!
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //have a popup with a textfield...
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if textField.text != ""{
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveData()
                
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData() {
       
        do{
            try context.save()
        }catch{
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        //check whether file is av?
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        do {
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching the data \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
//MARK: - SearchBar methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //triggered when SB text changed and user hit cancel..
        if searchBar.text?.count == 0{ //if the text is empty...
            //load the items again
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            loadItems(predicate: categoryPredicate)
            //async way dismiss the keyboard...
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //set the request and fetch from Items
        if searchBar.text?.count != 0{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            //generate the predicate, aka search string
            //update the request with the predicate
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            //sort the request based on the title
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            //let's get the data :)

            loadItems(with: request,predicate: request.predicate!)
            tableView.reloadData()
        }else{
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            loadItems(predicate: categoryPredicate)
        }
    }
}

