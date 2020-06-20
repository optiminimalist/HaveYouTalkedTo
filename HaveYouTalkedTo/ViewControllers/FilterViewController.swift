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
        return 1
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "iCloud Groups"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.getAllGroups().count
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("DeSelected!")
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.store.setGroupEnabled(id: indexPath.row, value: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected!")
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.store.setGroupEnabled(id: indexPath.row, value: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath)
        cell.textLabel?.text = self.store.getAllGroups()[indexPath.row].name
        
        if self.store.getAllEnabledGroups()[indexPath.row] {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        return cell
    }
}
