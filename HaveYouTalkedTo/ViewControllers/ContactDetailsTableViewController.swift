//
//  ContactDetailsTableViewController.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/26/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import UIKit

class ContactDetailsTableViewController: UITableViewController {

    var contact: Contact!
    var store: ContactsStore!
    var contactEntries: [ContactEntry]!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = self.contact.firstName + " " + self.contact.lastName

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem

        let contactEntries = self.contact.persistedContact?.contactEntries?.allObjects as! [ContactEntry]
        self.contactEntries = contactEntries.sorted(by: >)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
           if self.contactEntries.count == 0 {
                self.tableView.setEmptyMessage("No contact attempts yet :(")
            } else {
                self.tableView.restore()
            }
          return 1
      }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contactEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailViewCell", for: indexPath) as! ContactDetailCell
        if let date = formatDate(self.contactEntries[indexPath.row].lastContactDate) {
            cell.contactedOnLabel.text = "\(date)"
        } else {
            cell.contactedOnLabel.text = "never"

        }
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.contactEntries.remove(at: indexPath.row)
            self.contact.persistedContact?.contactEntries = NSSet(array: self.contactEntries)

            // TODO don't
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)

            NotificationCenter.default.post(name: .didLastContactedChange, object: nil)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
