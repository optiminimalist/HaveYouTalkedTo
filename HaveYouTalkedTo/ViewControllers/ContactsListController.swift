//
//  ContactsListController.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/19/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import UIKit
import Contacts

class ContactsListController: UITableViewController {
    private let store = ContactsStore()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsListCell", for: indexPath) as! ContactsListCell
        
        let contact = self.store.contactsByLastContacted[indexPath.section][indexPath.row]
        cell.lastNameLabel.text = contact.lastName
        cell.firstNameLabel.text = contact.firstName
        cell.lastContactedLabel.text = formatDate(contact.lastContactDate) ?? "never"

        return cell
    }
    
    
    @IBAction func randomizeButtonClicked(_ sender: UIButton) {
        self.store.randomizeDates()
        self.tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

        self.askUserForContactsPermission(onCompletion: self.store.fetchContacts)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addressBookDidChange),
            name: NSNotification.Name.CNContactStoreDidChange,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resignFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
      return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Gets called when any modification is done in iOS contact app
    @objc private func addressBookDidChange(notification: NSNotification) {
        self.store.fetchContacts()
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.store.allContacts.count == 0 {

               self.tableView.setEmptyMessage("My Message")
           } else {
               self.tableView.restore()
           }
        return self.store.getNumberOfSectionsForContacts()
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.store.getNumberOfContacts(forSection: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.store.getSectionHeading(forSection: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.store.sectionShort
    }
    
    private func askUserForContactsPermission(
        onCompletion:@escaping ()->Void
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
                    
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Access denied..")
            }
        }
    }
}

extension ContactsListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.store.contactsByLastContacted[indexPath.section][indexPath.row]
        let previousContact = contact.lastContactDate
        self.store.markLastContacted(forIndexPath: indexPath)
        let currentContact = contact.lastContactDate
        
        self.contactDidChange(id: contact.id, fromDate: previousContact, toDate: currentContact)

    }
    
    func contactDidChange(id: String, fromDate: Date?, toDate: Date?) {
        
        undoManager?.registerUndo(withTarget: self) { target in
            self.store.markLastContacted(id: id, lastContacted: fromDate)
            self.tableView.reloadData()
            self.contactDidChange(id: id, fromDate: toDate, toDate: fromDate)
        }

        self.tableView.reloadData()
    }

}
