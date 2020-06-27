//
//  CNContactManager.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/27/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//
import Contacts
class CNContactManager {
    public static func askUserForContactsPermission(
          onCompletion:@escaping () -> Void
      ) {
          let store = CNContactStore()

          store.requestAccess(for: .contacts) { (granted: Bool, err: Error?) in
              if let err = err {
                  print("Failed to request access with error \(err)")
                  return
              }

              if granted {
                  print("User has granted permission for contacts")

                  onCompletion()
              } else {
                  print("Access denied..")
              }
          }
      }
}
