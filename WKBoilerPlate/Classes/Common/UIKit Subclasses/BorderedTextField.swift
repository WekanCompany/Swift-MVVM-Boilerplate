//
//  BorderedTextField.swift
//  WKBoilerPlate
//
//  Created by Brian on 24/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //Round the corners
        self.layer.cornerRadius = 20.0
        // set whit BG
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        // set Common font
       // self.setLightFontOfSize(size: 18)
        self.setLightFont(ofSize: 14)
    }

    /**
     Sets the common bold font of the app in requested size
     */
    func setBoldFont(ofSize size: CGFloat) {
        let customFont = UIFont.openSansBoldFont(withSize: size).adaptiveResize()
        if #available(iOS 11.0, *) {
            self.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        } else {
            // Fallback on earlier versions
            self.font = customFont.adaptiveResize()
        }
        self.adjustsFontForContentSizeCategory = true
    }

    /**
     Sets the common light font of the app in requested size
     */
    func setLightFont(ofSize size: CGFloat) {
        let customFont = UIFont.openSansRegularFont(withSize: size).adaptiveResize()
        if #available(iOS 11.0, *) {
            self.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        } else {
            // Fallback on earlier versions
            self.font = customFont.adaptiveResize()
        }
        self.adjustsFontForContentSizeCategory = true
    }
}
