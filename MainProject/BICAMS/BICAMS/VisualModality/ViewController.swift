//
//  ViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 04. 30..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var patientTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Get rid of empty cells.
        patientTableView.tableFooterView = UIView(frame: .zero)
        PatientModel.shared.fetchPatientList()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.patientTableView.reloadData()
        print("ViewController::viewWillAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewPatient(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Új páciens",
                                      message: "Adja meg a vezetéknevet, keresztnevet és az azonosítót",
                                      preferredStyle: .alert)
        
        let newPatientAction = UIAlertAction(title: "Mentés", style: .default, handler: { (action) -> Void in
            let surnameTxt = alert.textFields![0]
            let givenNameTxt = alert.textFields![1]
            let identifierTxt = alert.textFields![2]

            PatientModel.shared.createPatientWith(data: (surnameTxt.text!, givenNameTxt.text!, identifierTxt.text!))
            self.patientTableView.reloadData()
            //print("SURNAME: \(surnameTxt.text)\nGIVEN NAME: \(givenNameTxt.text)\nID: \(identifierTxt.text)")
        })
        
        let cancelAction = UIAlertAction(title: "Mégse",
                                         style: .destructive)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Vezetéknév"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Keresztnév"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Azonosító"
        }
        
        alert.addAction(newPatientAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func unwindToPatientList(segue: UIStoryboardSegue) {

    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PatientModel.shared.getPatientCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let patient = PatientModel.shared.getPatientDataAt(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath)
        cell.textLabel?.text = patient.0 + " " + patient.1
        cell.detailTextLabel?.text = "Azonosító: " + patient.2
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PatientModel.shared.setCurrentPatientBy(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if PatientModel.shared.getPatientCount() == 0 {
            return "Nincs megjeleníthető adat"
        } else {
            return "Páciensek"
        }
    }
}
