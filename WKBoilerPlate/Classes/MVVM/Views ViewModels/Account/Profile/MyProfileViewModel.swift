//
//  MyProfileViewModel.swift
//  WKBoilerPlate
//
//  Created by Brian on 09/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class MyProfileViewModel {
    var email: Dynamic<String>
    var name: Dynamic<String>
    var user: Dynamic<User>
    
    init() {
        self.email = Dynamic("")
        self.name = Dynamic("")
        self.user = Dynamic(User())
    }
}
