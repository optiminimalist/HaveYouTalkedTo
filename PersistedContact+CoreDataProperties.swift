//
//  PersistedContact+CoreDataProperties.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/26/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//
//

import Foundation
import CoreData

extension PersistedContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedContact> {
        return NSFetchRequest<PersistedContact>(entityName: "PersistedContact")
    }

    @NSManaged public var id: String?
    @NSManaged public var lastContactDate: Date?
    @NSManaged public var contactEntries: NSSet?

}

// MARK: Generated accessors for contactEntries
extension PersistedContact {

    @objc(addContactEntriesObject:)
    @NSManaged public func addToContactEntries(_ value: ContactEntry)

    @objc(removeContactEntriesObject:)
    @NSManaged public func removeFromContactEntries(_ value: ContactEntry)

    @objc(addContactEntries:)
    @NSManaged public func addToContactEntries(_ values: NSSet)

    @objc(removeContactEntries:)
    @NSManaged public func removeFromContactEntries(_ values: NSSet)

}
