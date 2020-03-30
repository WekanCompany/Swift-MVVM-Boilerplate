//
//  LoginViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 01/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class LoginViewModel {
    var loginModel: Dynamic<User>

    init() {
        self.loginModel = Dynamic(User())
    }
    
    /// Validates the login form
    func validateForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let email = self.loginModel.value.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = self.loginModel.value.password?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if email.isEmpty && password.isEmpty {
            onFailure("Please enter the email and password to login")
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
        if !email.isValidEmail() {
            onFailure("Please enter a valid email")
            return
        }
        onTaskSuccess(true)
    }

    // MARK: - API calls
    /**
     API call for Login using email
     - Used for Authenticating user into the app
     - method : POST
     - request params: email, password
     */
    func emailLogin(onSuccess success: @escaping OnSuccess,
                    onFailure failure: @escaping OnFailure,
                    onValidationFailure validation: @escaping OnFailure) {
        validateForm(success: { (_) in
            let encodedData = try? JSONEncoder().encode(self.loginModel.value)
            let requestParams = try? JSONSerialization.jsonObject(with: encodedData ?? Data(), options: .allowFragments)
            print(requestParams as Any)
            let endPoint = Constants.EndPoint.authentication + Constants.EndPoint.login
            NetworkHandler.apiRequest(endPoint: endPoint,
                                      paramData: encodedData,
                                      method: .post,
                                      onSuccess: { responseDict in
                    print(responseDict)
                    // Save user info singleton, if required
                    if let dataDict = responseDict["data"] as? [String: Any] {
                        let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                        let decodedData = try? JSONDecoder().decode(User.self, from: jsonData ?? Data())
                        UserManager.shared.user = decodedData
                    }
                    //save to userdefaults
                    let dataDict = responseDict["data"] as? [String: Any]
                    let userDict = dataDict?["user"] as? [String: Any]
                    UserDefaults.standard.set(userDict?["accessToken"], forKey: Constants.Defaults.authToken)
                    UserDefaults.standard.set(userDict?["email"], forKey: Constants.Defaults.userEmail)
                    UserDefaults.standard.set(userDict?["firstName"], forKey: Constants.Defaults.userFirstName)
                    UserDefaults.standard.set(userDict?["lastName"], forKey: Constants.Defaults.userLastName)
                    UserDefaults.standard.set(userDict?["refreshToken"], forKey: Constants.Defaults.userRefreshToken)
                    UserDefaults.standard.set(userDict?["tmpPassword"], forKey: Constants.Defaults.userTmpPassword)
                    let tempPwdForReset = userDict?["tmpPassword"] as? String ?? ""
                    success(tempPwdForReset.isEmpty ? "Success" : "SetPassword")
            }, onFailure: { (errorMsg, errorType) in
                print(errorMsg)
                print(errorType)
                failure(errorMsg)
            })
        }, failure: { (validationMessage) in
            validation(validationMessage)
        })
    }
}
