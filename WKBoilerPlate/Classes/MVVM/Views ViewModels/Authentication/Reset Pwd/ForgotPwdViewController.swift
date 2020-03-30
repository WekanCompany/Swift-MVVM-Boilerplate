//
//  ForgotPwdViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 28/02/20.
//  Copyright © 2020 WeKan. All rights reserved.
//

import UIKit

class ForgotPwdViewController: BaseViewController {
    @IBOutlet private weak var emailTxtField: UITextField!
    @IBOutlet private weak var resetBtn: FilledButton!

    var viewModel: ForgotPwdViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = ForgotPwdViewModel()
    }
    
    /// Submit button action
    /// - Parameter sender: reset button
    @IBAction private func resetPwdAction(sender: UIButton) {
        viewModel.resetPassword(onSuccess: { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }, onFailure: { errorMsg in
            self.showAPIError(message: errorMsg)
        }, onValidationFailure: { validationMsg in
            self.showValidationError(message: validationMsg)
        })
    }
}

extension ForgotPwdViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            if oldString.isEmpty && string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            var newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if newString.count > Constants.Maximum.emailLength {
                return false
            }
            viewModel.email.value = newString
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
