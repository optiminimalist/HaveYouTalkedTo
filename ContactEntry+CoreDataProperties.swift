//
//  ContactEntry+CoreDataProperties.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/26/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//
//

import Foundation
import CoreData

extension ContactEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactEntry> {
        return NSFetchRequest<ContactEntry>(entityName: "ContactEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var lastContactDate: Date?
    @NSManaged public var persistedContact: PersistedContact?

}
