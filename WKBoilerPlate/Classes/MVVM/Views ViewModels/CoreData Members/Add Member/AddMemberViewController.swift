//
//  AddMemberViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 03/12/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

class AddMemberViewController: BaseViewController {
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet private weak var emailTxtField: UITextField!
    @IBOutlet private weak var addUserBtn: FilledButton!
    @IBOutlet private weak var screenDescriptionLbl: WKLabel!

    var viewModel: AddMemberViewModel! {
        didSet {
            self.viewModel.user.bind({ userModel in
                userModel.firstName = self.firstNameTxtField.text ?? ""
                userModel.lastName = self.lastNameTxtField.text ?? ""
                userModel.email = self.emailTxtField.text ?? ""
            })
        }
    }

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = AddMemberViewModel()
        viewModel.syncUsers()
    }

    // MARK: - Button Actions

    /// Tap action for Add User button
        @IBAction private func addUserTapAction(_ sender: Any) {
            viewModel.addUser(onSuccess: { _ in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }, onFailure: { errorMsg, _ in
                self.showAPIError(message: errorMsg)
            }, onValidationFailure: { validationMsg in
                self.showValidationError(message: validationMsg)
            })
        }
    }

    extension AddMemberViewController: UITextFieldDelegate {
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
            default:
                break
            }
            return true
        }
    }
