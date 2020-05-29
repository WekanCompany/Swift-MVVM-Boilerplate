//  FontExtension.swift
//  WKBoilerPlate
//
//  Created by Brian on 18/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

extension UIFont {

    /// scales the font for different devices
    func adaptiveResize() -> UIFont {
        let scaleFactor = (UIScreen.main.scale == 3.0) ? 1.2 : (UIScreen.main.scale == 2.0) ? 1.1 : 1.0
        let size = self.pointSize * CGFloat(scaleFactor)
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self.withSize(size))
        } else {
            return self.withSize(size)
        }
    }

    // MARK: - Open Sans

    class func openSansBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!.adaptiveResize()
    }

    class func openSansRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: size)!.adaptiveResize()
    }
}
