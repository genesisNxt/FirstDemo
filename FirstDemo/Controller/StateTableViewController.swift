//
//  StateTableViewController.swift
//  FirstDemo
//
//  Created by PARMJIT SINGH KHATTRA on 26/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
class StateTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var state = [State]()
    var selectedCountry : Country? {
        didSet {
            loadState()
        }
    }
    let constant = Constant()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadState()
        tableView.dataSource = self
        tableView.delegate = self
        print("Error Value \(selectedCountry)")
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
    @IBAction func addState(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "State", message: "state Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newState = State(context: self.context)
            newState.stateName = textField.text
            newState.done = false
            //newState.parentCountry = self.selectedCountry
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
    func loadState(with reqeust: NSFetchRequest<State> = State.fetchRequest()) {
        
//        if let additionalPredicate = predicate {
//            reqeust.predicate = additionalPredicate
//        }
        
        //let request: NSFetchRequest<State> = State.fetchRequest()
        do {
            state = try context.fetch(reqeust)
        } catch  {
            print("Error Loading\(error)")
        }
        tableView.reloadData()
    }
}
extension StateTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<State> = State.fetchRequest()
        let predicate = NSPredicate(format: "stateName CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "stateName", ascending: true)]
        loadState(with: request)
        
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
