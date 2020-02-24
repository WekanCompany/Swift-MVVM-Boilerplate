//
//  AddMemberViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 03/12/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import Alamofire
import Foundation

class AddMemberViewModel {
    var user: Dynamic<User>

    init() {
        self.user = Dynamic(User())
        // hardcoding the password for this API
        self.user.value.password = "wekancode@123".sha512()
    }

    /// Function to validate the signup form on tapping submit button
    func validateForm(success onTaskSuccess: OnTaskSuccess, failure onFailure: @escaping OnFailure) {
        let firstName = self.user.value.firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let lastName = self.user.value.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = self.user.value.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
        if firstName.count > Constants.Maximum.firstNameLength {
            onFailure("First name exceeded its maximum limit of length")
            return
        }
        if lastName.count > Constants.Maximum.lastNameLength {
            onFailure("Last name exceeded its maximum limit of length")
            return
        }
        if email.count > Constants.Maximum.emailLength {
            onFailure("Email exceeded its maximum limit of length")
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
        onTaskSuccess(true)
    }

    // MARK: - API calls

    /**
     API call for add User
     - method : POST
     - request params: first and last name, email, password, profile image
     */
    func addUser(onSuccess success: @escaping OnSuccess,
                 onFailure failure: @escaping OnApiFailure,
                 onValidationFailure validation: @escaping OnFailure) {
        validateForm(success: { _ in
            let networkManager = NetworkReachabilityManager()
            if networkManager!.isReachable {
                let encodedData = try? JSONEncoder().encode(self.user.value)
                let requestParams = try? JSONSerialization.jsonObject(with: encodedData ?? Data(),
                                                                      options: .allowFragments)
                print(requestParams as Any)
                if let dictFromJSON = requestParams as? [String: Any] {
                    NetworkHandler.apiRequest(
                        endPoint: Constants.EndPoint.users,
                        paramDict: dictFromJSON,
                        method: .post,
                        onSuccess: { responseDict in
                            let respData = responseDict["data"] as? [String: Any]
                            let userInfo = respData?["user"] as? [String: Any]
                            UserDefaults.standard.set(userInfo?["_id"], forKey: Constants.Defaults.userId)
                            success("Success")
                        }, onFailure: { errorMsg, errorType in
                            print(errorMsg)
                            failure(errorMsg, errorType)
                        })
                }
            } else {
                self.addUserOffline()
            }
        }, failure: { validationMessage in
            validation(validationMessage)
        })
    }

    /**
     Insert users in CoreData
     - Used to insert the users received from API, to our local database
     - Callbacks are used in this method for updating the UI after inserting all users
     - Parameter taskSuccess: callback after insertng all users to local db
     - Parameter taskFailure: callback if there is any errors in inserting users to db
     */
    func addUserOffline() {
        // set offline flag, to identify that this user has to be synced when the network comes back
        self.user.value.offline = true
        let membersViewModel = CoreDataMembersViewModel()
        membersViewModel.createUsersInLocalDB(members: [self.user.value], onSuccess: { success in
            print(success)
        }, onFailure: { (errorMsg) in
            print(errorMsg)
        })
    }

    /// This is to sync the users who are added offline. These users will be now created using the respective API calls.
    func syncUsers() {
        let membersViewModel = CoreDataMembersViewModel()
        membersViewModel.syncOfflineMembers()
    }
}
