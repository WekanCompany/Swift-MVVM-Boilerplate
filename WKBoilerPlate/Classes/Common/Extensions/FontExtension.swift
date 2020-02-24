//  FontExtension.swift
//  WKBoilerPlate
//
//  Created by Brian on 18/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

extension UIFont {
    static let screenWidthRatio = UIScreen.main.bounds.size.width / 320.0

    /// scales the font for different devices
    func adaptiveResize() -> UIFont {
        let scaledFontSize = self.pointSize * UIFont.screenWidthRatio
        let sizeDifference = scaledFontSize - self.pointSize
        if sizeDifference > 0 {
            let pointsToScale = sizeDifference * 0.5
            let finalPointSize = self.pointSize + pointsToScale
            return self.withSize(finalPointSize)
        }
        return self
    }

    // MARK: - Open Sans

    class func openSansBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!.adaptiveResize()
    }

    class func openSansRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: size)!.adaptiveResize()
    }
}
