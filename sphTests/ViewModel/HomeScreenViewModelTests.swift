//
//  HomeScreenViewModelTests.swift
//  sphTests
//
//  Created by Sujewan Vijayakumar on 5/20/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import XCTest
@testable import SPH

class HomeScreenViewModelTests: XCTestCase {
    
    private enum DataUsageRepositoryError: Error {
        case someError
    }

    class DataUsageRepositoryMock: DataUsageRepository {
        var expectation: XCTestExpectation?
        var error: Error?
        var yearlyRecord = [YearlyRecord]()

        override func execute(cached: @escaping ([YearlyRecord]) -> Void,
                     completion: @escaping (Result<[YearlyRecord], Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(yearlyRecord))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_WhenDataUsageRepositoryRetrievesData_ThenViewModelContainsThoseData() {
        // given
        let dataUsageRepositoryMock = DataUsageRepositoryMock(apiManager: APIManager())
        dataUsageRepositoryMock.expectation = self.expectation(description: "contains yearly records data")
        dataUsageRepositoryMock.yearlyRecord = records
        let viewModel = DefaultHomeScreenViewModel(dataUsageUseCase: dataUsageRepositoryMock)
        
        // when
        viewModel.viewDidLoad()

        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertEqual(viewModel.items.value.count, records.count)
        XCTAssertEqual(viewModel.items.value.first?.year, records.first?.year.description)
        XCTAssertEqual(viewModel.items.value.last?.year, records.last?.year.description)
        XCTAssertEqual(viewModel.items.value.first?.volume, records.first?.totalVolume.description)
        XCTAssertEqual(viewModel.items.value.last?.volume, records.last?.totalVolume.description)
    }

    func test_WhenDataUsageRepositoryReturnsError_ThenViewModelContainsError() {
        // given
        let dataUsageRepositoryMock = DataUsageRepositoryMock(apiManager: APIManager())
        dataUsageRepositoryMock.expectation = self.expectation(description: "contain errors")
        dataUsageRepositoryMock.error = DataUsageRepositoryError.someError
        let viewModel = DefaultHomeScreenViewModel(dataUsageUseCase: dataUsageRepositoryMock)
        
        // when
        viewModel.viewDidLoad()

        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
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
