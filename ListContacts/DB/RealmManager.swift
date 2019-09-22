//
//  RealmManager.swift
//  ListContacts
//
//  Created by Sergey on 19.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    let database: Realm = try! Realm()
    
    func getDataFromDb(predicate: NSPredicate? = nil) -> Results<ContactRealm> {
        let result: Results<ContactRealm> = predicate == nil ? database.objects(ContactRealm.self).sorted(byKeyPath: "name") : database.objects(ContactRealm.self).filter(predicate!).sorted(byKeyPath: "name")
        return result
    }
    
    func addDataToDb(object: ContactRealm) {
        try! database.write {
            database.add(object)
        }
    }
    
    func deleteFromDb(object: ContactRealm) {
        try! database.write {
            database.delete(object)
        }
    }
    
    func updateTask(contact: ContactRealm) {
        try! database.write {
            database.add(contact, update: .modified) //.all
        }
    }
    
    func deleteAllFromDb() {
        try! database.write {
            database.deleteAll()
        }
    }
}
