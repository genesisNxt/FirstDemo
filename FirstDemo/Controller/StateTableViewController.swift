//
//  StateTableViewController.swift
//  FirstDemo
//
//  Created by PARMJIT SINGH KHATTRA on 26/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
class StateTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var selectedCountry : Country? {
        didSet {
            //print("hello")
            loadState()
        }
    }
    
    var state = [State]()
    let constant = Constant()
    
    @IBOutlet weak var tableView: UITableView!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //loadState()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.stateCell, for: indexPath)
        cell.textLabel?.text = state[indexPath.row].stateName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(state[indexPath.row])
        state.remove(at: indexPath.row)
        saveState()
    }
    @IBAction func addState(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "State", message: "state Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newState = State(context: self.context)
            newState.stateName = textField.text!
            newState.done = false
            newState.parentCountry = self.selectedCountry
            self.state.append(newState)
            self.saveState()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "new state"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveState(){
        do {
            try context.save()
        } catch  {
            print("Error Saving\(error)")
        }
        tableView.reloadData()
    }
    // MARK:- load State
    func loadState(with request: NSFetchRequest<State> = State.fetchRequest(), predicate: NSPredicate? = nil) {
        //let request: NSFetchRequest<State> = State.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCountry.countryName MATCHES[cd] %@", selectedCountry!.countryName!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            state = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        tableView.reloadData()
    }
}
// MARK:- SearchBar Delegate Methods
extension StateTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<State> = State.fetchRequest()
        let predicate = NSPredicate(format: "stateName CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "stateName", ascending: true)]
        loadState(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadState()
            DispatchQueue.main.async {
                self.tableView.resignFirstResponder()
            }
        }
    }
}
