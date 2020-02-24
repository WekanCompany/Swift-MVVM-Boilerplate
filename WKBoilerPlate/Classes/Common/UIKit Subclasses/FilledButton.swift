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
        let customFont = UIFont.openSansBoldFont(withSize: size).adaptiveResize()
        self.titleLabel?.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: customFont)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
  }
    /**
     Sets the common light font of the app in requested size
     */
    func setLightFontOfSize(size: CGFloat) {
        let customFont = UIFont.openSansRegularFont(withSize: size).adaptiveResize()
        self.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
