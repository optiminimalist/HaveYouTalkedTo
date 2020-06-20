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
    private let sectionHeadings = ["> 6 months ago", "> 3 months ago", "> a month ago", "< a month ago", "< a week ago", "yesterday", "today"]
    private let sectionThresholds: [Date] = [Date.from(0000, 01, 01)!, Date().changeDays(by: -90), Date().changeDays(by: -30), Date().changeDays(by: -7), Date().changeDays(by: -1), Date().stripTime()]

    private var sectionTitleForContacts = [String]()
    var contactsByLastContacted = [[Contact]]()

    
    func markLastContacted(forIndexPath indexPath: IndexPath) {
        self.contactsByLastContacted[indexPath.section][indexPath.row].setLastContactDate(Date().stripTime())
        
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
    
    func getNumberOfSectionsForContacts() -> Int {
        return self.contactsByLastContacted.count
    }
    
    func getNumberOfContacts(forSection: Int) -> Int {
        return self.contactsByLastContacted[forSection].count
    }
    
    func getSectionHeading(forSection: Int) -> String {
        return self.sectionHeadings[forSection]
    }
    
    private func organizeLists() {
        self.allContacts = self.allContacts.sorted()
        
        
        // instantiate contactsByLastContacted
        self.contactsByLastContacted = [[Contact]]()
        for _ in 0...self.sectionThresholds.count-1 {
            self.contactsByLastContacted.append([Contact]())
        }
        
        // iterate over all contacts and assign them to their bucket
        for c in self.allContacts {
            if let d = c.lastContactDate {
                for (idx, element) in self.sectionThresholds.enumerated().reversed() {
                   if d >= element {
                    self.contactsByLastContacted[idx].append(c)
                    break
                   }
                }
            }
            else {
                self.contactsByLastContacted[0].append(c)
            }
        }
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
