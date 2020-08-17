//
//  OTPVerificationViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 03/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class OTPVerificationViewModel {
    var otp: Dynamic<String>

    init() {
        self.otp = Dynamic("")
    }

    // MARK: - API calls

    func validateForm(success onTaskSuccess: @escaping OnTaskSuccess,
                      failure onFailure: @escaping OnFailure) {
        if self.otp.value.isEmpty {
            onFailure("Please enter the otp received on your registered email")
            return
        }
        onTaskSuccess(true)
    }
    /**
     API call to verify OTP
     - method : POST
     - request params: verification code
     */
    func verifyOTP(onSuccess success: @escaping OnSuccess,
                   onFailure failure: @escaping OnFailure,
                   onValidationFailure validation: @escaping OnFailure) {
        validateForm(success: { _ in
            let requestParams = ["verificationCode": self.otp.value]
            print(requestParams)
            let userID = UserDefaults.standard.object(forKey: Defaults.userId)
            let endpoint = "\(EndPoint.authentication)/\(userID!)\(EndPoint.verifyAccount)"
            NetworkHandler.apiRequest(endPoint: endpoint,
                                      paramDict: requestParams,
                                      method: .post,
                                      onSuccess: { (responseDict) in
                print(responseDict)
                // Save user info locally
                let dataDict = responseDict["data"] as? [String: Any]
                let userDict = dataDict?["user"] as? [String: Any]
                UserDefaults.standard.set(userDict?["accessToken"], forKey: Defaults.authToken)
                UserDefaults.standard.set(userDict?["email"], forKey: Defaults.userEmail)
                UserDefaults.standard.set(userDict?["firstName"], forKey: Defaults.userFirstName)
                UserDefaults.standard.set(userDict?["lastName"], forKey: Defaults.userLastName)
                UserDefaults.standard.set(userDict?["refreshToken"], forKey: Defaults.userRefreshToken)
                UserDefaults.standard.set(userDict?["tmpPassword"], forKey: Defaults.userTmpPassword)

                success("Success")
            }, onFailure: { errorMsg, _ in
                failure(errorMsg)
            })
        }, failure: { validationMessage in
            validation(validationMessage)
        })
    }
    /**
     API call to resend OTP
     - method : POST
     - request params: email
     */
    func resendOTP(onSuccess success: @escaping OnSuccess,
                   onFailure failure: @escaping OnFailure,
                   onValidationFailure validation: @escaping OnFailure) {
        let userId = UserDefaults.standard.object(forKey: Defaults.userId)
        let endpoint = "\(EndPoint.authentication)/\(userId!)\(EndPoint.verificationCode)"
        NetworkHandler.apiRequest(endPoint: endpoint, paramDict: [:], method: .post, onSuccess: { responseDict in
            print(responseDict)
            success("Success")
        }, onFailure: { (errorMsg, _) in
            print(errorMsg)
            failure(errorMsg)
        })
    }
}
