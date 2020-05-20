//
//  YearlyRecord.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class YearlyRecord: Object {
    @objc dynamic var year: Int = 0
    @objc dynamic var totalVolume: Float = 0.0
    @objc dynamic var isDecreasedYear: Bool = false
    var quarters = List<Quarter>()
    
    override static func primaryKey() -> String? {
        return "year"
    }
}
