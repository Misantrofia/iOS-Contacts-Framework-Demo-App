//
//  ViewController.swift
//  iOS-Contacts-Framework-Demo-App
//
//  Created by Alexandru Schwartz on 27/07/16.
//  Copyright © 2016 Alexandru Schwartz. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

enum PilotNumberType {
    case Inbound
    case Outbound
    case Both
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pilotNumberTypePicker: UIPickerView!
    @IBOutlet weak var contactNameTextView: UITextView!
    @IBOutlet weak var inboundPilotNumberLabel: UILabel!
    @IBOutlet weak var outboundPilotNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pilotNumberTypePicker.showsSelectionIndicator = true
        self.pilotNumberTypePicker.selectRow(0, inComponent: 0, animated: false)
    }

    
    // MARK: - Actions

    @IBAction func showDeviceContactsTaped(sender: AnyObject, forEvent event: UIEvent) {
        let controller = CNContactPickerViewController()
        self.presentViewController(controller, animated: true) { 
            print("CNContactPickerViewController vas presented.")
        }
    }
    
    @IBAction func decorateContactButtonTapped(sender: AnyObject) {
        print("Selected contact type is \(self.pilotNumberTypePicker.selectedRowInComponent(0))")
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title : String?
        
        switch row {
        case 0:
            title = "Inbound"
        case 1:
            title = "Outbound"
        case 2:
            title = "Both"
        default:
            title = "None"
        }
        
        return title
    }
}

