//
//  APIManagerTest.swift
//  sphTests
//
//  Created by Sujewan Vijayakumar on 5/20/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import XCTest
@testable import SPH
@testable import Alamofire
@testable import Mocker

class APIManagerTests: XCTestCase {

    private var manager: APIManager!

    override func setUp() {
        let sessionManager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        manager = APIManager(manager: sessionManager)
    }

    func testGetMobileDataUsage_whenMockSuccessStatusCode_thenChekResponse() {
        // given
        let apiEndpoint = URL(string: APIRouter.getMobileDataUsage.path)!
        let requestExpectation = expectation(description: "Request should finish with Mobile Data Usage")
        let responseFile = "get_data_usage"
        
        // when
        guard let mockedData = dataFromTestBundleFile(fileName: responseFile, withExtension: "json") else {
            XCTFail("Error from JSON DeSerialization.jsonObject")
            return
        }
        guard let mockResponse = try? JSONDecoder().decode(DataUsageResponse.self, from: mockedData) else {
            XCTFail("Error from JSON DeSerialization.jsonObject")
            return
        }
        
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()

        // then
        manager.getMobileDataUsage { (result) in
            XCTAssertEqual(result.result.success!, mockResponse)
            XCTAssertNil(result.error)
            XCTAssertEqual(result.result.isSuccess, true)
            XCTAssertEqual(result.result.self.success?.result.records.count, 59)
            requestExpectation.fulfill()
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testGetMobileDataUsage_whenNetworkFailure_thenChekResponse() {
        // given
        let apiEndpoint = URL(string: APIRouter.getMobileDataUsage.path)!
        let requestExpectation = expectation(description: "401 Exception")

        // when
        let emptyData = "".data(using: .utf8)!
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 401, data: [.get: emptyData])
        mock.register()

        // then
        let dataTask = URLSession.shared.dataTask(with: apiEndpoint) { (data, response, _) in
            XCTAssertNotNil(response as? HTTPURLResponse)
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            XCTAssertEqual(httpResponse.statusCode, 401)
            XCTAssertNotNil(data)

            requestExpectation.fulfill()
        }
        dataTask.resume()
        wait(for: [requestExpectation], timeout: 10.0)
    }

    func dataFromTestBundleFile(fileName: String, withExtension fileExtension: String) -> Data? {

        let testBundle = Bundle(for: APIManagerTests.self)
        let resourceUrl = testBundle.url(forResource: fileName, withExtension: fileExtension)!
        do {
            let data = try Data(contentsOf: resourceUrl)
            return data
        } catch {
            XCTFail("Error reading data from resource file \(fileName).\(fileExtension)")
            return nil
        }
    }

}
