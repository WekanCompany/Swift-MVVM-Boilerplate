//
//  ChangePasswordViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 15/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var newPwdTxtField: UITextField!
    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var changePwdBtn: FilledButton!
    var viewModel: ChangePasswordViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChangePasswordViewModel()
    }

    /// Tap action for change password button
    /// It makes the API call and goes back to prev screen on success.
    /// If session is expired, make the refresh token call and re-initiate the
    @IBAction private func changePwdTapAction(sender: UIButton) {
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
                        self.changePwdTapAction(sender: self.changePwdBtn)
                    } else {
                        self.showAPIError(message: errorMessage)
                    }
                }
            })
        })
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if textField == pwdTxtField {
                if newString.count > Constants.Maximum.passwordLength {
                    return false
                }
                viewModel.oldPwd.value = newString
            } else if textField == newPwdTxtField {
                if newString.count > Constants.Maximum.passwordLength {
                    return false
                }
                viewModel.newPwd.value = newString
            } else if textField == confirmPwdTxtField {
                if newString.count > Constants.Maximum.passwordLength {
                    return false
                }
                viewModel.confirmNewPwd.value = newString
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pwdTxtField {
            self.newPwdTxtField.becomeFirstResponder()
        } else if textField == newPwdTxtField {
            self.confirmPwdTxtField.becomeFirstResponder()
        } else if textField == confirmPwdTxtField {
            textField.resignFirstResponder()
        }
        return true
    }
}
