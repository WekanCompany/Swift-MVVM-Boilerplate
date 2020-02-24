//
//  UserRealm.swift
//  WKBoilerPlate
//
//  Created by Brian on 18/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class UserRealm: Object {
    @objc dynamic var userId = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var email = ""

    override static func primaryKey() -> String? {
        return "userId"
    }
}
