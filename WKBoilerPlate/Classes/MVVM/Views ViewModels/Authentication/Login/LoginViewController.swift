//
//  LoginViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 01/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet private weak var emailTxtField: UITextField!
    @IBOutlet private weak var pwdTxtField: UITextField!
    @IBOutlet private weak var signupBtn: FilledButton!
    @IBOutlet private weak var loginBtn: FilledButton!
    @IBOutlet private weak var forgotPwdBtn: BorderedButton!
    @IBOutlet private weak var screenDescriptionLbl: WKLabel!

    var viewModel: LoginViewModel! {
        didSet {
            self.viewModel.loginModel.bind({ userModel in
                userModel.email = self.emailTxtField.text ?? ""
                userModel.password = self.pwdTxtField.text ?? ""
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = LoginViewModel()
    }

    /// Resets all fields of the login form
    func resetFields() {
        self.emailTxtField.text = ""
        self.pwdTxtField.text = ""
    }

    // MARK: - Button Actions

    /// Tap action for signup button
    /// - Clears fields and navigate to signup screen
    @IBAction private func signupTapAction(sender: UIButton) {
        self.resetFields()
        self.performSegue(withIdentifier: "LoginToSignup", sender: sender)
    }

    /// Tap action for login button
    /// - Makes the login API call and navigates to dashboard on success
    /// - Have 2 success usecases - regular login and login using the temporary password sent to email for resetting pwd
    @IBAction private func loginTapAction(sender: UIButton) {
        viewModel.emailLogin(onSuccess: { successMsg in
            if successMsg as? String == "SetPassword" {
                guard let setPwdVC = Router.getVCFromMainStoryboard(withId:
                    "ChangePasswordViewController") as? ChangePasswordViewController else {
                    return
                }
                setPwdVC.viewModel = ChangePasswordViewModel()
                setPwdVC.viewModel.isPwdReset = true
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(setPwdVC, animated: true)
                }
            } else {
                Router.setRootViewController()
            }
        }, onFailure: { (errorMsg: String) in
            self.showAPIError(message: errorMsg)
        }, onValidationFailure: { validationMsg in
            self.showValidationError(message: validationMsg)
        })
    }
    
    /// forgot password button action
    /// - Parameter sender: forgot password butto
    @IBAction private func forgotPwdTapAction(sender: UIButton) {
        self.resetFields()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)

            if textField == emailTxtField {
                if newString.count > Maximum.emailLength {
                    return false
                }
                viewModel.loginModel.value.email = newString
            } else if textField == pwdTxtField {
                if newString.count > Maximum.passwordLength {
                    return false
                }
                viewModel.loginModel.value.password = newString
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxtField {
            self.pwdTxtField.becomeFirstResponder()
        } else if textField == pwdTxtField {
            self.pwdTxtField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
}
