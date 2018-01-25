//
//  ViewController.swift
//  ToDoey
//
//  Created by Wang, Zewen on 2018-01-18.
//  Copyright © 2018 Wang, Zewen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category?{
        didSet{
          loadItems() // when selectedCategory gets set a value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        // Navigation controller bar could not be stacked with ToDoList Controller
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) { //will be called later after viewdidload and before users see on the screen
        title = selectedCategory?.name // this is not within if let, for safer, use ? to replace !
        guard let color = selectedCategory?.color else { fatalError()}
        updateNavBar(withHexCode: color)
        
            //because if navigationcontroller is nil, this code will not work : so use if let to replace this code navigationController?.navigationBar.barTintColor = UIColor(hexString:color)
       
             // NEXT STEP: change if let to guard let.
        
    }
    
    // MARK: - View will disapper
    
    override func viewWillDisappear(_ animated: Bool) {
//        guard let originalColor = UIColor(hexString: "1D9BF6") else{fatalError()}
//        navigationController?.navigationBar.barTintColor = originalColor
//        navigationController?.navigationBar.tintColor = FlatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        guard let navBarColor = UIColor(hexString:colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = UIColor(hexString:colorHexCode)
    }
    
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){ // if the color is nil, trying to darken it will be crashed: optinal chaining
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
            }
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No item added"
        }
        
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    
    
    
    // MARK : TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print("ZZZZZZZ\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Mark : remove from CoreData
//        context.delete(itemArray[indexPath.row])
//        // remove data from permanent storage
//        itemArray.remove(at: indexPath.row)
//        // this only changes the UI, does nothing to the Coredata
//
        //Mark: remove data from realm
//        if let item = todoItems?[indexPath.row]{
//            do{
//                try realm.write {
//                    realm.delete(item)
//                }
//            }
//            catch{
//                print("ZZZZZZZ\(error)")
//            }
//        }
//
        
    }
    // MARK : Add button for new items
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
    }
    func loadItems(){ // if request is null, then set it to the default value, witch is item.fetchrequest()
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let c = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(c)
                }
            }catch{
                print(error)
            }
        }
    }
    
    
}
// MARK : extension, searchbar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
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


