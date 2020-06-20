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
    
    var allContacts = [Contact]()
    
    func markLastContacted(id: Int)  {
        self.allContacts[id].setLastContactDate(Date().stripTime())
        
        self.savePersistentContext()
        self.organizeLists()
    }
    
    func fetchContacts() {
        let cnContacts = self.fetchContactsFromCNContacts()
        self.allContacts = cnContacts.map(enrichCNContactWithPeristedContact(_:)).sorted()
            
        self.savePersistentContext()
        self.organizeLists()
        
        //todo remove
        self.randomizeDates()

    }
    
    // TODO delete
    func randomizeDates() {
        for var c in self.allContacts {
            c.lastContactDate = generateRandomDate(daysBack: 180)
        }
        
        self.savePersistentContext()
        self.organizeLists()
    }
    
    private func organizeLists() {
        self.allContacts = self.allContacts.sorted()
    }
    
    private func enrichCNContactWithPeristedContact(_ contact: CNContact) -> Contact {
        let fetchedLastContact = fetchOrCreatePersistedContact(id: contact.identifier)
        return Contact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName, persistedContact: fetchedLastContact, cnContact: contact)
    }
    
    private func fetchOrCreatePersistedContact(id: String) -> PersistedContact {
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
            // TODO
            print(error)
        }

        let newContact = PersistedContact(context: context)
        newContact.id = id
        newContact.lastContactDate = nil
        return newContact
    }


    
    private func fetchContactsFromCNContacts() -> [CNContact] {
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
    
    private var context: NSManagedObjectContext {
           //1
           let appDelegate =
             UIApplication.shared.delegate as! AppDelegate

           let managedContext =
             appDelegate.persistentContainer.viewContext

           return managedContext

       }
       
       private func savePersistentContext() {
           do {
              try context.save()

              } catch {
                  // TODO Error Handling
                  print("Error")
              }
       }
    

    
}
//
//class ContactsStore {
////    var allContacts = [String: Contact]()
//    var sortedContacts = [Contact]()
//
//    init() {
//        self.sortedContacts = self.loadAllContacts().sorted()
//    }
//
//    func savePersistentContext() {
//        do {
//           try context.save()
//
//           } catch {
//               // Error Handling
//               print("Error")
//           }
//    }
//

//
//    func loadAllContacts() -> [Contact] {
//        return self.fetchContactsFromCNContacts().map { parseContact($0) }
////               .reduce(into: [String: Contact]()) {
////                   $0[$1.id] = $1
////               }
//
//    }
//
//
//
//    private func parseContact(_ contact: CNContact) -> Contact {
//        let fetchedLastContact = fetchPersistedContactFromCoreData(id: contact.identifier)
//
//        return Contact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName, persistedContact: fetchedLastContact, cnContact: contact)
//    }
//
//
//
//
//}
