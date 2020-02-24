//
//  Singleton.swift
//  WKBoilerPlate
//
//  Created by Brian on 10/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class UserManager {
    static let shared = UserManager()

    var user: User?

    //Initializer access level change now
    private init() {
    }

    /**
     To clear all local data
     - clears all data from this Singleton and UserDefaults
     - can be used during logout or deleting user account
     */
    func clearData() {
        self.user = nil
        self.clearUserDefaults()
        CoreDataMembersViewModel.resetAllRecords(in: Constants.Entities.members)
        RealmMembersViewModel.resetAllRecords()
    }

    /**
     To clear data saved locally in UserDefaults
     - can be used during logout or deleting user account
     */
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.authToken)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userId)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userEmail)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userLastName)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userFirstName)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.authToken)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userRefreshToken)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.userTmpPassword)
    }

    /**
     API call to refresh auth token, if expired
     - method : POST
     - request params: refreshToken
     */
    func refreshToken(refreshStatus status: @escaping OnTaskSuccess) {
        let endpoint = "\(Constants.EndPoint.authentication)\(Constants.EndPoint.refreshToken)"
        let userRefreshToken = UserDefaults.standard.object(forKey: Constants.Defaults.userRefreshToken)
        NetworkHandler.apiRequest(endPoint: endpoint,
                                  paramDict: ["refreshToken": userRefreshToken ?? ""],
                                  method: .post,
                                  onSuccess: { (responseDict) in
                // Save user info singleton, if required
                if let dataDict = responseDict["data"] as? [String: Any] {
                    let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                    let decodedData = try? JSONDecoder().decode(User.self, from: jsonData ?? Data())
                    UserManager.shared.user = decodedData
                }
                // save to user defaults
                let dataDict = responseDict["data"] as? [String: Any]
                let userDict = dataDict?["user"] as? [String: Any]
                UserDefaults.standard.set(userDict?["accessToken"], forKey: Constants.Defaults.authToken)
                UserDefaults.standard.set(userDict?["email"], forKey: Constants.Defaults.userEmail)
                UserDefaults.standard.set(userDict?["firstName"], forKey: Constants.Defaults.userFirstName)
                UserDefaults.standard.set(userDict?["lastName"], forKey: Constants.Defaults.userLastName)
                UserDefaults.standard.set(userDict?["refreshToken"], forKey: Constants.Defaults.userRefreshToken)
                status(true)
        }, onFailure: { (errorMsg, errorType) in
            print(errorMsg)
            print(errorType)
            status(false)
        })
    }
}
