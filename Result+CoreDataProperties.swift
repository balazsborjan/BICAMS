//
//  Result+CoreDataProperties.swift
//  
//
//  Created by Balázs Bojrán on 2017. 06. 12..
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var personal: String?
    @NSManaged public var normative: String?
    @NSManaged public var point: Int32
    @NSManaged public var patient: Patient?

}
