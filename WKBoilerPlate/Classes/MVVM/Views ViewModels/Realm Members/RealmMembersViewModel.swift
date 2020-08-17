//
//  RealmDashboardViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 17/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class RealmMembersViewModel {
    let realm = try? Realm()
    var userRealms: Results<UserRealm>?

    // MARK: - configure cell

    /**
     Loads user data in table view cell
     - Parameter index: index of the user to be loaded
     - Parameter cell: the cell to load user data
     */
    func loadData(atIndex index: Int, onCell cell: UITableViewCell ) {
        cell.textLabel?.text = "\(self.userRealms?[index].firstName ?? "") \(self.userRealms?[index].lastName ?? "")"
        cell.detailTextLabel?.text = self.userRealms?[index].email
    }

    // MARK: - API calls

    /**
     API call to get all users
     - method : GET
     - API param - fields = email,firstName,lastName
     - API param - sort = status|asc (createdAt, updatedAt, status | asc, desc)
     - API param - limit
     - API param - offset
     - Parameter success: callback for API scuccess
     - Parameter failure: callback for API failure
     */
    func getAllUsers(onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        var endPoint = "\(EndPoint.users)?fields=email,firstName,lastName&sort=status|asc"
        endPoint = endPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? endPoint
        NetworkHandler.apiRequest(endPoint: endPoint,
                                  paramDict: [:],
                                  method: .get,
                                  onSuccess: { (responseDict) in
            if let dataDict = responseDict["data"] as? [String: Any] {
                let usersArray = dataDict["users"] as? [Any] ?? []
                // Get the default Realm
                let realm = try? Realm()
                for index in 0..<usersArray.count {
                    let userDict = usersArray[index] as? [String: Any]
                    let userRealm = UserRealm()
                    userRealm.userId = userDict?["_id"] as? String ?? ""
                    userRealm.firstName = userDict?["firstName"] as? String ?? ""
                    userRealm.lastName = userDict?["lastName"] as? String ?? ""
                    userRealm.email = userDict?["email"] as? String ?? ""
                    // save user to realm db
                    DispatchQueue.main.async {
                        try? realm?.write {
                            realm?.add(userRealm, update: .modified)
                        }
                    }
                }
            }
            success("Success")
        }, onFailure: { (errorMsg, _) in
            print(errorMsg)
            failure(errorMsg)
        })
    }

    // MARK: - Realm DB operations
    /**
     Gets all users from local realm database
     - Used to get all users from local DB and display on screen
     */
    func getAllUsersFromDB() {
        let users = realm?.objects(UserRealm.self)
        self.userRealms = users
    }

    /**
     Inserts users to the database
     - Used here to insert 2 dummy users into database
     */
    func createData() {
        // insert 2 dummy users to DB
        let usersCount = realm?.objects(UserRealm.self).count ?? 0
        for index in usersCount..<usersCount + 2 {
            let userRealm = UserRealm()
            userRealm.userId = "\(index)"
            userRealm.firstName = "Ajith\(index)"
            userRealm.lastName = "Kumar\(index)"
            userRealm.email = "ajith\(index)@test.com"
            // save user to realm db
            DispatchQueue.main.async {
                try? self.realm?.write {
                    self.realm?.add(userRealm, update: .modified)
                }
            }
        }
        DispatchQueue.main.async {
            self.getAllUsersFromDB()
        }
    }

    /**
     Updates a user in local realm database
     - Used to update any record
     - This is a sample update call to update the record of a user
     - Parameter userId: userId of the user to be updated
     */
    func updateUser(userId: String) {
        // Query and update from any thread
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let user = self.realm?.objects(UserRealm.self).filter("userId == %@", userId).first
                try? self.realm?.write {
                    user!.firstName = "Peter"
                }
            }
        }
    }

    static func resetAllRecords() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.deleteAll()
        }
    }
}
