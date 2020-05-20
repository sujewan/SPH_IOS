//
//  RealmManager.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/19/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmManager {
    let realm = try! Realm()

    func getRecordsFromDB() -> [YearlyRecord]{
        let recordsFromDB = realm.objects(YearlyRecord.self).toArray(ofType: YearlyRecord.self) as [YearlyRecord]
        return recordsFromDB
    }
    
    func storeRecordsIntoDB(newRecords: [YearlyRecord]) {
        try! self.realm.write {
            self.realm.add(newRecords, update: .all)
        }
    }
}
