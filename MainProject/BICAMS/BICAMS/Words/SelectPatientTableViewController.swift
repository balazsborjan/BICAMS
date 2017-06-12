//
//  SelectPatientTableViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 13..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData

class SelectPatientTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var fetchedResultsController: NSFetchedResultsController<Patient>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Beteg keresése"
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.clearsSelectionOnViewWillAppear = true
        
        fetchPatients()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchController.isActive = false
    }
    
    func fetchPatients() {
        
        let patientRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
        let patientFirstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        let patientLastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        
        patientRequest.sortDescriptors = [patientFirstNameSortDescriptor, patientLastNameSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: patientRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try? fetchedResultsController?.performFetch()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPatientCell", for: indexPath)
        
        if let selectPatientCell = (cell as? SelectPatientTableViewCell) {
            
            let firstName = fetchedResultsController?.fetchedObjects?[indexPath.row].firstName
            let lastName = fetchedResultsController?.fetchedObjects?[indexPath.row].lastName
            
            selectPatientCell.nameLabel.text = "\(firstName!) \(lastName!)"
            selectPatientCell.tajLabel.text = "Taj: " + (fetchedResultsController?.fetchedObjects?[indexPath.row].taj)!
            
            return selectPatientCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        patient = fetchedResultsController?.fetchedObjects?[indexPath.row]
        
        searchController.isActive = false
        
        let segue = UIStoryboardSegue.init(
            identifier: "selectPatientSegue",
            source: self,
            destination: (self.storyboard?.instantiateViewController(withIdentifier: "operationVC"))!
        )
        
        self.performSegue(withIdentifier: segue.identifier!, sender: nil)
    }
}

extension SelectPatientTableViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        updateSearchResults(for: self.searchController)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        updateSearchResults(for: self.searchController)
        searchBar.endEditing(true)
    }
}

extension SelectPatientTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        
        if searchText != nil {
            
            if searchText == "" {
                
                fetchedResultsController?.fetchRequest.predicate = nil
                
            } else {
                
                let firstNamePredicate = NSPredicate(format: "firstName contains[c] %@ ", searchText!)
                let lastNamePredicate = NSPredicate(format: "lastName contains[c] %@ ", searchText!)
                let tajPredicate = NSPredicate(format: "taj contains[c] %@", searchText!)
                
                let finalPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstNamePredicate, lastNamePredicate, tajPredicate])
                
                fetchedResultsController?.fetchRequest.predicate = finalPredicate
            }
            
            do {
                
                try fetchedResultsController?.performFetch()
                tableView.reloadData()
                
            } catch {
                print("FetchedResultsController cannot execute performFetch()!")
                return
            }
        }
    }
}











