//
//  NetworkManager.swift
//  ListContacts
//
//  Created by Sergey on 17.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

enum ServerResult {
    case success([Contact])
    case error(String)
}

class NetworkManager {
    
    private let baseURL = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/"
    private let getFirstPath =  "generated-01.json"
    private let getSecondPath = "generated-02.json"
    private let getThirdPath =  "generated-03.json"
    
    private var urls: [String] {
        return [baseURL + getFirstPath, baseURL + getSecondPath, baseURL + getThirdPath]
    }

    func fetchContacts(completion: @escaping (ServerResult) -> ()) {
        var contacts = [Contact]()
        let group = DispatchGroup()
        
        for url in urls {
            
            group.enter()
            
            guard let urlServer = URL(string: url) else {
                print("url is wrong")
                group.leave()
                return
            }
            
            URLSession.shared.dataTask(with: urlServer) { (data, response, error) in
                guard let data = data, response != nil, error == nil else {
                    print("something is wrong")
                    group.leave()
                    return
                }
                
                do {
                    
                    let partContacts = try JSONDecoder().decode([Contact].self, from: data)
                    contacts += partContacts
                    
                    group.leave()
                    
                } catch let err {
                    print("error getJSONContent is \(err)")
                    //completion(ServerResult.error(err.localizedDescription))
                    group.leave()
                }
            }.resume()
            
            group.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                print("contacts.count: \(contacts.count)")
                completion(ServerResult.success(contacts))
            }
            
        }
    }
}
