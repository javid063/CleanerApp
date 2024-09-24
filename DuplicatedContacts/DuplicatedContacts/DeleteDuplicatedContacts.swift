//
//  DeleteDuplicatedContacts.swift
//  DuplicatedContacts
//
//  Created by Javid on 22.09.24.
//

import Foundation
import Contacts

func deleteContact(contact: CNContact) {
    let store = CNContactStore()

    let request = CNSaveRequest()
    let mutableContact = contact.mutableCopy() as! CNMutableContact
    request.delete(mutableContact)

    do {
        try store.execute(request)
    } catch {
        print("Error: \(error)")
    }
}

func deleteDuplicateContacts() {
    let contacts = fetchContacts()
    let duplicateContacts = findDuplicateContacts(contacts: contacts)

    for contactGroup in duplicateContacts {
        for contact in contactGroup.dropFirst() { // İlk kişiyi korur, diğerlerini siler
            deleteContact(contact: contact)
        }
    }
}

