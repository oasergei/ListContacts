//
//  Contact.swift
//  ListContacts
//
//  Created by Sergey on 12.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

struct Contact: Decodable {
    let id: String
    let name: String
    let height: Float
    let biography: String
    let temperament: String
    let educationPeriod: PeriodEducation
    let phone: String
}

struct PeriodEducation: Decodable {
    let start: String
    let end: String
}

enum Temperament: String {
    case melancholic = "melancholic"
    case phlegmatic = "phlegmatic"
    case sanguine = "sanguine"
    case choleric = "choleric"
    case notInit = ""
    
    var description: String{
        switch self {
        case .melancholic:
            return "Melancholic"
        case .phlegmatic:
            return "Phlegmatic"
        case .sanguine:
            return "Sanguine"
        case .choleric:
            return "Choleric"
        case .notInit:
            return ""
        }
    }
}

