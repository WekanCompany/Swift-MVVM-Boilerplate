//
//  Router.swift
//  WKBoilerPlate
//
//  Created by Brian on 14/06/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import UIKit

class Router {
    /**
     To get viewcontrollers from Onboarding storyboard
     - get viewcontrollers from onboarding storyboard using their storyboard IDs
     - Parameter storyboardId: Storyboard ID of the requested viewcontroller
     - returns: the requested viewcontroller in it's file type
     */
    static func getVCFromOnboardingStoryboard(withId storyboardId: String) -> Any {
        let storyboard = UIStoryboard(name: Constants.Storyboards.onboarding, bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: storyboardId)
        return viewC
    }

    /**
     To get viewcontrollers from Main storyboard
     - get viewcontrollers from main storyboard using their storyboard IDs
     - Parameter storyboardId: Storyboard ID of the requested viewcontroller
     - returns: the requested viewcontroller in it's file type
     */
    static func getVCFromMainStoryboard(withId storyboardId: String) -> Any {
        let storyboard = UIStoryboard(name: Constants.Storyboards.main, bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: storyboardId)
        return viewC
    }

    /**
     To get viewcontrollers from storyboards
     - get viewcontrollers from storyboard using their storyboard IDs and storyboard name
     - Parameter storyboardName: name of the storyboard that contains the requested viewcontroller
     - Parameter storyboardId: Storyboard ID of the requested viewcontroller
     - returns: the requested viewcontroller in it's file type
     */
    static func getVC(withId storyboardId: String, fromStoryboard storyboardName: String) -> Any {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: storyboardId)
        return viewC
    }

    /// Set app window's rootviewcontroller.
    /// - If already authenticated, will get inside app
    /// - Else will be taken to authentication screen
    static func setRootViewController() {
        let authToken = UserDefaults.standard.value(forKey: Constants.Defaults.authToken)
        DispatchQueue.main.async {
            if authToken != nil {
                let storyboardID = Constants.StoryboardID.mainNav
                let navC = Router.getVCFromMainStoryboard(withId: storyboardID) as? UINavigationController
                Constants.appDelegate.window?.rootViewController = navC
            } else {
                let storyboardID = Constants.StoryboardID.onboardingNav
                let navC = Router.getVCFromOnboardingStoryboard(withId: storyboardID) as? UINavigationController
                Constants.appDelegate.window?.rootViewController = navC
            }
        }
    }
}
