//
//  File.swift
//  DuplicatedContacts
//
//  Created by Javid on 22.09.24.
//

import Foundation
import Contacts

func fetchContacts() -> [CNContact] {
    let store = CNContactStore()
    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    let request = CNContactFetchRequest(keysToFetch: keys)

    var contacts: [CNContact] = []

    do {
        try store.enumerateContacts(with: request) { (contact, stop) in
            contacts.append(contact)
        }
    } catch {
        print("Error: \(error)")
    }

    return contacts
}
