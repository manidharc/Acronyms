//
//  VMTests.swift
//  AcronymsTests
//
//  Created by Manidhar Gupta Chittanuri on 1/6/23.
//

import XCTest
@testable import Acronyms

class VMTests: XCTestCase {

    var viewModel: AcronymsViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = AcronymsViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetFullForms() {
        viewModel.getFullForms(searchKey: "icu") { result in
                switch result {
                case .success(let feed):
                    XCTAssert((feed.first?.lfs.count)!>0, "Full forms exists")
                case .failure(let error):
                    XCTAssertNil(error, "Received an error while fetching full forms")
                }
            }
    }
    func testReachability() {
        XCTAssertTrue(Reachability.isConnectedToNetwork())
    }
    
    func testSearchAPI() {
        let expectation = self.expectation(description: "Getting full forms")
        let url = URL(string: "http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=icu")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? HTTPURLResponse,
               let responseURL = HTTPResponse.url
            {
                XCTAssertEqual(responseURL.absoluteString, url.absoluteString, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            expectation.fulfill()
        }
        task.resume()
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
}
