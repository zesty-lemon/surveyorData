//
//  Survey+CoreDataProperties.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//
//

import Foundation
import CoreData


extension Survey {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Survey> {
        return NSFetchRequest<Survey>(entityName: "Survey")
    }
    
    @NSManaged public var surveyTitle: String
    @NSManaged public var entry: NSSet?
    @NSManaged public var entryHeaders: [String]
    @NSManaged public var entryDataTypes: [String] //can it be instantiated but have a value of null if it is non-optional?
    @NSManaged public var containsLocation: Bool
    @NSManaged public var containsPhoto: Bool
    //hacky & weird, maybe bug?
    @NSManaged public var type: String
    
    //in addition to entry headers, maybe add variables like includeGPS, includeLoac etc
    //returns an ordered list of entries, sorted by time created
    public func entries() -> [Entry]{
        if let e = entry as? Set<Entry>{
            //$1 is next index
            return e.sorted{$0.timeStamp<$1.timeStamp}
        }
        return []
    }
}

// MARK: Generated accessors for entry
extension Survey {

    @objc(addEntryObject:)
    @NSManaged public func addToEntry(_ value: Entry)

    @objc(removeEntryObject:)
    @NSManaged public func removeFromEntry(_ value: Entry)

    @objc(addEntry:)
    @NSManaged public func addToEntry(_ values: NSSet)

    @objc(removeEntry:)
    @NSManaged public func removeFromEntry(_ values: NSSet)

}

extension Survey : Identifiable {

}
