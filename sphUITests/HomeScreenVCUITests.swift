//
//  HomeScreenVCUITests.swift
//  sphUITests
//
//  Created by Sujewan Vijayakumar on 5/20/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import XCTest

class HomeScreenVCUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

   func test_TitleExists() {
        XCTAssert(app.staticTexts["Mobile Data Usage"].exists)
    }

    func test_ForCellExistence() {
        let detailstable = app.tables.matching(identifier: "TableView_Records")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_0")
        let existencePredicate = NSPredicate(format: "exists == 1")
        let expectationEval = expectation(for: existencePredicate, evaluatedWith: firstCell, handler: nil)
        let mobWaiter = XCTWaiter.wait(for: [expectationEval], timeout: 10.0)
        XCTAssert(XCTWaiter.Result.completed == mobWaiter, "Test Case Failed.")
    }
    
    func test_ForCellSelection() {
        let detailstable = app.tables.matching(identifier: "TableView_Records")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_0")
        let predicate = NSPredicate(format: "isHittable == true")
        let expectationEval = expectation(for: predicate, evaluatedWith: firstCell, handler: nil)
        let waiter = XCTWaiter.wait(for: [expectationEval], timeout: 10.0)
        XCTAssert(XCTWaiter.Result.completed == waiter, "Test Case Failed.")
        firstCell.tap()
    }
    
    func test_LabelExistenceOnTableView() {
        let detailstable = app.tables.matching(identifier: "TableView_Records")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_0")
        XCTAssertTrue(firstCell.exists, "Table view cell not exist.")

        let lblYearTitle = firstCell.staticTexts["lblYearTitle"]
        XCTAssertTrue(lblYearTitle.exists, "Label Year Title not exist.")

        let lblVolumeTitle = firstCell.staticTexts["lblVolumeTitle"]
        XCTAssertTrue(lblVolumeTitle.exists, "Label Volume Title not exist.")

        let lblYear = firstCell.staticTexts["lblYear"]
        XCTAssertTrue(lblYear.exists, "Label Year not exist.")

        let lblVolume = firstCell.staticTexts["lblVolume"]
        XCTAssertTrue(lblVolume.exists, "Label Volume not exist.")
    }
    
    func test_ForImageViewExistence() {
        let imgAlertIcon = app.otherElements.containing(.image, identifier: "imgAlertIcon").firstMatch
        XCTAssertTrue(imgAlertIcon.exists, "Image Alert icon not exist.")
    }
    
    func test_ForStripeViewExistence() {
        let viewStripe = app.otherElements.containing(.other, identifier: "viewStripe").firstMatch
        XCTAssertTrue(viewStripe.exists, "Stripe View not exist.")
    }
    
    func test_ForAlertIconHidden_WhenIsNotADecreasedYear() {
        let detailstable = app.tables.matching(identifier: "TableView_Records")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_0")

        let imgAlertIcon = firstCell.otherElements.containing(.image, identifier: "imgAlertIcon").firstMatch
        XCTAssertTrue(!imgAlertIcon.exists, "Image Alert icon should hidden in the first cell based on data.")
    }
    
    func test_ForAlertIconShow_WhenIsADecreasedYear() {
        let detailstable = app.tables.matching(identifier: "TableView_Records")
        
        let fourthCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_3")
        let imgAlertIcon = fourthCell.otherElements.containing(.image, identifier: "imgAlertIcon").firstMatch
        XCTAssertTrue(imgAlertIcon.exists, "Image Alert icon should visible in the first cell based on data.")
    }
}
