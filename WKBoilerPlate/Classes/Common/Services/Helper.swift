//
//  Helper.swift
//  WKBoilerPlate
//
//  Created by Brian on 14/06/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    /**
     Method to download an image to the cache
     - can be used for any images that has to preloaded from cache
     - Parameter fromUrl: URL to download the image
     */
    static func downloadImageToCache(fromUrl urlString: String) {
        if urlString.isEmpty {
            return
        }
        let imageCache = NSCache<NSString, AnyObject>()
        let url = URL(string: urlString)
        // download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { data, _, error in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
        }).resume()
    }

    /**
     Fix the image orientation to portrait
     - Used for images captured from camera or taken gallery
     - Parameter fromUrl: URL to download the image
     */
    static func fixImageOrientation(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }

    /**
     To get the file size of any UIImage
     - Used for file size restriction while posting a Publication
     - Parameter image: the requested image to find file size
     - returns: returns the size in Integer
     */
    static func getFileSizeOfImage(image: UIImage) -> Int {
        let imgData = NSData(data: image.jpegData(compressionQuality: 1.0)!)
        let imageSize: Int = imgData.count
        print("size of image in KB: %f ", Double(imageSize) / 1000.0)
        return imageSize
    }

    /// Prints all available fonts including the installed custom fonts
    static func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}
