//
//  Patient+CoreDataProperties.swift
//  
//
//  Created by Balázs Bojrán on 2017. 06. 12..
//
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var birthDate: NSDate?
    @NSManaged public var taj: String?
    @NSManaged public var sexType: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var identifier: String?
    @NSManaged public var results: NSSet?
    @NSManaged public var testCases: NSSet?

}

// MARK: Generated accessors for results
extension Patient {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: Result)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: Result)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}

// MARK: Generated accessors for testCases
extension Patient {

    @objc(addTestCasesObject:)
    @NSManaged public func addToTestCases(_ value: TestCase)

    @objc(removeTestCasesObject:)
    @NSManaged public func removeFromTestCases(_ value: TestCase)

    @objc(addTestCases:)
    @NSManaged public func addToTestCases(_ values: NSSet)

    @objc(removeTestCases:)
    @NSManaged public func removeFromTestCases(_ values: NSSet)

}
