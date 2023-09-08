//
//  petition.swift
//  Project7 - Whitehouse Petitions
//
//  Created by Mina Thabet on 27/08/2023.
//

import Foundation
struct Petition : Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
