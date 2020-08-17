//
//  BorderedButton.swift
//  WKBoilerPlate
//
//  Created by Brian on 24/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do app specific customizations for the button here.
        self.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor.white
        self.titleLabel?.textColor = UIColor.darkText
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkText.cgColor
        self.setLightFontOfSize(size: 15)
    }
    /**
     Sets the common bold font of the app in requested size
     */
    func setBoldFontOfSize(size: CGFloat) {
        self.titleLabel?.font = UIFont.openSansBoldFont(withSize: size)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    /**
     Sets the common light font of the app in requested size
     */
    func setLightFontOfSize(size: CGFloat) {
        self.titleLabel?.font = UIFont.openSansRegularFont(withSize: size)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
