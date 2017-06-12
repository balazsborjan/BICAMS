//
//  TestCase+CoreDataProperties.swift
//  
//
//  Created by Balázs Bojrán on 2017. 06. 12..
//
//

import Foundation
import CoreData


extension TestCase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestCase> {
        return NSFetchRequest<TestCase>(entityName: "TestCase")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var solutionImageData: NSData?
    @NSManaged public var taskImageName: String?
    @NSManaged public var testPoints: String?
    @NSManaged public var testOwner: Patient?

}
