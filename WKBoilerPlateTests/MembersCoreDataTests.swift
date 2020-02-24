//
//  MembersCoreDataTests.swift
//  WKBoilerPlateTests
//
//  Created by Brian on 03/01/20.
//  Copyright © 2020 WeKan. All rights reserved.
//

@testable import Alamofire
import Foundation
@testable import OHHTTPStubs
@testable import WKBoilerPlate
import XCTest

class MembersCoreDataTests: XCTestCase {
    var viewModel: CoreDataMembersViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CoreDataMembersViewModel()
        super.setUp()
    }

   override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    /// Test whether our server is accessible
    func testServerReachability() {
        let testHost = AppConfig.getActiveBaseURL()
        guard let reachable = NetworkReachabilityManager(host: testHost)?.isReachable else {
            XCTAssert(false)
            return
        }
        XCTAssert(reachable)
    }

    /// Test API success handling using a mock json
    func testGetAllUsersSuccessHandling() {
        OHHTTPStubs.setEnabled(true)
        let stubbedJSON: [String: Any] =
            ["data":
                ["users":
                    [
                        [
                            "email": "brianc@wekan.company",
                            "firstName": "aaaa",
                            "lastName": "cccc"
                        ],
                        [
                            "email": "alex@pettifer.com",
                            "firstName": "Alex",
                            "lastName": "pet tiger"
                        ],
                        [
                            "email": "brianc@wekancode.com",
                            "firstName": "Brian",
                            "lastName": "Christo"
                        ]
                    ]
                ]
        ]

        let testHost = AppConfig.BaseUrl.TESTHOST
        var testPath = "\(Constants.EndPoint.users)?fields=email,firstName,lastName&sort=firstName|asc"
        testPath = testPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? testPath
        let expectation = self.expectation(description: "success")
        stub(condition: isHost(testHost) && isPath(testPath)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: stubbedJSON,
                statusCode: 200,
                headers: nil
            )
        }
        viewModel.getAllUsers(onSuccess: { _ in
            expectation.fulfill()
            XCTAssert(true)
        }, onFailure: { _ in
            XCTAssert(false)
        })
        self.waitForExpectations(timeout: kTimeOutInterval) { _ in
            XCTAssert(true)
        }
        OHHTTPStubs.removeAllStubs()
    }

    /// Test API response handling for empty list or empty array
    func testGetAllUsersEmptyHandling() {
        let testHost = AppConfig.BaseUrl.TESTHOST
        var testPath = "\(Constants.EndPoint.users)?fields=email,firstName,lastName&sort=firstName|asc"
        testPath = testPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? testPath
        let stubbedJSON = ["data": ["users": []]]
        stub(condition: isHost(testHost) && isPath(testPath)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: stubbedJSON,
                statusCode: 200,
                headers: nil
            )
        }
        viewModel.getAllUsers(onSuccess: { users in
            XCTAssertEqual((users as? [Any])?.count, 0)
        }, onFailure: { _ in
            XCTAssert(false)
        })
        OHHTTPStubs.removeAllStubs()
    }

    // Test API failure handling for no network
    func testGetAllUsersFailureHandling() {
        let testHost = AppConfig.BaseUrl.TESTHOST
        let testPath = "\(Constants.EndPoint.users)?fields=email,firstName,lastName&sort=firstName|asc"
        let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
        stub(condition: isHost(testHost) && isPath(testPath)) { _ in
            return OHHTTPStubsResponse(error: notConnectedError)
        }
        let expectations = expectation(description: notConnectedError.localizedFailureReason ?? notConnectedError.localizedDescription)
        viewModel.getAllUsers(onSuccess: { users in
            print(users)
            XCTAssert(false)
        }, onFailure: { errorMsg in
            XCTAssertEqual(errorMsg, "Please check your internet connection")
            expectations.fulfill()
        })
        waitForExpectations(timeout: kTimeOutInterval) { _ in
            XCTAssert(false)
        }
        OHHTTPStubs.removeAllStubs()
    }

    /// Test the slow network handling for Get all users API call
    func testLowNetworkHandlingForGetAllUsersAPI() {
        let testHost = AppConfig.BaseUrl.TESTHOST
        let testPath = "\(Constants.EndPoint.users)?fields=email,firstName,lastName&sort=firstName|asc"
        let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
        stub(condition: isHost(testHost) && isPath(testPath)) { _ in
            return OHHTTPStubsResponse(data: Data(), statusCode: 400, headers: nil).responseTime(OHHTTPStubsDownloadSpeed3G)
        }
        let expectations = expectation(description: notConnectedError.localizedFailureReason ?? notConnectedError.localizedDescription)
        viewModel.getAllUsers(onSuccess: { users in
            print(users)
        }, onFailure: { errorMsg in
            XCTAssertEqual(errorMsg, "Please check your internet connection")
            expectations.fulfill()
        })
        waitForExpectations(timeout: kTimeOutInterval) { _ in
            XCTAssert(true)
        }
        OHHTTPStubs.removeAllStubs()
        OHHTTPStubs.stubRequests(passingTest: { _ -> Bool in
            return true
        }, withStubResponse: { _ -> OHHTTPStubsResponse in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return OHHTTPStubsResponse(error: notConnectedError)
        })
    }
}
