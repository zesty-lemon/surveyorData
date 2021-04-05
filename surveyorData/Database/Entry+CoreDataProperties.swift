//
//  Entry+CoreDataProperties.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }
    //data stored in entry here
    @NSManaged public var entryData: [String]
    @NSManaged public var timeStamp: Date
    @NSManaged public var image: Data
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var survey: Survey
    

}
