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
        
        let contact = self.store.allContacts[indexPath.row]
        cell.lastNameLabel.text = contact.lastName
        cell.firstNameLabel.text = contact.firstName
        cell.lastContactedLabel.text = formatDate(contact.lastContactDate) ?? "never"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.allContacts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.store.markLastContacted(id: indexPath.row)
        self.tableView.reloadData()

    }
    
    @IBAction func randomizeButtonClicked(_ sender: UIButton) {
        self.store.randomizeDates()
        self.tableView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.askUserForContactsPermission(onCompletion: self.store.fetchContacts)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//         return 1
//     }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
    
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
                    
//                DispatchQueue.main.async {
//                    self.contactsTableView.reloadData()
//                }
            } else {
                print("Access denied..")
            }
        }
    }
}
