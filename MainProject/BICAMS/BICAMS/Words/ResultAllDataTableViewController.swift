//
//  ResultAllDataTableViewController.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 23..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit
import CoreData

class ResultAllDataTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Result>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchResults()
    }
    
    private func fetchResults() {
        
        if patient != nil {
            
            let fetchRequest: NSFetchRequest<Result> = Result.fetchRequest()
            
            let patientPredicate = NSPredicate(format: "patient = %@", patient!)
            
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            
            fetchRequest.predicate = patientPredicate
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext!,
                sectionNameKeyPath: "date.year",
                cacheName: nil
            )
            
            try? fetchedResultsController?.performFetch()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if fetchedResultsController != nil {
            
            if fetchedResultsController!.fetchedObjects != nil {
                
                return fetchedResultsController!.fetchedObjects!.count
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        if let resultCell = cell as? ResultTableViewCell {
            
            let result = fetchedResultsController?.fetchedObjects?[indexPath.row]
            
            if result != nil {
                
                if result?.date != nil && result?.patient != nil && result?.normative != nil && result?.personal != nil {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd"
                    dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
                    
                    resultCell.dateLabel.text = dateFormatter.string(from: (result?.date)! as Date)
                    resultCell.scoreLabel.text = String(describing: result!.point)
                    
                    return resultCell
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (fetchedResultsController?.fetchedObjects) != nil && (fetchedResultsController?.fetchedObjects!.count)! > 0 {
            
            return (fetchedResultsController?.sections?[section].objects?.first as? Result)?.date?.year()
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        if cell is ResultTableViewCell {
            
            let result = fetchedResultsController?.fetchedObjects?[indexPath.row]
            
            if result != nil {
                
                if result?.date != nil && result?.patient != nil && result?.normative != nil && result?.personal != nil {
                    
                    showMoreInfoAbout(result: result!)
                }
            }
        }
    }
    
    private func showMoreInfoAbout(result: Result) {
        
        let resultInfoAlert = UIAlertController(
            title: result.date?.toString(),
            message: "Normatív standard: \n" + result.normative! + "\n\n" + "Egyéni standard: \n" + result.personal!, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Rendben", style: .default, handler: nil)
        
        resultInfoAlert.addAction(closeAction)
        
        self.present(resultInfoAlert, animated: true, completion: nil)
    }
}
