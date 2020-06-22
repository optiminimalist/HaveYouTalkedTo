//
//  DatePickerViewController.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/21/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    var delegate: DatePickerViewDelegate?

    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func markContactedPressed(_ sender: UIButton) {
        print(datePicker.date)
        if let delegate = self.delegate {
            print(delegate.getSelectedIndexPath())
            delegate.processMarkLastContacted(indexPath: delegate.getSelectedIndexPath(), lastContacted: datePicker.date)
         }
        
        self.dismiss(animated: true)
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
}

