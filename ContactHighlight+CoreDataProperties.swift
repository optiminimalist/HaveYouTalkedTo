//
//  ContactHighlight+CoreDataProperties.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/27/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//
//

import Foundation
import CoreData

extension ContactHighlight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactHighlight> {
        return NSFetchRequest<ContactHighlight>(entityName: "ContactHighlight")
    }

    @NSManaged public var id: String?
    @NSManaged public var highlightDate: Date?

}
