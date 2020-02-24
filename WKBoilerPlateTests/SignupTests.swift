//
//  SignupTests.swift
//  WKBoilerPlateTests
//
//  Created by Brian on 16/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

@testable import WKBoilerPlate
import XCTest

class SignupTests: XCTestCase {
    var signupViewModel: SignupViewModel!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        signupViewModel = SignupViewModel()
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        signupViewModel = nil
    }

    /// Test to check whether validation error is thrown when all fields are left empty and signup is tapped
    func testAllFieldsEmpty() {
        signupViewModel.user.value.firstName = ""
        signupViewModel.user.value.lastName = ""
        signupViewModel.user.value.email = ""
        signupViewModel.user.value.password = ""
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test to check if first name is empty
    func testFirstNameFieldEmpty() {
        signupViewModel.user.value.firstName = ""
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for empty last name field
    func testLastNameFieldEmpty() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = ""
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for empty email field
    func testEmailFieldEmpty() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = ""
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for empty password field
    func testPasswordFieldEmpty() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = ""
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for first name maximum length validation
    func testFirstNameMaximumLengthValidation() {
        signupViewModel.user.value.firstName = "Anhdnhdfrgthajk ijkasdk"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for invalid format of first name
    func testFirstNameInvalidFormat() {
        signupViewModel.user.value.firstName = "Anhfrg239nas12"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for last name maximum length exceeded
    func testLastNameMaximumLengthValidation() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathewhsjabusbhjknalkj"
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for invalid format of last name
    func testLastNameInvalidFormat() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "1ikdfokl"
        signupViewModel.user.value.email = "jon@gmail.com"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for email maximum length exceeded
    func testEmailMaximumLengthValidation() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "johjsdkanlMfdxgcASHUBJNKUBJKNCASRKLAGXhkacsgahoihiohoiugfASOUGAasgjbknbbijksa.shbjknlcn@gmail.comusbajknx"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for invalid format of email
    func testEmailInvalidFormat() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@sjka"
        signupViewModel.user.value.password = "Aaaa@1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for password maximum length exceeded
    func testPasswordMaximumLengthValidation() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@sjka"
        signupViewModel.user.value.password = "Aaaa@1111bedinkqldwcdsbc nkljax"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test case for invalid format of password
    func testPasswordInvalidFormat() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "jon@sjka"
        signupViewModel.user.value.password = "aaaa1111"
        signupViewModel.validateForm(success: { success in
            XCTAssertTrue(success == false)
        }, failure: { errorMsg in
            XCTAssertTrue(!errorMsg.isEmpty)
        })
    }

    /// Test to check if the Signup API succeeds with all values given correctly
    func testSignupAPIsuccess() {
        signupViewModel.user.value.firstName = "John"
        signupViewModel.user.value.lastName = "Mathew"
        signupViewModel.user.value.email = "johny@sjka.coomjjk"
        signupViewModel.user.value.password = "Aaaa@1111"

        let idExpectation = expectation(description: "Success")
        var successResponse: String?
        signupViewModel.emailSignup(onSuccess: { successMsg in
            successResponse = successMsg as? String
            idExpectation.fulfill()
        }, onFailure: { _ in
            XCTAssert(false)
        }, onValidationFailure: { _ in
            XCTAssert(false)
        })
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(successResponse)
        }
    }

    /// Test to check if Signup API fails when an existing user's email is used for signup
    func testSignupAPIFailureCaseUserAlreadyExists() {
        signupViewModel.user.value.firstName = "Brian"
        signupViewModel.user.value.lastName = "Chris"
        signupViewModel.user.value.email = "brianc@wekancode.com"
        signupViewModel.user.value.password = "Aaaa1111"

        let errorExpectation = expectation(description: "error")
        var errorResponse: String?

        signupViewModel.emailSignup(onSuccess: { _ in
            XCTAssert(false)
        }, onFailure: { errorMsg in
            errorResponse = errorMsg
            errorExpectation.fulfill()
        }, onValidationFailure: { _ in
            XCTAssert(true)
        })
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(errorResponse)
        }
    }
}
