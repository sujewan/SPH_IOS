//
//  DataUsageUseCase.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/19/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

protocol DataUsageRepositoryDelegate {
    func execute(cached: @escaping ([YearlyRecord]) -> Void, completion: @escaping (Result<[YearlyRecord], Error>) -> Void) -> Cancellable?
}

class DataUsageRepository: DataUsageRepositoryDelegate {

    private let apiManager: APIManager
    private let realmManager: RealmManager

    init(apiManager: APIManager) {
        self.apiManager = apiManager
        self.realmManager = RealmManager()
    }

    func execute(cached: @escaping ([YearlyRecord]) -> Void, completion: @escaping (Result<[YearlyRecord], Error>) -> Void) -> Cancellable? {
        let recordsFromDB = realmManager.getRecordsFromDB()
        if (recordsFromDB.count > 0) {
            // Load Cache
            cached(recordsFromDB)
        }
        
        return apiManager.getMobileDataUsage { (response) in
            switch response.result {
               case .success(let response):
                   if response.success {
                        let newRecords = self.manipulateDataUsageInfo(recordList: response.result.records)
                        self.realmManager.storeRecordsIntoDB(newRecords: newRecords)
                        completion(.success(newRecords))
                   }
                   
               case .failure(let error):
                 completion(.failure(error))
            }
        }
    }
    
    func manipulateDataUsageInfo(recordList: [Record]) -> [YearlyRecord]{
        var quarterList = [Quarter]()
        var yearlyRecordList = [YearlyRecord]()

        let yearStartIndex = 2008
        let yearEndIndex = 2018
        var totalVolume: Double = 0.0
        var previousUsage: Float = 0.0
        var isDecreasedYear = false

        recordList.forEach { (record) in
            let splitArray = record.quarter.split(separator: "-")
            let year: Int = Int(String(splitArray[0])) ?? 0
            let quarterName: String = String(splitArray[1])
            let volume = Double(record.volume) ?? 0.0

            if (year >= yearStartIndex && year <= yearEndIndex) {
                let quarterObj = Quarter()
                quarterObj.id = record.id
                quarterObj.year = year
                quarterObj.quarterName = quarterName.replacingOccurrences(of: "Q", with: "Quarter 0")
                quarterObj.volume = Float(volume)
                quarterObj.isDecrease = previousUsage > Float(volume)
                quarterList.append(quarterObj)

                if(previousUsage > Float(volume)) {
                    isDecreasedYear = true
                }
                previousUsage = Float(volume)
                totalVolume += volume
                
                if ("Q4" == quarterName) {
                    
                    let recordObj = YearlyRecord()
                    recordObj.year = year
                    recordObj.totalVolume = Float(totalVolume)
                    recordObj.isDecreasedYear = isDecreasedYear
                    recordObj.quarters.append(objectsIn: quarterList)
                    
                    yearlyRecordList.append(recordObj)
                    quarterList.removeAll()
                    previousUsage = 0.0
                    totalVolume = 0.0
                    isDecreasedYear = false
                }
            }
        }

        return yearlyRecordList
    }
}
