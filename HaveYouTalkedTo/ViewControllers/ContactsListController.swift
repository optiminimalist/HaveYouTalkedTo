//
//  ContactsListController.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/19/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import UIKit

class ContactsListController: UITableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsListCell", for: indexPath) as! ContactsListCell
        cell.lastNameLabel.text = "Hello"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
