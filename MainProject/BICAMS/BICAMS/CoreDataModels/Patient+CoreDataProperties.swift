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

    @NSManaged public var name: String?
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var taj: String?
    @NSManaged public var sexType: Int32

}
