//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Wang, Zewen on 2018-01-22.
//  Copyright © 2018 Wang, Zewen. All rights reserved.
//

import UIKit

import RealmSwift


class CategoryViewController: SwipeTableViewController{
    //var categoryList = [Category]() // an array of nsmanagement object
    var categories: Results<Category>? // updated automatically
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1 //nil coalescing operator. if it is not nil return count, nil return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)// go to super class
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category"
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    
    // MARK: - Realm Manipulation
    func saveCategory(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        categories = realm.objects(Category.self) // data type of objects is result
        //pull out all the items in category
        tableView.reloadData()
    }
    // Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
        }
        
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Categories", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
           //self.categoryList.append(newCategory)
            self.saveCategory(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
}

