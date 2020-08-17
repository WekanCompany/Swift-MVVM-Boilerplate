//
//  FilledButton.swift
//  WKBoilerPlate
//
//  Created by Brian on 23/07/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import UIKit

class FilledButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do app specific customizations for the button here.
        self.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor.gray
        self.titleLabel?.textColor = UIColor.darkText
        self.setBoldFontOfSize(size: 15)
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
