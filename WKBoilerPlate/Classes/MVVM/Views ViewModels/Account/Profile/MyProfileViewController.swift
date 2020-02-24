//
//  MyProfileViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 09/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var logoutBtn: BorderedButton!

    var viewModel: MyProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.removeLeftBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUserData()
    }

    /// Load available user data on the fields
    func loadUserData() {
        let defaults = UserDefaults.standard
        let fName = defaults.object(forKey: Constants.Defaults.userFirstName)
        let lName = defaults.object(forKey: Constants.Defaults.userLastName)
        nameLbl.text = "\(fName ?? "") \(lName ?? "")"
        emailLbl.text = "\(defaults.object(forKey: Constants.Defaults.userEmail) ?? "")"
    }

    /// Edit profile button tap action
    @IBAction func editProfileTapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileToEdit", sender: sender)
    }

    /// tap action for logout button
    @IBAction func logoutTapAction(_ sender: Any) {
        UserManager.shared.clearData()
        Router.setRootViewController()
    }

    /// Edit profile button tap action
    @IBAction func coreDataMembersListTapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileToCoreDataMembers", sender: sender)
    }

    /// Edit profile button tap action
    @IBAction func realmMembersListTapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileToRealmMembers", sender: sender)
    }
}
