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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.store.markLastContacted(forIndexPath: indexPath)
        self.tableView.reloadData()

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Gets called when any modification is done in iOS contact app
    @objc private func addressBookDidChange(notification: NSNotification) {
        self.store.fetchContacts()
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        self.store.getNumberOfSectionsForContacts()
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
