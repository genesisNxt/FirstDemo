//
//  StateTableViewController.swift
//  FirstDemo
//
//  Created by PARMJIT SINGH KHATTRA on 26/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import CoreData
class StateTableViewController: UITableViewController {

    var state = [State]()
    let constant = Constant()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadState()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func loadState() {
        let request: NSFetchRequest<State> = State.fetchRequest()
        do {
            state = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
    }
}
