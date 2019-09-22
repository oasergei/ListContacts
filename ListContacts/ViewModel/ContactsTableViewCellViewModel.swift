//
//  ContactsTableViewCellViewModel.swift
//  ListContacts
//
//  Created by Sergey on 15.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

class ContactTableViewCellViewModel: ContactTableViewCellViewModelType {
    
    private var contact: ContactRealm
    
    init(contact: ContactRealm) {
        self.contact = contact
    }
    
    var name: String {
        return contact.name
    }
    
    var telephone: String {
        return contact.phone.applyPatternOnNumbers(pattern: "+# ### ###-##-##", replacmentCharacter: "#")
    }
    
    var temperament: String {
        return contact.temperament //contact.temperament.rawValue
    }
    
}
