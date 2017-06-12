//
//  AddNewPatientViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 13..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AddNewPatientViewController: UIViewController {
    
    var patientPOJO = PatientPOJO()
    
    let validator = PatientValidator()
    
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var sexTypeSelector: UISegmentedControl!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var tajTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let pickerViewComponents = ["Nő", "Férfi"]
    
    var selectedSexType: String!
    
    let datePickerKeyBoard = UIDatePicker()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        changeMainStackAxis()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tappedGR = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.view.addGestureRecognizer(tappedGR)
        
        nameTextField.delegate = self
        tajTextField.delegate = self
        birthdayTextField.delegate = self
        
        datePickerKeyBoard.addTarget(self, action: #selector(selectedBirthDayChanged), for: .valueChanged)
        datePickerKeyBoard.setDate(Date(), animated: true)
        datePickerKeyBoard.datePickerMode = .date
        datePickerKeyBoard.locale = NSLocale.current
        
        birthdayTextField.inputView = datePickerKeyBoard
    }
    
    @objc private func tappedView(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    private func changeMainStackAxis() {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            
            setMainStackAxis(to: .vertical)
            
        case .faceUp, .faceDown:
            
            (self.view.frame.width < self.view.frame.height) ? setMainStackAxis(to: .vertical) : setMainStackAxis(to: .horizontal)
            
        default:
            
            setMainStackAxis(to: .horizontal)
        }
    }
    
    private func setMainStackAxis(to axis: UILayoutConstraintAxis) {
        
        mainStackView.axis = axis
        
        switch axis {
        case .horizontal:
            mainStackView.spacing = 10.0
        case .vertical:
            mainStackView.spacing = 0.0
        }
    }
    
    func isSavePatientEnabled() -> Bool {
        
        if PatientValidator.isValid(fullName: (nameTextField.text!, lastnameTextField.text!)) &&
            PatientValidator.isValid(TAJ: tajTextField.text) &&
            sexTypeSelector.selectedSegmentIndex > -1 {
            
            patientPOJO.firstName = nameTextField.text
            patientPOJO.lastName = lastnameTextField.text
            patientPOJO.TAJ = tajTextField.text
            
            if patientPOJO.birthDate == nil && birthdayTextField.text != nil {
                
                patientPOJO.birthDate = Date.date(from: birthdayTextField.text!)
            }
            
            return true
        }
        
        return false
    }
    
    @objc private func selectedBirthDayChanged(sender: UIDatePicker) {
        
        birthdayTextField.text = sender.date.toString()
        
        if isSavePatientEnabled() {
            
            saveButton.isEnabled = true
            
        } else {
            
            self.saveButton.isEnabled = false
        }
    }
    
    @IBAction func selectedSexTypeChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.patientPOJO.sexType = SexType.No
        case 1:
            self.patientPOJO.sexType = SexType.Ferfi
        default:
            break
        }
        
        if isSavePatientEnabled() {
            
            saveButton.isEnabled = true
            
        } else {
            
            self.saveButton.isEnabled = false
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func savePatient(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        showSaveAlert()
    }
    
    private func showSaveAlert() {
        
        let name = "Név: \(patientPOJO.firstName!) \(patientPOJO.lastName!)\n"
        let sex = "Nem: \(patientPOJO.sexType == SexType.No ? "Nő" : "Férfi") \n"
        let birthDate = "Születési dátum: \(patientPOJO.birthDate!.toString()) \n"
        let taj = "TAJ szám: \(patientPOJO.TAJ!) \n"
        
        let savePatientAlert = UIAlertController(
            title: "Beteg rögzítése",
            message: "Adatak: \n" + name + sex + birthDate + taj, preferredStyle: .alert)
        
        savePatientAlert.addAction(UIAlertAction(title: "Mégsem", style: .cancel, handler: { (action: UIAlertAction) in
            //Do nothing - close the popup
        }))
        
        savePatientAlert.addAction(UIAlertAction(title: "Rögzít", style: .default, handler: { (action: UIAlertAction) in
            
            patient = Patient(context: managedObjectContext!)
            
            patient!.firstName = self.patientPOJO.firstName
            patient!.lastName = self.patientPOJO.lastName
            patient!.birthDate = self.patientPOJO.birthDate! as NSDate
            patient!.sexType = Int32(self.patientPOJO.sexType.hashValue)
            patient!.taj = self.patientPOJO.TAJ
            patient!.identifier = patient!.taj
            
            try! managedObjectContext?.save()
            
            let segue = UIStoryboardSegue.init(identifier: "operationVCSegue", source: self, destination: (self.storyboard?.instantiateViewController(withIdentifier: "operationVC"))!)
            
            self.performSegue(withIdentifier: segue.identifier!, sender: self)
        }))
        
        self.present(savePatientAlert, animated: true, completion: nil)
    }
}

extension AddNewPatientViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == self.nameTextField {
            
            self.patientPOJO.firstName = textField.text
            self.birthdayTextField.becomeFirstResponder()
            
        } else if textField == self.lastnameTextField {
            
            self.patientPOJO.lastName = textField.text
            self.birthdayTextField.becomeFirstResponder()
            
        } else if textField == self.birthdayTextField {
            
            let selectedDate = Date.date(from: textField.text!)
            self.patientPOJO.birthDate = selectedDate
            self.tajTextField.becomeFirstResponder()
            
        } else if textField == self.tajTextField {
            
            self.patientPOJO.TAJ = textField.text
            
        }
        
        if self.isSavePatientEnabled() {
            
            self.saveButton.isEnabled = true
            
        } else {
            
            self.saveButton.isEnabled = false
        }
        
        self.view.endEditing(true)
        
        return false
    }
}

// MARK: Keyboard notification handling

extension AddNewPatientViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardRectTopY = self.view.frame.height - keyboardSize.height
            
            var selectedTextField: UITextField!
            
            if nameTextField.isEditing {
                
                selectedTextField = nameTextField
                
            } else if lastnameTextField.isEditing {
                
                selectedTextField = lastnameTextField
                
            } else if birthdayTextField.isEditing {
                
                selectedTextField = birthdayTextField
                
            } else if tajTextField.isEditing {
                
                selectedTextField = tajTextField
                
            }
            
            let parent = topStackView.subviews.contains(selectedTextField) ? topStackView : bottomStackView
            
            let textFieldBottomY = selectedTextField.frame.maxY + (parent?.frame.minY)! + (navigationController?.navigationBar.frame.height)!
            
            if textFieldBottomY > keyboardRectTopY {
                
                let destinationOriginY = keyboardRectTopY - textFieldBottomY - (navigationController?.navigationBar.frame.height)!
                
                if destinationOriginY < keyboardRectTopY {
                    
                    self.view.frame.origin.y = keyboardRectTopY - self.view.frame.height
                }
                
                self.view.frame.origin.y = destinationOriginY
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.patientPOJO.firstName = nameTextField.text
        
        self.patientPOJO.lastName = lastnameTextField.text
        
        self.patientPOJO.TAJ = tajTextField.text
        
        if birthdayTextField.text != nil && !(birthdayTextField.text!.isEmpty) {
            
            let birthDay = Date.date(from: birthdayTextField.text!)
            patientPOJO.birthDate = birthDay
        }
        
        if self.view.frame.origin.y != 0 {
            
            self.view.frame.origin.y = 0
        }
        
        if self.isSavePatientEnabled() {
            
            self.saveButton.isEnabled = true
            
        } else {
            
            self.saveButton.isEnabled = false
        }
    }
}










