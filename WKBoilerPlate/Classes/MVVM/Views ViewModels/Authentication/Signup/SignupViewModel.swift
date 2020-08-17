//
//  SignupViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 01/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import UIKit

class SignupViewModel {
    var user: Dynamic<User>

    init() {
        self.user = Dynamic(User())
    }

    /// Function to validate the signup form on tapping submit button
    func validateForm(success onTaskSuccess: @escaping OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let firstName = self.user.value.firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let lastName = self.user.value.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = self.user.value.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = self.user.value.password?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if firstName.isEmpty && lastName.isEmpty && email.isEmpty {
            onFailure("Please enter all the fields")
            return
        }
        if firstName.isEmpty {
            onFailure("Please enter the first name")
            return
        }
        if lastName.isEmpty {
            onFailure("Please enter the last name")
            return
        }
        if email.isEmpty {
            onFailure("Please enter the email")
            return
        }
        if password.isEmpty {
            onFailure("Please enter the password")
            return
        }
        if firstName.count > Maximum.firstNameLength {
            onFailure("First name exceeded its maximum limit of length")
            return
        }
        if lastName.count > Maximum.lastNameLength {
            onFailure("Last name exceeded its maximum limit of length")
            return
        }
        if email.count > Maximum.emailLength {
            onFailure("Email exceeded its maximum limit of length")
            return
        }
        if password.count > Maximum.passwordLength {
            onFailure("Password exceeded its maximum limit of length")
            return
        }
        if firstName.isValidName() == false {
            onFailure("First name is in invalid format")
            return
        }
        if lastName.isValidName() == false {
            onFailure("Last name is in invalid format")
            return
        }
        if email.isValidEmail() == false {
            onFailure("Email is in invalid format")
            return
        }
        if password.isValidPassword() == false {
            onFailure("Password validation alert".localizeText())
            return
        }
        onTaskSuccess(true)
    }

    // MARK: - API calls

    /**
     API call for Signup using email
     - method : POST
     - request params: first and last name, email, password, profile image
     */
    func emailSignup(onSuccess success: @escaping OnSuccess,
                     onFailure failure: @escaping OnFailure,
                     onValidationFailure validation: @escaping OnFailure) {
        validateForm(success: { _ in
            let encodedData = try? JSONEncoder().encode(self.user.value)
            let requestParams = try? JSONSerialization.jsonObject(with: encodedData ?? Data(), options: .allowFragments)
            print(requestParams as Any)
            NetworkHandler.apiRequest(endPoint: EndPoint.users,
                                      paramData: encodedData,
                                      method: .post,
                                      onSuccess: { (responseDict) in
                print(responseDict)
                let respData = responseDict["data"] as? [String: Any]
                let userInfo = respData?["user"] as? [String: Any]
                UserDefaults.standard.set(userInfo?["_id"], forKey: Defaults.userId)
                success("Success")
            }, onFailure: { errorMsg, _ in
                print(errorMsg)
                failure(errorMsg)
            })
        }, failure: { validationMessage in
            validation(validationMessage)
        })
    }
}
