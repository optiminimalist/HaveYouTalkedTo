//
//  FilterViewController.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/20/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    var store: ContactsStore!

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView?.allowsMultipleSelection = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "iCloud Groups"
        } else if section == 1 {
            return "Ungrouped"
        }

        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return store.getAllGroups().count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("DeSelected!")
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none

        if indexPath.section == 0 {
            self.store.setGroupEnabled(id: indexPath.row, value: false)
        } else {
            self.store.setUngroupedEnabled(value: false)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected!")
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if indexPath.section == 0 {
            self.store.setGroupEnabled(id: indexPath.row, value: true)
        } else {
            self.store.setUngroupedEnabled(value: true)
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath)

        if indexPath.section == 1 {
            cell.textLabel?.text = "Show Ungrouped"
            if self.store.getUngroupedEnabled() {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }

        } else {
            cell.textLabel?.text = self.store.getAllGroups()[indexPath.row].name

              if self.store.getAllEnabledGroups()[indexPath.row] {
                  tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
              }

        }

        return cell
    }

}
