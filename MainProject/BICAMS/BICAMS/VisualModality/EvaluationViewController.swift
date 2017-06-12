//
//  EvaluationViewController.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 05. 27..
//  Copyright © 2017. gbr666. All rights reserved.
//

import UIKit
import MessageUI

class EvaluationViewController: UIViewController {

    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var solutionImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!

    let notEvaluatedString = "Nem értékelt"
    let pickerOptionsCount = 38

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let taskImageName = PatientModel.shared.getCurrentTestTaskImageName()
        taskImageView.image = UIImage(named: taskImageName)

        let solutionImageData = PatientModel.shared.getCurrentTestSolutionImageData()
        solutionImageView.image = UIImage(data: solutionImageData)

        let patient = PatientModel.shared.getCurrentPatientData()
        nameLabel.text = patient!.0 + " " + patient!.1
        idLabel.text = patient!.2

        let testDate = PatientModel.shared.getCurrentTestCaseDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "hu_HU")

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: testDate)

        let points = PatientModel.shared.getCurrentTestTestPoints()
        pointsTextField.text = points

        // Add picker view.
        let picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = UIColor.white

        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self

        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.blue
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Kész", style: .plain, target: self, action: #selector(donePicker))

        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        pointsTextField.inputView = picker
        pointsTextField.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTestPoints(_ sender: UIBarButtonItem) {
        let points = pointsTextField.text
        PatientModel.shared.saveTestPoints(points: points!)
    }

    @IBAction func composeMailWithPDF(_ sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self

            let pdfData = NSMutableData()

            UIGraphicsBeginPDFContextToData(pdfData, self.view.bounds, nil)
            UIGraphicsBeginPDFPage()

            guard let pdfContext = UIGraphicsGetCurrentContext() else {
                return
            }

            self.view.layer.render(in: pdfContext)

            UIGraphicsEndPDFContext()

            mailComposer.addAttachmentData(pdfData as Data, mimeType: "application/pdf", fileName: "test_results.pdf")

            self.present(mailComposer, animated: true, completion: nil)
        } else {
            print("No mail capabilities.")
        }
    }

    func donePicker() {
        pointsTextField.resignFirstResponder()
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

extension EvaluationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptionsCount
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return notEvaluatedString
        default:
            return String(row - 1) + " pont"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            pointsTextField.text = notEvaluatedString
        default:
            pointsTextField.text = String(row - 1) + " pont"
        }
    }
}

extension EvaluationViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
