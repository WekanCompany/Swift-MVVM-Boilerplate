//
//  Constants.swift
//  WKBoilerPlate
//
//  Created by Brian on 14/06/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import UIKit

/// Enum with all types of Files the app supports for upload .
/// - raw value : Int
enum UploadFileType: Int {
    case text = 1
    case imageFile = 2
    case videoFile = 3
    case audioFile = 4
}

/// Enum with all types of Failures/errors that occurs on an API call .
/// - raw value : Int
enum ErrorType: Int {
    case httpError = 0
    case invalidResponseError = 1
    case networkError = 2
    case sessionExpiry = 3
    case unknownError = 4
}

class Constants {
    /** An instance for the AppDelegate which is UIApplication.shared.delegate */
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()

    /** List of constants like maximum limits for text fields, image display ratio. */
    struct Maximum {
        static let otpLength = 20
        static let passwordLength = 20
        static let emailLength = 80
        static let phoneLength = 20
        static let firstNameLength = 20
        static let lastNameLength = 20
        static let middleNameLength = 20
        static let fullnameLength = 60
        static let locationLength = 60
        static let contentTitleLength = 90
        static let descriptionLength = 10_000
        static let imageDisplayRatio = 1.5
    }

    /** List of all keys used in the app to store data in UserDefaults. */
    struct Defaults {
        static let selectedLanguage     = "language"
        static let authToken            = "auth_token"
        static let firebaseToken        = "firebase_token"
        static let userId               = "_id"
        static let userEmail            = "email"
        static let userFirstName        = "firstName"
        static let userLastName         = "lastName"
        static let userRefreshToken     = "refreshToken"
        static let userTmpPassword      = "tmpPassword"
    }

    /** List of all API Endpoints of webservices used in the app to communicate with the backend. */
    struct EndPoint {
        static let authentication       = "/v1/auth/users"
        static let login                = "/login"
        static let users                = "/v1/users"
        static let verifyAccount        = "/verify"
        static let verificationCode     = "/verification-code"
        static let resetPwd             = "/reset-password"
        static let refreshToken         = "/refresh"
    }

    /** List of all keys to be commonly handled from the response of our backend webservices. */
    struct ResponseKey {
        static let success              = "data"
        static let errors               = "errors"
        static let messages             = "messages"
    }

    /// List of all Storyboards used in the app.
    struct Storyboards {
        static let launchScreen         = "LaunchScreen"
        static let onboarding           = "Onboarding"
        static let main                 = "Main"
    }

    /// List of all required Storyboard IDs from all storyboards.
    struct StoryboardID {
        static let onboardingNav        = "OnboadingNav"
        static let mainNav              = "MainNav"
    }

    /// List of all custom Cells for TableViews and CollectionViews in the app.
    struct Cells {
        static let countryCell          = "CountryTableViewCell"
        static let imageCell            = "ImageCollectionViewCell"
    }

    /// List of all entities in CoreData.
    struct Entities {
        static let members          = "Member"
    }
}
