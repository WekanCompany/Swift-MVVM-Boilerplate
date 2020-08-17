//
//  EditProfileViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 15/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!

    @IBOutlet weak var updateBtn: FilledButton!
    @IBOutlet private weak var changePwdBtn: BorderedButton!

    var viewModel: EditProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EditProfileViewModel()
        self.loadUserData()
    }

    func loadUserData() {
        firstNameTxtField.text = "\(UserDefaults.standard.object(forKey: Defaults.userFirstName) ?? "")"
        lastNameTxtField.text = "\(UserDefaults.standard.object(forKey: Defaults.userLastName) ?? "")"
        emailTxtField.text = "\(UserDefaults.standard.object(forKey: Defaults.userEmail) ?? "")"
  }

    /// Tap action for change paswword button
    @IBAction private func changePwdTapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "EditProfileToChangePwd", sender: sender)
    }

    /// Tap action for update button
    @IBAction private func updateProfileTapAction(_ sender: Any) {
        viewModel.updateProfile(onSuccess: { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }, onFailure: { errorMsg in
            self.showAPIError(message: errorMsg)
        }, onValidationFailure: { validationMsg in
            self.showValidationError(message: validationMsg)
        }, onSessionExpiry: { errorMessage in
            UserManager.shared.refreshToken(refreshStatus: { status in
                DispatchQueue.main.async {
                    if status == true {
                        self.updateProfileTapAction(self.updateBtn as Any)
                    } else {
                        self.showAPIError(message: errorMessage)
                    }
                }
            })
        })
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textField == firstNameTxtField {
                if newString.count > Maximum.firstNameLength {
                    return false
                }
                viewModel.user.value.firstName = newString
            } else if textField == lastNameTxtField {
                if newString.count > Maximum.lastNameLength {
                    return false
                }
                viewModel.user.value.lastName = newString
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxtField {
            self.lastNameTxtField.becomeFirstResponder()
        } else if textField == lastNameTxtField {
            textField.resignFirstResponder()
        }
        return true
    }
}
