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
        CoreDataMembersViewModel.resetAllRecords(in: Entities.members)
        RealmMembersViewModel.resetAllRecords()
    }

    /**
     To clear data saved locally in UserDefaults
     - can be used during logout or deleting user account
     */
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Defaults.authToken)
        UserDefaults.standard.removeObject(forKey: Defaults.userId)
        UserDefaults.standard.removeObject(forKey: Defaults.userEmail)
        UserDefaults.standard.removeObject(forKey: Defaults.userLastName)
        UserDefaults.standard.removeObject(forKey: Defaults.userFirstName)
        UserDefaults.standard.removeObject(forKey: Defaults.authToken)
        UserDefaults.standard.removeObject(forKey: Defaults.userRefreshToken)
        UserDefaults.standard.removeObject(forKey: Defaults.userTmpPassword)
    }

    /**
     API call to refresh auth token, if expired
     - method : POST
     - request params: refreshToken
     */
    func refreshToken(refreshStatus status: @escaping OnTaskSuccess) {
        let endpoint = "\(EndPoint.authentication)\(EndPoint.refreshToken)"
        let userRefreshToken = UserDefaults.standard.object(forKey: Defaults.userRefreshToken)
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
                UserDefaults.standard.set(userDict?["accessToken"], forKey: Defaults.authToken)
                UserDefaults.standard.set(userDict?["email"], forKey: Defaults.userEmail)
                UserDefaults.standard.set(userDict?["firstName"], forKey: Defaults.userFirstName)
                UserDefaults.standard.set(userDict?["lastName"], forKey: Defaults.userLastName)
                UserDefaults.standard.set(userDict?["refreshToken"], forKey: Defaults.userRefreshToken)
                status(true)
        }, onFailure: { (errorMsg, errorType) in
            print(errorMsg)
            print(errorType)
            status(false)
        })
    }
}
