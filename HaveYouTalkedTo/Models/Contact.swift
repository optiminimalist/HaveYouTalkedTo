//
//  ContactRow.swift
//  LastContact
//
//  Created by Michael Luckeneder on 6/5/20.
//  Copyright © 2020 Michael Luckeneder. All rights reserved.
//

import Contacts

struct Contact: Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        if let lhsDate = lhs.lastContactDate, let rhsDate = rhs.lastContactDate {
            if lhsDate != rhsDate {
                return lhsDate < rhsDate
            } else {
                return lhs.lastName < rhs.lastName
            }
        } else if lhs.lastContactDate != nil {
            return false
        } else {
            return true
        }
    }

    var id: String
    var firstName: String
    var lastName: String
    var lastContactDate: Date? {
        get {
            if let entries = self.persistedContact?.contactEntries?.allObjects as? [ContactEntry] {
                return entries.sorted(by: <).last?.lastContactDate
            } else {
                return nil
            }
        }
    }
    var persistedContact: PersistedContact?
    var cnContact: CNContact?
    var cnGroups: [CNGroup]

    func setLastContactDate(_ d: Date) {
        self.persistedContact?.lastContactDate = d
    }

}
