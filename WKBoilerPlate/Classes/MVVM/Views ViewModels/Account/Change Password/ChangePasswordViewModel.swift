//
//  ChangePasswordViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 15/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class ChangePasswordViewModel {
    
    var oldPwd: Dynamic<String>
    var newPwd: Dynamic<String>
    var confirmNewPwd: Dynamic<String>
    var isPwdReset: Bool
    
    init() {
        self.oldPwd = Dynamic("")
        self.newPwd = Dynamic("")
        self.confirmNewPwd = Dynamic("")
        self.isPwdReset = false
    }

    // Function to validate the change password form on tapping submit button
    func validateForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let password = self.oldPwd.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPassword = self.newPwd.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = self.confirmNewPwd.value.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.isEmpty && !isPwdReset {
            onFailure("Please enter the old password")
            return
        }
        if newPassword.isEmpty {
            onFailure("Please enter the new password")
            return
        }
        if newPassword.isValidPassword() == false {
            onFailure("Password validation alert".localizeText())
            return
        }
        if confirmPassword.isEmpty {
            onFailure("Please confirm the new password")
            return
        }
        if newPassword != confirmPassword {
            onFailure("Password mismatch. Please correctly confirm the new password")
            return
        }
        onTaskSuccess(true)
    }

    // MARK: - API calls
    
    /**
     API call to update any user profile info. Here it updates the password
     - method : PATCH
     - request params: password
     - Parameter success: callback on API success
     - Parameter failure: callback on API failure
     - Parameter validation: callback on failure of validation before making the API call
     - Parameter sessionExpired: callback on expiration of session or token
     
     */
    func updateProfile(onSuccess success: @escaping OnSuccess,
                       onFailure failure: @escaping OnFailure,
                       onValidationFailure validation: @escaping OnFailure,
                       onSessionExpiry sessionExpired: @escaping OnFailure) {
        validateForm(success: { _ in
            NetworkHandler.apiRequest(endPoint: Constants.EndPoint.users,
                                      paramDict: ["password": self.newPwd.value.sha512()],
                                      method: .patch,
                                      onSuccess: { responseDict in
                print(responseDict)
                 // Save user info locally
                 if let dataDict = responseDict["data"] as? [String: Any] {
                     // Save user info singleton, if required
                     let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                     let decodedData = try? JSONDecoder().decode(User.self, from: jsonData ?? Data())
                     UserManager.shared.user = decodedData
                     // save to userdefaults
                     let userDict = dataDict["user"] as? [String: Any]
                     UserDefaults.standard.set(userDict?["accessToken"], forKey: Constants.Defaults.authToken)
                     UserDefaults.standard.set(userDict?["email"], forKey: Constants.Defaults.userEmail)
                     UserDefaults.standard.set(userDict?["firstName"], forKey: Constants.Defaults.userFirstName)
                     UserDefaults.standard.set(userDict?["lastName"], forKey: Constants.Defaults.userLastName)
                     UserDefaults.standard.set(userDict?["refreshToken"], forKey: Constants.Defaults.userRefreshToken)
                 }
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
