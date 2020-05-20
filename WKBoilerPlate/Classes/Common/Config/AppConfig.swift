//
//  AppConfig.swift
//  WKBoilerPlate
//
//  Created by Brian on 14/06/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import UIKit

class AppConfig: NSObject {
    /// Currently active BASE URL for the backend  API calls
    static let activeBaseURL = AppConfig.BaseUrl.PRODUCTION
    /// the current backend API version number
    static let currentApiVersion = "v1"

    /** List of Base URLs for development, QA, UAT, and Production environment. */
    struct BaseUrl {
        static let DEV              = ""
        static let QAT              = ""
        static let UAT              = ""
        static let PRODUCTION       = ""
        static let TESTHOST         = ""
    }

    /** List of all static URLs used in the app. */
    struct CommonURLs {
        static let iTunesURL        = "https://itunes.apple.com/us/app/xxxxxx/yyyyy"
        static let privacyPolicyUrl = ""
        static let countriesListUrl = "https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;flag;callingCodes"
    }

    /** Credentials of frameworks and features used in the app. */
    struct Credentials {
        static let googlePlacesApiKey   = ""
        static let encryptionHashKey    = ""
    }

    /** Gets the selected Language to be used across app
     - Used for localizations */
    static var selectedLanguage: String {
        let selectedLang = UserDefaults.standard.object(forKey: Constants.Defaults.selectedLanguage)
        var lang: String = selectedLang as? String ?? "en"
        if lang.contains("-") {
            let language: String = lang.components(separatedBy: "-").first ?? "en"
            lang = language
        }
        return lang
    }
}
