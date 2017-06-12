//
//  TestDetailsViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 08..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit

class TestDetailsViewController: UIViewController {

    @IBOutlet weak var testDetailsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        // iPad doesn't like .actionsheet here
        //let alert = UIAlertController(title: "Teszt törlése", message: "Biztosan törölni akarja a tesztet?", preferredStyle: .actionSheet)
        let alert = UIAlertController(title: "Teszt törlése", message: "Biztosan törölni akarja a tesztet?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Mégse", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Törlés", style: .destructive, handler: { (action) in
            self.deleteTestCase()
        }))

        present(alert, animated: true, completion: nil)
    }

    func deleteTestCase() {
        PatientModel.shared.deleteCurrentTestCase()
        _ = navigationController?.popViewController(animated: true)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskImage" {
            let destination = segue.destination as! TaskOrSolutionViewController

            let taskImageName = PatientModel.shared.getCurrentTestTaskImageName()
            destination.taskOrSolutionImage = UIImage(named: taskImageName)
            destination.title = "Feladat"
        } else if segue.identifier == "ShowSolutionImage" {
            let destination = segue.destination as! TaskOrSolutionViewController

            let solutionImageData = PatientModel.shared.getCurrentTestSolutionImageData()
            destination.taskOrSolutionImage = UIImage(data: solutionImageData)
        }
    }
}

extension TestDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 3
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCellInTestDetails", for: indexPath)
            let patient = PatientModel.shared.getCurrentPatientData()
            cell.textLabel?.text = patient!.0 + " " + patient!.1
            cell.detailTextLabel?.text = "Azonosító: " + patient!.2
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestCellInTestDetails", for: indexPath)
            // TODO: Get full test case data
            let testDate = PatientModel.shared.getCurrentTestCaseDate()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "hu_HU")

            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            cell.textLabel?.text = dateFormatter.string(from: testDate)

            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            cell.detailTextLabel?.text = dateFormatter.string(from: testDate)

            return cell
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
                cell.textLabel?.text = "Feladat"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SolutionCell", for: indexPath)
                cell.textLabel?.text = "Megoldás"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluationCell", for: indexPath)
                cell.textLabel?.text = "Értékelés"
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Páciens adatai"
        case 1:
            return "Teszt adatai"
        default:
            return "Menü"
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
