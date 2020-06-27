//
//  ContactEntry+CoreDataClass.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/26/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ContactEntry)
public class ContactEntry: NSManagedObject, Comparable {
    public static func < (lhs: ContactEntry, rhs: ContactEntry) -> Bool {
              if let lhsDate = lhs.lastContactDate, let rhsDate = rhs.lastContactDate {
                  if lhsDate != rhsDate {
                      return lhsDate < rhsDate
              } else if lhs.lastContactDate != nil {
                  return false
              } else {
                  return true
              }
          }

        return false

    }

}
