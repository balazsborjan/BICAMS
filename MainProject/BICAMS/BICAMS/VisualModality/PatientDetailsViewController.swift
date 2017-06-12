//
//  PatientDetailsViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 04. 30..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class PatientDetailsViewController: UIViewController {

    @IBOutlet weak var patientDetailsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Get rid of empty cells.
        patientDetailsTableView.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        // iPad doesn't like .actionsheet here
        //let alert = UIAlertController(title: "Páciens törlése", message: "Biztosan törölni akarja a pácienst?", preferredStyle: .actionSheet)
        let alert = UIAlertController(title: "Páciens törlése", message: "Biztosan törölni akarja a pácienst?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Mégse", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Törlés", style: .destructive, handler: { (action) in
            self.deletePatient()
        }))

        present(alert, animated: true, completion: nil)
    }

    func deletePatient() {
        PatientModel.shared.deleteCurrentPatient()
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Páciens adatainak módosítása",
                                      message: nil,
                                      preferredStyle: .alert)

        let newPatientAction = UIAlertAction(title: "Módosít", style: .default, handler: { (action) -> Void in
            let surnameTxt = alert.textFields![0]
            let givenNameTxt = alert.textFields![1]
            let identifierTxt = alert.textFields![2]

            PatientModel.shared.editCurrentPatientDataWith(data: (surnameTxt.text!, givenNameTxt.text!, identifierTxt.text!))
            self.patientDetailsTableView.reloadData()
        })

        let cancelAction = UIAlertAction(title: "Mégse",
                                         style: .destructive)

        let patient = PatientModel.shared.getCurrentPatientData()

        alert.addTextField { (textField: UITextField) in
            textField.text = patient?.0
        }

        alert.addTextField { (textField: UITextField) in
            textField.text = patient?.1
        }

        alert.addTextField { (textField: UITextField) in
            textField.text = patient?.2
        }

        alert.addAction(newPatientAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PatientDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientDataCell", for: indexPath)
            let patient = PatientModel.shared.getCurrentPatientData()
            cell.textLabel?.text = patient!.0 + " " + patient!.1
            cell.detailTextLabel?.text = "Azonosító: " + patient!.2
            return cell
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TestListMenuCell", for: indexPath)
                cell.textLabel?.text = "Korábbi tesztek"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewTestMenuCell", for: indexPath)
                cell.textLabel?.text = "Új teszt"
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Páciens adatai"
        default:
            return "Menü"
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Páciens adatai"
    }
     */
}
