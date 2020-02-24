//
//  BaseViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 01/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Common Functions
    func removeLeftBarButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = nil
    }

    // MARK: - Alerts

    /// Alert message used to show any local validation errors
    func showValidationError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Validation Failed", message: message, preferredStyle: .alert)
            let okBtnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtnAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    /// Alert message used to show any API errors
    func showAPIError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Request Failed", message: message, preferredStyle: .alert)
            let okBtnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtnAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// handle error on UI
    func handleErrorOnUI(errorMessage message: String, errorType type: ErrorType) {
        switch type {
        case .networkError:
            self.showAPIError(message: message)
        case .sessionExpiry:
            break
        case .invalidResponseError:
            break
        case .httpError:
            break
        default:
            break
        }
    }

    /// Alert message used to show any general messages
    func showMessage(message: String, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okBtnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okBtnAction)
            self.present(alert, animated: true) {
            }
        }
    }

    // MARK: - Image Picker

    func openImagePicker(atViewController viewC: Any) {
        let alert = UIAlertController(title: "Profile Picture", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Open Camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = (viewC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.imagePicker.cameraViewTransform = CGAffineTransform(scaleX: -1, y: 1)
                DispatchQueue.main.async {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
        let galleryAction = UIAlertAction(title: "Open Photos Album", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = (viewC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                DispatchQueue.main.async {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
