//
//  PatientModel.swift
//  VisualModality
//
//  Created by Gábor Ballabás on 2017. 04. 30..
//  Copyright © 2017. gbr666. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class PatientModel {

    private init() {
        // FIXME: Can this fail?
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }

    static let shared = PatientModel()

    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext

    private var patientList: [NSManagedObject] = []
    private var currentPatient: NSManagedObject?
    private var testListForCurrentPatient: [NSManagedObject] = []
    private var currentTestCase: NSManagedObject?
    private var testCaseToSave: NSManagedObject?

    // MARK: - Patient related functions
    func getPatientCount() -> Int {
        return patientList.count
    }

    // TODO: Create a full parameter list with lastName, firstName and identifier parameters
    func createPatientWith(data: (String, String, String)) {
        let entity = NSEntityDescription.entity(forEntityName: "Patient", in: managedContext)!

        let patient = NSManagedObject(entity: entity, insertInto: managedContext)

        patient.setValue(data.0, forKeyPath: "lastName")
        patient.setValue(data.1, forKeyPath: "firstName")
        patient.setValue(data.2, forKeyPath: "identifier")

        do {
            try managedContext.save()
            fetchPatientList()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }
    }

    func setCurrentPatientBy(index: Int) {
        currentPatient = patientList[index]
        fetchTestListForCurrentPatient()
    }

    // FIXME: Why is the return value optional?
    func getCurrentPatientData() -> (String, String, String)? {
        let lastName = currentPatient?.value(forKeyPath: "lastName") as! String
        let firstName = currentPatient?.value(forKeyPath: "firstName") as! String
        let identifier = currentPatient?.value(forKeyPath: "identifier") as! String
        return (lastName, firstName, identifier)
    }

    func getPatientDataAt(index: Int) -> (String, String, String) {
        let patient = patientList[index]
        let lastName = patient.value(forKeyPath: "lastName") as! String
        let firstName = patient.value(forKeyPath: "firstName") as! String
        let identifier = patient.value(forKeyPath: "identifier") as! String
        return (lastName, firstName, identifier)
    }

    // TODO: Remove solution image files belonging to this patient from the Document directory
    func deleteCurrentPatient() {
        if let patient = currentPatient {
            managedContext.delete(patient)
        }

        do {
            try managedContext.save()
            fetchPatientList()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }

        fetchPatientList()
    }

    func editCurrentPatientDataWith(data: (String, String, String)) {
        currentPatient?.setValue(data.0, forKey: "lastName")
        currentPatient?.setValue(data.1, forKey: "firstName")
        currentPatient?.setValue(data.2, forKey: "identifier")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }
    }

    func fetchPatientList() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Patient")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]

        do {
            patientList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Test Case related functions
    func getTestCountForCurrentPatient() -> Int {
        return testListForCurrentPatient.count
    }

    func getTestDateAt(index: Int) -> Date {
        let testCase = testListForCurrentPatient[index]
        let testDate = testCase.value(forKeyPath: "date") as? Date
        return testDate!
    }

    func setCurrentTestCaseBy(index: Int) {
        currentTestCase = testListForCurrentPatient[index]
    }

    func getCurrentTestCaseDate() -> Date {
        return currentTestCase?.value(forKeyPath: "date") as! Date
    }

    func getCurrentTestTaskImageName() -> String {
        let testImageName = currentTestCase?.value(forKeyPath: "taskImageName") as? String
        return testImageName!
    }

    func getCurrentTestSolutionImageData() -> Data {
        let testSolutionImageData = currentTestCase?.value(forKeyPath: "solutionImageData") as! Data
        return testSolutionImageData
    }

    func getCurrentTestTestPoints() -> String {
        let testPoints = currentTestCase?.value(forKeyPath: "testPoints") as? String
        return testPoints!
    }

    func createTestCaseWith(date: Date, taskImageName: String, solutionImageData: Data) {
        let entity = NSEntityDescription.entity(forEntityName: "TestCase", in: managedContext)!

        let testCase = NSManagedObject(entity: entity, insertInto: managedContext)

        testCase.setValue(date, forKeyPath: "date")
        testCase.setValue(taskImageName, forKeyPath: "taskImageName")
        testCase.setValue(solutionImageData, forKeyPath: "solutionImageData")

        let patient = currentPatient as! Patient
        patient.addToTestCases(testCase as! TestCase)

        do {
            try managedContext.save()
            fetchTestListForCurrentPatient()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }
    }

    func deleteCurrentTestCase() {
        if let testCase = currentTestCase {
            managedContext.delete(testCase)
        }

        do {
            try managedContext.save()
            fetchPatientList()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }

        fetchTestListForCurrentPatient()
    }

    func fetchTestListForCurrentPatient() {
        let testList = currentPatient?.mutableSetValue(forKeyPath: "testCases")
        testListForCurrentPatient = testList?.allObjects as! [NSManagedObject]
        testListForCurrentPatient.sort {
            ($0.value(forKeyPath: "date") as! Date) > ($1.value(forKeyPath: "date") as! Date)
        }
        //DEBUG
        //print(testList?.allObjects ?? "No test cases.")
    }

    func createTestCaseToSave() {
        let entity = NSEntityDescription.entity(forEntityName: "TestCase", in: managedContext)!

        testCaseToSave = NSManagedObject(entity: entity, insertInto: managedContext)
    }

    func setTestCaseToSaveTaskImageName(name: String) {
        testCaseToSave?.setValue(name, forKeyPath: "taskImageName")
    }

    func setTestCaseToSaveDate(date: Date) {
        testCaseToSave?.setValue(date, forKeyPath: "date")
    }

    func setTestCaseToSaveSolutionImageData(data: Data) {
        testCaseToSave?.setValue(data, forKeyPath: "solutionImageData")
    }

    func saveTestPoints(points: String){
        currentTestCase?.setValue(points, forKeyPath: "testPoints")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }
    }

    func saveTestCaseToSave() {
        // Add default value to testPoints
        testCaseToSave?.setValue("Nem értékelt", forKeyPath: "testPoints")

        let patient = currentPatient as! Patient
        patient.addToTestCases(testCaseToSave as! TestCase)

        do {
            try managedContext.save()
            fetchTestListForCurrentPatient()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }
    }
}

