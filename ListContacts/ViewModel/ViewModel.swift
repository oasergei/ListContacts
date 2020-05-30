//
//  ViewModel.swift
//  ListContacts
//
//  Created by Sergey on 15.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class ViewModel: ContactsTableViewViewModelType {
    
    private let database: RealmManager = RealmManager()
    private var contactsDB = [ContactRealm]()
    private var selectedIndexPath: IndexPath?
    
    func numberOfRows() -> Int {
        return contactsDB.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableViewCellViewModelType? {
        let contact = contactsDB[indexPath.row]
        return ContactTableViewCellViewModel(contact: contact)
    }
    
    func loadContactsFromDB(completion: @escaping (Result<[Contact], Error>) -> ()) {
        
        self.contactsDB = Array(database.getDataFromDb())
        
        if self.contactsDB.count == 0 {
            self.fetchContacts { result in
                completion(result)
            }
        } else {
            completion(.success([]))
        }
    }
    
    func fetchContacts(completion: @escaping (Result<[Contact], Error>) -> ()) {

        let networkManager = NetworkManager()
       
        //DispatchQueue.global(qos: .userInteractive).async {
            
            networkManager.fetchContacts { [weak self] result in
                
                switch result {
                case .success(let contacts):
                    let database: RealmManager = RealmManager()
                    
                    for contact in contacts {
                        let contactRealm = ContactRealm()
                        contactRealm.fillData(with: contact)
                        database.updateTask(contact: contactRealm)
                    }
                    
                    DispatchQueue.main.async {
                        let database: RealmManager = RealmManager()
                        self?.contactsDB = Array((database.getDataFromDb()))
                        completion(.success([]))
                    }
                case  .failure(_):
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
        //}
    }
    
    func searchContacts(predicate: NSPredicate) {
        self.contactsDB = Array(database.getDataFromDb(predicate: predicate))
    }
    
    func viewModelForSelectedRow() -> DetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return DetailViewModel(contact: Array(contactsDB)[selectedIndexPath.row])
    }
    
    func selectRow(indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
}
