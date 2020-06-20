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
        if let l = lhs.lastContactDate, let r = rhs.lastContactDate {
            if l != r {
                return l < r
            } else {
                return lhs.lastName < rhs.lastName
            }
        }
        else if lhs.lastContactDate != nil {
            return false
        }
        else {
            return true
        }
    }
    
    var id: String
    var firstName: String
    var lastName: String
    var lastContactDate: Date? {
        if let d = self.persistedContact {
            return d.lastContactDate
        }
        else {
            return nil
        }
    }
    var persistedContact: PersistedContact?
    var cnContact: CNContact?
    
    func setLastContactDate(_ d: Date) {
        self.persistedContact?.lastContactDate = d
    }
    
}

