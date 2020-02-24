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
        let customFont = UIFont.openSansBoldFont(withSize: size).adaptiveResize()
        self.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: customFont)
        self.adjustsFontForContentSizeCategory = true
    }
    /**
     Sets the common light font of the app in requested size
     */
    func setLightFontOfSize(size: CGFloat) {
        let customFont = UIFont.openSansRegularFont(withSize: size).adaptiveResize()
        self.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        self.adjustsFontForContentSizeCategory = true
    }
}
