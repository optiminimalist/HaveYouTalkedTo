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
    private var allContactsByID = [String: Contact]()
    
    private var allGroups = [CNGroup]()
    private var allEnabledGroups = [Bool]()
    private var ungroupedEnabled = true
    
    private let sectionHeadings = ["> 6 months ago", "> 3 months ago", "< a month ago", "< a week ago", "yesterday", "today"]
    let sectionShort = [">6m", ">3m", "<1m", "<1w", "<1d", "0d"]
    private let sectionThresholds: [Date] = [Date.from(0000, 01, 01)!, Date().changeDays(by: -90), Date().changeDays(by: -30), Date().changeDays(by: -7), Date().changeDays(by: -1), Date().stripTime()]

    private var sectionTitleForContacts = [String]()
    var contactsByLastContacted = [[Contact]]()
    
    var context: NSManagedObjectContext!

    
    func markLastContacted(forIndexPath indexPath: IndexPath) {
        self.contactsByLastContacted[indexPath.section][indexPath.row].setLastContactDate(Date().stripTime())
        
        self.savePersistentContext()
        self.organizeLists()
    }
    
    func markLastContacted(id: String, lastContacted: Date?) {
        self.allContactsByID[id]?.lastContactDate = lastContacted
        
        self.savePersistentContext()
        self.organizeLists()
    }
    
    func fetchContacts() {
        // replace with dictionary
        self.allGroups = self.fetchContactGroupsFromCNContacts().sorted(by: {$0.name <= $1.name})
        self.allEnabledGroups = self.allGroups.map({_ in true})
        assert(self.allEnabledGroups.count == self.allGroups.count)
        
        let cnContacts = self.fetchAllCNContacts()
        let allContacts: [Contact] = cnContacts.map {
            enrichCNContactWithPeristedContact($0, Array($1))
        }.sorted()
        self.allContactsByID = Dictionary(uniqueKeysWithValues: allContacts.map { ($0.id, $0) })

        self.savePersistentContext()
        self.organizeLists()
    }
    
    
//    // TODO delete
//    func randomizeDates() {
//        for var c in self.allContacts {
//            c.lastContactDate = generateRandomDate(daysBack: 180)
//        }
//        
//        self.savePersistentContext()
//        self.organizeLists()
//    }
    
    func getNumberOfSectionsForContacts() -> Int {
        return self.contactsByLastContacted.count
    }
    
    func getContacts(forSection: Int) -> [Contact] {
        return self.contactsByLastContacted[forSection]
    }
    
    func getSectionHeading(forSection: Int) -> String {
        return self.sectionHeadings[forSection]
    }
    
    func getAllGroups() -> [CNGroup] {
        self.allGroups
    }
    
    func getAllEnabledGroups() -> [Bool] {
        self.allEnabledGroups
    }
    
    func getUngroupedEnabled() -> Bool {
        self.ungroupedEnabled
      }
      
    
    func setGroupEnabled(id: Int, value: Bool){
        self.allEnabledGroups[id] = value
        self.organizeLists()
    }
    
    func setUngroupedEnabled(value: Bool) {
        self.ungroupedEnabled = value
        self.organizeLists()
    }
    
    func getAllContacts() -> [Contact] {
        allContactsByID.values.map({$0})
    }
    
    private func organizeLists() {
        let allContacts = filterByGroups(contacts: self.getAllContacts().sorted())
        
//        let filteredContacts = self.allContacts.filter(
//        {
//            for (idx, elm) in self.allGroups.enumerated(){
//                if $0.cnContact.
//            }
//            $0 == $0
//        }
//        )
        
        
        // instantiate contactsByLastContacted
        self.contactsByLastContacted = [[Contact]]()
        for _ in 0...self.sectionThresholds.count-1 {
            self.contactsByLastContacted.append([Contact]())
        }
        
        // iterate over all contacts and assign them to their bucket
        for c in allContacts {
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
        
        print(self.getAllContacts().count)
        print(allContacts.count)
    }
    
    private func enrichCNContactWithPeristedContact(_ contact: CNContact, _ groups: [CNGroup]) -> Contact {
        let fetchedLastContact = fetchOrCreatePersistedContact(id: contact.identifier)
        return Contact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName, persistedContact: fetchedLastContact, cnContact: contact, cnGroups: groups)
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
    
    private func fetchAllCNContacts() -> [CNContact: Set<CNGroup>] {
        var contactsWithGroups: [CNContact: Set<CNGroup>] = [:]

        for group in self.allGroups {
            let contactsByGroup = self.fetchContactsFromCNContacts(byGroup: group)
            
            for contact in contactsByGroup {
                if contactsWithGroups[contact] == nil {
                    contactsWithGroups[contact] = []
                }
                contactsWithGroups[contact] = contactsWithGroups[contact]!.union([group])

            }
            
        }
        
        // contacts without groups
        for contact in self.fetchContactsFromCNContacts() {
            if contactsWithGroups[contact] == nil {
                contactsWithGroups[contact] = []
            }
        }


        return contactsWithGroups
    }
    
    private func fetchContactGroupsFromCNContacts() -> [CNGroup] {
        let groups = try! CNContactStore().groups(matching: nil)

        return groups
    }
    
    private func fetchContactsFromCNContacts(byGroup: CNGroup) -> [CNContact] {
        let predicate = CNContact.predicateForContactsInGroup(withIdentifier: byGroup.identifier)
        let keysToFetch: [CNKeyDescriptor] = [ CNContactViewController.descriptorForRequiredKeys()]
        

        return try! CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
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

    private func filterByGroups(contacts: [Contact]) -> [Contact] {
          
        let groups: [CNGroup] = zip(self.getAllGroups(), self.getAllEnabledGroups()).filter {
              $0.1
          }.map {
              $0.0
          }
          
      let filteredContacts = contacts.filter {
        if $0.cnGroups.count == 0 {
            return self.ungroupedEnabled
        }
          for filterGroup in groups {

           
            for cnGroup in $0.cnGroups {
                if filterGroup == cnGroup {
                    return true
                }
            }
          }
          
          return false
      }
        
    return filteredContacts
  }
    
    

   //TODO should this be here?
   private func savePersistentContext() {
       do {
          try context.save()

          } catch {
              // TODO Error Handling
              print("Error")
          }
   }
    

    
}
