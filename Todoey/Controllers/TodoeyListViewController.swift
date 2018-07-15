//
//  ViewController.swift
//  Todoey
//
//  Created by user140860 on 7/10/18.
//  Copyright © 2018 Vergel de Guzman. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeyListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>?

    @IBOutlet weak var searchbar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name

        if let colorHex = selectedCategory?.color {
            if let color = UIColor(hexString: colorHex) {
                updateNavigationBarColor(color: color)
                searchbar.barTintColor = color
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let originalColor = UIColor(red:0.11, green:0.61, blue:0.96, alpha:1.0)
        updateNavigationBarColor(color: originalColor)
    }
    
    func updateNavigationBarColor(color: UIColor) {
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Navigation bar does not exist")
        }
        let contrastColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat:true)
        navigationBar.barTintColor = color
        navigationBar.tintColor = contrastColor
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let colorHex = selectedCategory?.color {
                if let color = UIColor(hexString: colorHex), let itemCount = todoItems?.count {
                    cell.backgroundColor = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemCount))
                    cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat:true)
                }
            }
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done    
                }
            }
            catch {
                print("Error saving done status, \(error)")
            }
        }

        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                }
                catch {
                    print("Error saving item, \(error)")
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
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }
            catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}

extension TodoeyListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
                              .sorted(byKeyPath: "dataCreated", ascending: true)
        tableView.reloadData()

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
