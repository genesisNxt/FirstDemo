//
//  ViewController.swift
//  FirstDemo
//
//  Created by PARMJIT SINGH KHATTRA on 26/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit
import  CoreData
class CountryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let constant = Constant()
    var country = [Country]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadCountry()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.countryCell, for: indexPath)
        cell.textLabel?.text = country[indexPath.row].countryName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //context.delete(country[indexPath.row])
        //country.remove(at: indexPath.row)
        performSegue(withIdentifier: constant.goToState, sender: self)
        //saveCountry()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StateTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCountry = country[indexPath.row]
        }
        
    }
    
    @IBAction func addCountry(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Country", message: "Country Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            let newCountry = Country(context: self.context)
            newCountry.countryName = textField.text
            newCountry.done = false
            self.country.append(newCountry)
            self.saveCountry()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "film name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveCountry() {
        do {
            try context.save()
        } catch {
            print("Error saving\(error)")
        }
        tableView.reloadData()
    }
    func loadCountry(with request: NSFetchRequest<Country> = Country.fetchRequest()){
        //let request: NSFetchRequest<Country> = Country.fetchRequest()
        do {
           country = try context.fetch(request)
        } catch  {
            print("Error Loading\(error)")
        }
        tableView.reloadData()
    }

}
 // MARK:- SearchBar Methods
extension CountryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Country> = Country.fetchRequest()
        let predicate = NSPredicate(format: "countryName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "countryName", ascending: true)]
        request.predicate = predicate
        loadCountry(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text?.count == 0 {
            loadCountry()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        }
    }
}
