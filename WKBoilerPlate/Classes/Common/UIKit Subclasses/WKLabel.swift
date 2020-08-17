//
//  WKLabel.swift
//  WKBoilerPlate
//
//  Created by Brian on 23/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

class WKLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setLightFontOfSize(size: 16)
    }
    /**
     Sets the common bold font of the app in requested size
     */
    func setBoldFontOfSize(size: CGFloat) {
         self.font = UIFont.openSansBoldFont(withSize: size)
        self.adjustsFontForContentSizeCategory = true
    }
    /**
     Sets the common light font of the app in requested size
     */
    func setLightFontOfSize(size: CGFloat) {
         self.font = UIFont.openSansRegularFont(withSize: size)
        self.adjustsFontForContentSizeCategory = true
    }
}
