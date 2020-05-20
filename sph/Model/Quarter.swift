//
//  Quarter.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Quarter: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var year: Int = 0
    @objc dynamic var quarterName: String = ""
    @objc dynamic var volume: Float = 0.0
    @objc dynamic var isDecrease: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
