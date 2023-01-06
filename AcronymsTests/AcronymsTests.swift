//
//  AcronymsTests.swift
//  AcronymsTests
//
//  Created by Manidhar Gupta Chittanuri on 1/6/23.
//

import XCTest
@testable import Acronyms

class AcronymsTests: XCTestCase {
    
    var testInstance: ViewController!
    var feedModel: AcronymsSFFeed!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        let varsObj = VarsObject(lf: "full form", freq: 2, since: 1985)
        let lfsObj = LfsObject(lf: "full form", freq: 2, since: 1985, vars:[varsObj])
        feedModel = AcronymsSFFeed(sf: "TestSF", lfs: [lfsObj])
        
        testInstance = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "searchVC") as? ViewController
        _ = testInstance.view
        testInstance.lfs = feedModel.lfs
        testInstance.tableView.reloadData()
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        feedModel = nil
    }
    func test_numberOfRows_ShouldExists() {
        if self.feedModel.lfs.count > 0 {
            let numberOfRows = self.testInstance.tableView.numberOfRows(inSection: 0)
            XCTAssert(numberOfRows >= 1, "table view should have cells")
        } else {
            XCTAssert(self.feedModel.lfs.count == 0, "No explore models exists")
        }
    }
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        if self.feedModel.lfs.count > 0 {
            let firstCell = self.testInstance.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            
            XCTAssert(firstCell?.textLabel?.text?.count ?? 0 > 0, "title should not be blank")
        } else {
            XCTAssert(self.feedModel.lfs.count == 0, "No explore models exists")
        }
    }
    func testAlert() {
        AlertVC.sharedInstance.presentAlert(on: testInstance, with: "Test", message: "sample  message", buttonTitle: "OK")
    }
    func testPerformSearchOperation() {
        testInstance.searchBar.text = "icu"
        XCTAssertNotNil(testInstance.performSearchOperation())
    }
    func testHandleSuccess() {
        XCTAssertNotNil(testInstance.handleSuccess(with: [feedModel], searchText: "icu"))
    }
    func testReset() {
        XCTAssertNotNil(testInstance.resetSearch())
    }
}
