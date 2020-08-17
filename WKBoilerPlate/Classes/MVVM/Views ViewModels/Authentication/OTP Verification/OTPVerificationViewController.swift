//
//  OTPVerificationViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 03/09/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class OTPVerificationViewController: BaseViewController {
    @IBOutlet weak var otpTextFld: UITextField!
    @IBOutlet weak var submitBtn: FilledButton!
    @IBOutlet weak var resendOTPBtn: BorderedButton!

    var viewModel: OTPVerificationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = OTPVerificationViewModel()
    }
    
    // MARK: - Button Actions

    @IBAction private func submitTapAction(_ sender: Any) {
        viewModel.verifyOTP(onSuccess: { _ in
            Router.setRootViewController()
        }, onFailure: { errorMsg in
            self.showAPIError(message: errorMsg)
        }, onValidationFailure: { validationMsg in
            self.showValidationError(message: validationMsg)
        })
    }

    @IBAction private func resendOTPTapAction(_ sender: Any) {
        viewModel.resendOTP(onSuccess: { _ in
            self.showMessage(message: "OTP resent successfully", title: "Sent")
        }, onFailure: { (errorMsg) in
            self.showAPIError(message: errorMsg)
        }, onValidationFailure: { (validationMsg) in
            self.showValidationError(message: validationMsg)
        })
    }
}

extension OTPVerificationViewController: UITextFieldDelegate {
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
            if textField == otpTextFld {
                if newString.count > Maximum.otpLength {
                    return false
                }
                viewModel.otp.value = newString
            }
        }
        return true
    }
}
