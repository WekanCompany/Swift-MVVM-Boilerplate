//
//  ForgotPwdViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 28/02/20.
//  Copyright © 2020 WeKan. All rights reserved.
//

import Foundation

class ForgotPwdViewModel {
    var email: Dynamic<String>

    init() {
        self.email = Dynamic("")
    }
    
    // MARK: - API calls
    
    /// Validate form
    /// - Parameters:
    ///   - onTaskSuccess: success callback
    ///   - onFailure: failure callback
    func validateForm(success onTaskSuccess: @escaping OnTaskSuccess,
                      failure onFailure: @escaping OnFailure) {
        if self.email.value.isEmpty {
            onFailure("Please enter the email to reset password")
            return
        }
        if !self.email.value.isValidEmail() {
            onFailure("Please enter a valid email address")
            return
        }
        onTaskSuccess(true)
    }
    /**
     API call to reset password, this will send otp to email
     - method : POST
     - request params: email
     */
    func resetPassword(onSuccess success: @escaping OnSuccess,
                       onFailure failure: @escaping OnFailure,
                       onValidationFailure validation: @escaping OnFailure) {
        validateForm(success: { _ in
            let requestParams = ["email": self.email.value]
            print(requestParams)
            let endpoint = "\(Constants.EndPoint.authentication)\(Constants.EndPoint.resetPwd)"
            NetworkHandler.apiRequest(endPoint: endpoint,
                                      paramDict: requestParams,
                                      method: .post,
                                      onSuccess: { (responseDict) in
                print(responseDict)
                success("Success")
            }, onFailure: { errorMsg, _ in
                failure(errorMsg)
            })
        }, failure: { validationMessage in
            validation(validationMessage)
        })
    }
}
