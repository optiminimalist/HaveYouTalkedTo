//
//  ContactsStore.swift
//  HaveYouTalkedTo?
//
//  Created by Michael Luckeneder on 6/10/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import Contacts
import CoreData
import ContactsUI

class ContactsStore {
//    var allContacts = [String: Contact]()
    var sortedContacts = [Contact]()
    
    init() {
        self.sortedContacts = self.loadAllContacts().sorted()
    }
    
    func savePersistentContext() {
        do {
           try context.save()

           } catch {
               // Error Handling
               print("Error")
           }
    }
    
    var context: NSManagedObjectContext {
        //1
        let appDelegate =
          UIApplication.shared.delegate as! AppDelegate
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        return managedContext

    }
    
    func loadAllContacts() -> [Contact] {
        return self.fetchContactsFromCNContacts().map { parseContact($0) }
//               .reduce(into: [String: Contact]()) {
//                   $0[$1.id] = $1
//               }

    }
    
    private func fetchContactsFromCNContacts() -> [CNContact] {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { success, error in
            if !success {
                print("Not authorized to access contacts. Error = \(String(describing: error))")
                exit(1)
            }
            print("Authorized!")
        }

        let keysToFetch: [CNKeyDescriptor] = [ CNContactViewController.descriptorForRequiredKeys()]
        let req = CNContactFetchRequest(keysToFetch: keysToFetch)

        var contacts: [CNContact] = []
        try! CNContactStore().enumerateContacts(with: req) {
            contact, stop in
            if contact.givenName.isEmpty || contact.familyName.isEmpty {
                
            } else {
                contacts.append(contact)
            }
        }

        return contacts
    }
    
    private func fetchPersistedContactFromCoreData(id: String) -> PersistedContact {
        // TODO: optimize
        let request = NSFetchRequest<PersistedContact>(entityName: "PersistedContact")
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let result = try context.fetch(request)
            assert(result.count < 2) // we shouldn't have any duplicates in CD

            if let c = result.first {
                return c
            }
        } catch {
            print(error)
        }

        let newContact = PersistedContact(context: context)
        newContact.id = id
        newContact.lastContactDate = nil
        // no local cache yet, use placeholder for now
        return newContact
    }
    
    private func parseContact(_ contact: CNContact) -> Contact {
        let fetchedLastContact = fetchPersistedContactFromCoreData(id: contact.identifier)

        return Contact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName, persistedContact: fetchedLastContact, cnContact: contact)
    }



    
}
