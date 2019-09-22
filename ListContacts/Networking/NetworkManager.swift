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

class NetworkManager: NSObject {
    
    private let baseURL = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/"
    private let getFirstPath =  "generated-01.json"
    private let getSecondPath = "generated-02.json"
    private let getThirdPath =  "generated-03.json"
    
    private var urls: [String] {
        return [baseURL + getFirstPath, baseURL + getSecondPath, baseURL + getThirdPath]
    }

    func fetchContacts(completion: @escaping (ServerResult) -> ()) {
        var contacts = [Contact]()
        
        for url in urls {
            
            guard let urlServer = URL(string: url) else {
                completion(ServerResult.error("url is wrong"))
                return
            }
            
            URLSession.shared.dataTask(with: urlServer) { (data, response, error) in
                guard let data = data, response != nil, error == nil else {
                    print("something is wrong")
                    completion(ServerResult.error("something is wrong"))
                    return
                }
                
                do {
                    
                    let partContacts = try JSONDecoder().decode([Contact].self, from: data)
                    contacts += partContacts
                    
                    if url == self.urls.last {
                        completion(ServerResult.success(contacts))
                    }
                    
                } catch let err {
                    print("error getJSONContent is \(err)")
                    completion(ServerResult.error(err.localizedDescription))
                }
            }.resume()
        }
    }
}
