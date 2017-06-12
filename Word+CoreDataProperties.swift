//
//  Word+CoreDataProperties.swift
//  
//
//  Created by Balázs Bojrán on 2017. 06. 12..
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var category: String?
    @NSManaged public var data: String?

}
