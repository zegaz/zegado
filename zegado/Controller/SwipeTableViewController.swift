//
//  SwipeTableViewController.swift
//  zegado
//
//  Created by Géza Varga on 2018. 10. 23..
//  Copyright © 2018. Géza Varga. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!SwipeTableViewCell
            cell.delegate = self
        
//        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        //value = condition ? value_if_true : value_if_not_true
        //cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

   
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
//            print("delete cell")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        //update the data model
    }

}

