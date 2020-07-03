//
//  ContactHighlightsViewController.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/27/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import UIKit

class ContactHighlightsViewController: UITableViewController {
    var store: ContactsStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO
        CNContactManager.askUserForContactsPermission(onCompletion: self.store.fetchContacts)
        self.tableView.reloadData()

        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Today"

        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // Gets called when any modification is done in iOS contact app
    @objc private func addressBookDidChange(notification: NSNotification) {
        // TODO change
        self.store.fetchContacts()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.store.fetchOrCreateHighlights(byDate: Date().stripTime()).count == 0 {
              self.tableView.setEmptyMessage("All Done!")
          } else {
              self.tableView.restore()
          }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.fetchOrCreateHighlights(byDate: Date()).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactHighlightsCell", for: indexPath) as! ContactHightlightCell

        let contact = self.store.fetchOrCreateHighlights(byDate: Date())[indexPath.row]
        cell.firstNameLabel.text = contact.firstName
        cell.lastNameLabel.text = contact.lastName
        return cell
    }

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // TODO implement tableview click
            let presentedVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsTableViewController") as! ContactDetailsTableViewController
    //        presentedVC.delegate = self
            presentedVC.contact = self.store.fetchOrCreateHighlights(byDate: Date())[indexPath.row]
            navigationController?.pushViewController(presentedVC, animated: true)
        }

    func processMarkLastContacted(indexPath: IndexPath, lastContacted: Date?) {
//           let contact = self.store.contactsByLastContacted[indexPath.section][indexPath.row]
//           let previousContact = contact.lastContactDate
//           self.store.markLastContacted(forIndexPath: indexPath, lastContacted: (lastContacted ?? Date()).stripTime())
//           let currentContact = contact.lastContactDate
//
//           self.contactDidChange(id: contact.id, fromDate: previousContact, toDate: currentContact)
       }

   override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let markContactedTodayAction = UIContextualAction(style: .normal, title: "Contacted Today") { (_, _, completionHandler) in

           self.processMarkLastContacted(indexPath: indexPath, lastContacted: Date())
           completionHandler(true)

         }

         markContactedTodayAction.backgroundColor = .systemGreen
         return UISwipeActionsConfiguration(actions: [markContactedTodayAction])
   }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let markIgnoreAction = UIContextualAction(style: .normal, title: "Skip") { (_, _, completionHandler) in

              completionHandler(true)

            }

            markIgnoreAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [markIgnoreAction])
      }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
