//
//  BandDB+CoreDataProperties.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 22.11.2024.
//
//

import Foundation
import CoreData


extension BandDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BandDB> {
        return NSFetchRequest<BandDB>(entityName: "BandDB")
    }

    @NSManaged public var country: String?
    @NSManaged public var creationYear: Int32
    @NSManaged public var genre: String?
    @NSManaged public var name: String?

}

extension BandDB : Identifiable {

}
