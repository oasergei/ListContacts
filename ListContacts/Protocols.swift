//
//  protocols.swift
//  ListContacts
//
//  Created by Sergey on 15.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

protocol ContactsTableViewViewModelType {
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableViewCellViewModelType?
    func fetchContacts(completion: @escaping (ServerResult) -> ())
    func loadContactsFromDB(completion: @escaping (ServerResult) -> ())
    func searchContacts(predicate: NSPredicate)
    func viewModelForSelectedRow() -> DetailViewModelType?
    func selectRow(indexPath: IndexPath)
}

protocol ContactTableViewCellViewModelType: class {
    var name: String { get }
    var telephone: String { get }
    var temperament: String { get }
}

protocol DetailViewModelType {
    var name: String { get }
    var telephone: String { get }
    var temperament: String { get }
    var educationPeriod: String { get }
    var biography: String { get }
}
