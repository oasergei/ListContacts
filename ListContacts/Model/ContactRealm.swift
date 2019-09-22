//
//  ContactRealm.swift
//  ListContacts
//
//  Created by Sergey on 12.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class ContactRealm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var height: Float = 0
    @objc dynamic var biography: String = ""
    @objc dynamic var temperament: String = ""
    @objc dynamic var startPeriod: String = ""
    @objc dynamic var endPeriod: String = ""
    
    override static func primaryKey() -> String? {return "id"}
    
    func fillData(with contact: Contact) {
        id = contact.id
        name = contact.name
        phone = contact.phone.normalizePhoneNumber()
        height = contact.height
        biography = contact.biography
        temperament = Temperament(rawValue: contact.temperament)?.description ?? Temperament.notInit.rawValue.description
        startPeriod = contact.educationPeriod.start
        endPeriod = contact.educationPeriod.end
    }
}

