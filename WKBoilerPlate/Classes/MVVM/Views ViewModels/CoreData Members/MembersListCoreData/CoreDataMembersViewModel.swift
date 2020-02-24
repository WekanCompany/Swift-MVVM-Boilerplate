//
//  CoreDataMembersViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 17/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class CoreDataMembersViewModel {
    var users: [User]
    var usersDBObjects: [Member]
    let managedContext: NSManagedObjectContext
    let attributeEmail = "email"
    let attributeFirstName = "firstName"
    let attributeLastName = "lastName"
    let attributeUserId = "userId"
    let attributeOffline = "offline"

    init() {
        self.users = []
        self.usersDBObjects = []
        self.managedContext = Constants.appDelegate.persistentContainer.viewContext
    }

    // MARK: - API calls

    /**
     Makes API call to get all users and then save them in local DB
     - method : GET
     - API param - fields = email,firstName,lastName
     - API param - sort = status|asc (createdAt, updatedAt, status | asc, desc)
     - API param - limit
     - API param - offset
     - Parameter success: callback for API scuccess
     - Parameter failure: callback for API failure
     */
    func getAllUsers(onSuccess success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        var endPoint = "\(Constants.EndPoint.users)?fields=email,firstName,lastName&sort=firstName|asc"
        endPoint = endPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? endPoint
        NetworkHandler.apiRequest(endPoint: endPoint, paramDict: [:], method: .get, onSuccess: { responseDict in
            // Parse users data
            self.parseAllUsers(responseDict: responseDict)
            success(self.users)
        }, onFailure: { errorMsg, _ in
            print(errorMsg)
            failure(errorMsg)
        })
    }

    /// Parse the response of get all users api and store to the users array
    /// - Parameter responseDict: API response json
    func parseAllUsers(responseDict: [String: Any]) {
        if let dataDict = responseDict["data"] as? [String: Any] {
            let usersArray = dataDict["users"] as? [Any]
            self.users = []
            for user in 0..<usersArray!.count {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: usersArray?[user] ?? [],
                                                                 options: .prettyPrinted) else { return }
                guard let decodedData = try? JSONDecoder().decode(User.self, from: jsonData) else { return }
                self.users.append(decodedData)
            }
        }
    }

    /// Saves the parsed user list to local database
    /// - Parameter success: success handler that sends a flag saying whether the database operation succeeded.
    func saveAllUsersToLocalDB(onCompletion success: @escaping OnTaskSuccess) {
        DispatchQueue.main.async {
            self.createUsersInLocalDB(members: self.users, onSuccess: { _ in
                success(true)
            }, onFailure: { _ in
                success(false)
            })
        }
    }

    // MARK: - Core Data operations

    /**
     Insert users in CoreData
     - Used to insert the users received from API, to our local database
     - Callbacks are used in this method for updating the UI after inserting all users
     - Parameter taskSuccess: callback after insertng all users to local db
     - Parameter taskFailure: callback if there is any errors in inserting users to db
     */
    func createUsersInLocalDB(members: [User], onSuccess taskSuccess: OnTaskSuccess, onFailure taskFailure: @escaping OnFailure) {
        let usersEntity = NSEntityDescription.entity(forEntityName: Constants.Entities.members, in: managedContext)!
        // iterate the users received from API and add them to DB
        for index in 0..<members.count {
            //Check if user already exists
            // Insert user, if the user doesn't exist in db
            let user = members[index]
            if self.isExist(userId: user.userId!) == false {
                let userMngObj = NSManagedObject(entity: usersEntity, insertInto: managedContext)
                userMngObj.setValue(user.userId, forKey: attributeUserId)
                userMngObj.setValue(user.firstName, forKey: attributeFirstName)
                userMngObj.setValue(user.lastName, forKey: attributeLastName)
                userMngObj.setValue(user.email, forKey: attributeEmail)
                if let offline = user.offline {
                    userMngObj.setValue(offline, forKey: attributeOffline)
                }
            }
        }
        // save all values in Core Data
        do {
            try managedContext.save()
            taskSuccess(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            taskFailure(error.localizedDescription)
        }
    }

    /**
     Checks whether the user exists in database
     - used while inserting a user to Member DB, by checking whether the user already exists
     - Parameter userId: userId of the user to be checked in database
     */
    func isExist(userId: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.members)
        fetchRequest.predicate = NSPredicate(format: "userId = %@", argumentArray: [userId])
        let res = try? managedContext.fetch(fetchRequest)
        return res?.count ?? 0 > 0 ? true : false
    }

    /**
     Gets all users from coredata
     - Used in members list screen, where it shows all users from coredata
     */
    func getAllUsersFromDB() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.members)
        do {
            let results = try managedContext.fetch(fetchRequest) as? [Member]
            self.usersDBObjects = results ?? []
        } catch let error as NSError {
            print("error: \(error), \(error.userInfo)")
        }
    }

    /**
     Updates a user in coredata
     - Used to update any data
     - This is a sample update call to update the record of a user
     */
    func updateData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Constants.Entities.members)
        fetchRequest.predicate = NSPredicate(format: "%@ = %@", attributeFirstName, "Ajith1")
        do {
            let test = try managedContext.fetch(fetchRequest)
            guard let objectUpdate = test[0] as? NSManagedObject else {
                return
            }
            objectUpdate.setValue("Brian", forKey: attributeFirstName)
            objectUpdate.setValue("Chris", forKey: attributeLastName)
            objectUpdate.setValue("brian@test.com", forKey: attributeEmail)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }

    /**
     Deletes a user from coredata
     - Used to delete any record from coredata
     - This is a sample delete call to delete a user record
     */
    func deleteData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.members)
        fetchRequest.predicate = NSPredicate(format: "%@ = %@", attributeFirstName, "Ajith3")
        do {
            let test = try managedContext.fetch(fetchRequest)
            guard let objectToDelete = test[0] as? NSManagedObject else {
                return
            }
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }

    /// Deletes all records and clears the table/entity
    /// - Parameter entity: name of the entity to be reset
    static func resetAllRecords(in entity: String) {
        let context = Constants.appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            //            try context.save()
        } catch {
            print("There was an error")
        }
    }

    // MARK: - Sync Operations

    /// This will sync the users who were added offline.
    /// It will check for the users with offline flag as TRUE and make API calls to create those users.
    func syncOfflineMembers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.members)
        fetchRequest.predicate = NSPredicate(format: "%@ = 1", attributeOffline)
        do {
            guard let offlineMembers = try managedContext.fetch(fetchRequest) as? [Member] else {
                return
            }
            for index in 0..<offlineMembers.count {
                let member = offlineMembers[index]
                self.createMember(member: member)
            }
        } catch {
            print("Failed")
        }
    }

    /// API call to create the member
    /// - Parameter member: the member object to be added/created
    func createMember(member: Member) {
        DispatchQueue.main.async {
            let addMemberViewModel = AddMemberViewModel()
            addMemberViewModel.user.value.email = member.email
            addMemberViewModel.user.value.firstName = member.firstName
            addMemberViewModel.user.value.lastName = member.lastName
            addMemberViewModel.addUser(onSuccess: { successMsg in
                print(successMsg)
            }, onFailure: { errorMsg, _ in
                print(errorMsg)
            }, onValidationFailure: { validationError in
                print(validationError)
            })
        }
    }
}
