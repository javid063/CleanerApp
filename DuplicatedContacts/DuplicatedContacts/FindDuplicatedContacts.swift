//
//  findDuplicatedContacts.swift
//  DuplicatedContacts
//
//  Created by Javid on 22.09.24.
//

import Foundation
import Contacts

func findDuplicateContacts(contacts: [CNContact]) -> [[CNContact]] {
    var groupedContacts = [[CNContact]]()

    let groupedByPhone = Dictionary(grouping: contacts) { (contact) -> String in
        return contact.phoneNumbers.first?.value.stringValue ?? ""
    }

    for (_, contactGroup) in groupedByPhone {
        if contactGroup.count > 1 {
            groupedContacts.append(contactGroup)
        }
    }
    
    return groupedContacts
}

