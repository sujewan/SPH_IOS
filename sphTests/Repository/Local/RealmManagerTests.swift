//
//  RealmManagerTests.swift
//  sphTests
//
//  Created by Sujewan Vijayakumar on 5/20/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SPH


class RealmManagerTests: XCTestCase {
    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
    }

    func test_WhenDataStoreIntoLocalDB_ThenCheckSavedData() {
        // given
        realm = try! Realm()
        
        // then
        try! realm.write {
            realm.add(records, update: .all)
        }
        
        // when
        let tasks = try! Realm().objects(YearlyRecord.self).toArray(ofType: YearlyRecord.self)
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks[0].year, records[0].year)
        XCTAssertEqual(tasks[0].totalVolume, records[0].totalVolume)
        XCTAssertEqual(tasks[0].quarters[0].id, records[0].quarters[0].id)
        XCTAssertEqual(tasks[0].quarters[1].id, records[0].quarters[1].id)
        XCTAssertEqual(tasks[0].quarters[2].id, records[0].quarters[2].id)
        
        XCTAssertEqual(tasks[1].year, records[1].year)
        XCTAssertEqual(tasks[1].totalVolume, records[1].totalVolume)
        XCTAssertEqual(tasks[1].quarters[0].id, records[1].quarters[0].id)
        XCTAssertEqual(tasks[1].quarters[1].id, records[1].quarters[1].id)
        XCTAssertEqual(tasks[1].quarters[2].id, records[1].quarters[2].id)
    }
    
    func test_WhenDataStoreMultipleTimeIntoLocalDB_ThenCheckDataDuplicatedOrNot() {
        // given
        realm = try! Realm()
        
        // then
        try! realm.write {
            realm.add(records, update: .all)
            realm.add(records, update: .all)
            realm.add(records, update: .all)
            realm.add(records, update: .all)
            realm.add(records, update: .all)
        }
        
        // when
        let tasks = try! Realm().objects(YearlyRecord.self)
        XCTAssertEqual(tasks.count, 2)
    }
    
    let records: [YearlyRecord] = {
        let quartes01 = Quarter()
        quartes01.id = 1
        quartes01.year = 2015
        quartes01.quarterName = "Quarter 01"
        quartes01.volume = 9.687363
        quartes01.isDecrease = false
        
        let quartes02 = Quarter()
        quartes02.id = 2
        quartes02.year = 2015
        quartes02.quarterName = "Quarter 02"
        quartes02.volume = 9.98677
        quartes02.isDecrease = false
        
        let quartes03 = Quarter()
        quartes03.id = 3
        quartes03.year = 2015
        quartes03.quarterName = "Quarter 03"
        quartes03.volume = 10.902194
        quartes03.isDecrease = false
        
        let quartes04 = Quarter()
        quartes04.id = 4
        quartes04.year = 2015
        quartes04.quarterName = "Quarter 04"
        quartes04.volume = 10.677166
        quartes04.isDecrease = true
        
        let record01 = YearlyRecord()
        record01.year = 2015
        record01.totalVolume = 41.253494
        record01.isDecreasedYear = true
        record01.quarters.append(objectsIn: [quartes01, quartes02, quartes03, quartes04])
        
        let record02 = YearlyRecord()
        record02.year = 2009
        record02.totalVolume = 6.228985
        record02.isDecreasedYear = true
        record02.quarters.append(objectsIn: [quartes01, quartes02, quartes03, quartes04])
        return [record01, record02]
    }()
    
}
