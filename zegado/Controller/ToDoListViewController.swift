//
//  ViewController.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 15..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        
        
        
        loadItems()
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
//            print(itemArray)
//        }

        
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
                let newItem = Item()
                newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray) //set the dataflow
            try data.write(to: dataFilePath!) //write to the file
        }catch{
            print("Error encoding array \(error)!")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        //check whether file is av?
        if let data = try? Data(contentsOf: dataFilePath!){
            //get the decoder initialized
            let decoder = PropertyListDecoder()
            do{
                //try to set the data from plist...
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Can not retrieve data with error: \(error)")
            }
            
        }
    }
    
}

