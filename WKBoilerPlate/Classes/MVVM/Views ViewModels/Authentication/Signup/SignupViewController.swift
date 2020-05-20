//
//  SignupViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 01/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class SignupViewController: BaseViewController {
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var signupBtn: FilledButton!
    @IBOutlet private weak var loginBtn: FilledButton!
    @IBOutlet private weak var screenDescriptionLbl: WKLabel!

    var viewModel: SignupViewModel! {
        didSet {
            self.viewModel.user.bind({ userModel in
                userModel.firstName = self.firstNameTxtField.text ?? ""
                userModel.lastName = self.lastNameTxtField.text ?? ""
                userModel.email = self.emailTxtField.text ?? ""
                userModel.password = self.pwdTxtField.text ?? ""
            })
        }
    }

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = SignupViewModel()
        self.removeLeftBarButton()
    }
    // MARK: - Button Actions
    /// Tap action for signup button
    @IBAction private func signupTapAction(_ sender: Any) {
        viewModel.emailSignup(onSuccess: { _ in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SignupToVerifyOTP", sender: sender)
            }
        }, onFailure: { errorMsg in
            self.showAPIError(message: errorMsg)
        }, onValidationFailure: { validationMsg in
            self.showValidationError(message: validationMsg)
        })
    }

    /// Tap action for login Button
    @IBAction private func loginTapAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            switch textField {
            case firstNameTxtField:
                if newString.count > Constants.Maximum.firstNameLength {
                    return false
                }
                viewModel.user.value.firstName = newString
            case lastNameTxtField:
                if newString.count > Constants.Maximum.lastNameLength {
                    return false
                }
                viewModel.user.value.lastName = newString
            case emailTxtField:
                if newString.count > Constants.Maximum.emailLength {
                    return false
                }
                viewModel.user.value.email = newString
            case pwdTxtField:
                if newString.count > Constants.Maximum.passwordLength {
                    return false
                }
                viewModel.user.value.password = newString
            default:
                break
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTxtField:
            self.lastNameTxtField.becomeFirstResponder()
        case lastNameTxtField:
            self.emailTxtField.becomeFirstResponder()
        case emailTxtField:
            self.pwdTxtField.becomeFirstResponder()
        case pwdTxtField:
            self.pwdTxtField.resignFirstResponder()
            self.view.endEditing(true)
        default:
            break
        }
        return true
    }
}
