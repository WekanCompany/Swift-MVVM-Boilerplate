//
//  TextViewExtension.swift
//  WKBoilerPlate
//
//  Created by Brian on 18/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

extension UITextView {
    /**
     Removes the default left padding of the textviews
     */
    func removeLeftPadding() {
        // Remove all padding
        self.textContainerInset = .zero
        // Turns out we still have 5px of extra padding on the left of text view. Code below gets rid of it too.
        self.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
}
