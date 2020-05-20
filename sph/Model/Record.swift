//
//  Record.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation

struct Record: Codable, Equatable {
    let id: Int
    let quarter: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case quarter = "quarter"
        case volume = "volume_of_mobile_data"
    }

    static func == (lhs: Record, rhs: Record) -> Bool {
        return (lhs.id == rhs.id)
    }
}
