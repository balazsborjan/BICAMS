//
//  PreviousTestsListViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 06..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class PreviousTestsListViewController: UIViewController {

    @IBOutlet weak var previousTestsListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.previousTestsListTableView.reloadData()
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

extension PreviousTestsListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return PatientModel.shared.getTestCountForCurrentPatient()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousTestsListPatientDataCell", for: indexPath)
            let patient = PatientModel.shared.getCurrentPatientData()
            cell.textLabel?.text = patient!.0 + " " + patient!.1
            cell.detailTextLabel?.text = "Azonosító: " + patient!.2
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestDetailsMenuCell", for: indexPath)

            let testDate = PatientModel.shared.getTestDateAt(index: indexPath.row)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "hu_HU")

            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            cell.textLabel?.text = dateFormatter.string(from: testDate)

            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            cell.detailTextLabel?.text = dateFormatter.string(from: testDate)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Páciens adatai"
        default:
            if PatientModel.shared.getTestCountForCurrentPatient() == 0 {
                return "Nincs megjeleníthető adat"
            } else {
                return "Korábbi tesztek"
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            PatientModel.shared.setCurrentTestCaseBy(index: indexPath.row)
        }
    }
}
