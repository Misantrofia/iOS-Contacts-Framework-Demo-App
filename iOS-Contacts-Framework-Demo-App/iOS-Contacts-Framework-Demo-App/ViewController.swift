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

// @"Outgoing Sideline Call" : @"Incoming Sideline Call";

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pilotNumberTypePicker: UIPickerView!

    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var inboundPilotNumberLabel: UILabel!
    @IBOutlet weak var outboundPilotNumberLabel: UILabel!
    @IBOutlet weak var inboundPilotNumberTextField: UITextField!
    @IBOutlet weak var outboundPilotNumberTextField: UITextField!
    
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
        
        let searchText = self.contactNameTextField.text ?? ""
        
        print("Unified contacts")
        let contacts = self.searchContactsWithName(searchText)

        print("Fetched contacts")
        let filteredContacts = self.searchContactWithMatcingName(searchText)

    }
    
    @IBAction func updatePilotNumberButtonTaped(sender: AnyObject, forEvent event: UIEvent) {
    }
    
    @IBAction func placeCallButtonTaped(sender: AnyObject) {
        
        let identifier : String
        
        switch self.pilotNumberTypePicker.selectedRowInComponent(0) {
        case 0:
            identifier = "9F8055C6-9356-445E-AAB5-1F3F491394E9"
        case 1:
            identifier = "020124CC-BF2C-45B4-A21B-531CBDC6C75C"
        case 2:
            identifier = "F611F5E0-2F17-428C-8A37-AE939930FC78"
        default:
            identifier = "F611F5E0-2F17-428C-8A37-AE939930FC78"
        }
        
        print("Search for ID : \(identifier)")
        let contact = self.searchContactWithIdentifier(identifier);
        print("Searched contact by ID : \(contact)")
        
        let mutableContact = contact?.mutableCopy() as! CNMutableContact
        let newEmail = CNLabeledValue(label: nil, value: "aaa.bbb@pinger.com")
        mutableContact.emailAddresses = [newEmail]
        
        let saveRequest = CNSaveRequest()
        saveRequest.updateContact(mutableContact)
        let store = CNContactStore()
        try! store.executeSaveRequest(saveRequest)
        
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func endCallButtonTaped(sender: AnyObject, forEvent event: UIEvent) {
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
    
    // MARK: Private 
    
    func searchContactsWithName(name : String) -> [CNContact] {
        let predicate: NSPredicate = CNContact.predicateForContactsMatchingName(name)
        let keysToFetch = [CNContactGivenNameKey]
        
        let store = CNContactStore()
        let contacts = try! store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
        
        for contact in contacts {
            print("Contact : \(contact)")
            print("Identifier : \(contact.identifier)")
        }

        return contacts
    }
    
    func searchContactWithMatcingName(name : String) -> [CNContact] {
        let predicate: NSPredicate = CNContact.predicateForContactsMatchingName(name)
        let keysToFetch = [CNContactGivenNameKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.predicate = predicate
        fetchRequest.unifyResults = false
        
        let store = CNContactStore()
        var filteredContacts : [CNContact] = []
        try! store.enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) in
          //  if contact.givenName == name {
                filteredContacts.append(contact)
            print("Contact : \(contact)")
            print("Identifier : \(contact.identifier)")
          //  }
        }
        
        return filteredContacts
    }
    
    func searchContactWithIdentifier(identifier : String) -> CNContact? {
       let store = CNContactStore()
        // CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactOrganizationNameKey
        let keysToFetch = [CNContactGivenNameKey, CNContactEmailAddressesKey]
        
        var contact : CNContact?
        
        do {
             contact = try store.unifiedContactWithIdentifier(identifier, keysToFetch: keysToFetch)
        } catch {
            print("Eception raised")
        }
        
        return contact
    }
}

