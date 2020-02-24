//  String
//  StringExtension.swift
//  WKBoilerPlate
//
//  Created by Brian on 17/06/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {
    /**
     An enum for encryption and decryption
     */
    enum CodecType {
        case encode
        case decode
    }

    // MARK: - Field Validations

    /**
     String by trimming whitespaces and newline characters from the actual string
     */
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /**
     Makes the First letter of the string to UpperCase
     */
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    /**
     Makes the First letter of the string to UpperCase
     */
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    /**
     To check if the string is alphanumeric with no spaces
     - returns: true of false
     */
    var isAlphanumericWithNoSpaces: Bool {
        return rangeOfCharacter(from: CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted) == nil
    }

    /**
     To check if the string has only numbers
     - returns: true of false
     */
    var hasNumbers: Bool {
        return rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
    }

    /**
     To check if the string has only numbers
     - returns: true or false
     */
    var isNumeric: Bool {
        return Double(self) != nil
    }

    /**
     To check if the phone number is in valid format
     - checks if the phone number is between 10 to 15 digits.
     - returns: true if valid phone number format, false if not
     */
    func isValidPhoneNumber() -> Bool {
        if self.count >= 10 && self.count <= 15 {
            return self.isNumeric
        }
        return false
    }

    /**
     To remove formats from a phonenumber and convert it to just digits
     - Parameter number: phone number text to be trimmed
     - returns: a string with only the numbers in a phone number
     */
    func normalizePhoneNumber(_ number: String) -> String {
        let normalizationMapping = ["0": "0", "1": "1", "2": "2", "3": "3", "4": "4",
                                    "5": "5", "6": "6", "7": "7", "8": "8", "9": "9"]
        var targetString = String()
        for index in 0 ..< number.count {
            let oneChar = number[number.index(number.startIndex, offsetBy: index)]
            let keyString = String(oneChar).uppercased()
            if let mappedValue = normalizationMapping[keyString] {
                targetString.append(mappedValue)
            }
        }
        return targetString
    }

    /**
     To check if the text content is suitable to be a name
     - returns: true or false
     */
    func isValidName() -> Bool {
        let nameRegex = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: self)
    }

    /**
     Checks if the string is in a valid email format
     - returns: true or false
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    /**
     Checks if the string is in a valid password format for the app
     - returns: true or false
     */
    func isValidPassword() -> Bool {
        let pswdRegEx: String = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!#%*?&]{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pswdRegEx)
        return predicate.evaluate(with: self)
    }

    // MARK: - Localization
    /**
     To get the localized text from the strings file for the selected Language in UserDefaults
     - returns: localized string
     */
    func localizeText() -> String {
        guard let selectedLanguageBundlePath = Bundle.main.path(forResource: AppConfig.selectedLanguage,
                                                                ofType: "lproj") else {
            return  Bundle.main.path(forResource: "en", ofType: "lproj") ?? ""
        }
        let bundle = Bundle(path: selectedLanguageBundlePath)
        let result = NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        print("\(AppConfig.selectedLanguage)  ->  \(result)")
        return result
    }

    // MARK: - Conversions

    /**
     Converts string to dictionary format
     - Used to convert json strings to dictionary
     - returns: dictionary for the json string
     */
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    /**
     Encrypts the string to sha512 encryption
     - returns: encrypted string
     */
    func sha512() -> String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }

    /**
     Encrypts the string to sha512 encryption with hmac
     - hmac hash key will be retrived from Constants
     - returns: encrypted string
     */
    func hmacSHA512() -> String {
        let key: String = AppConfig.Credentials.encryptionHashKey
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), key, key.count, self, self.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }

    /**
     To encode or decode the string to
     - Parameter method: to specify encode or decode to be done
     - returns: base64 encoded/decoded string
     */
    func base64String(_ method: CodecType) -> String? {
        switch method {
        case .encode:
            guard let data = data(using: .utf8) else { return nil }
            return data.base64EncodedString()
        case .decode:
            guard let data = Data(base64Encoded: self) else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }

    // MARK: - Date Conversions

    /**
     Converts the date string to display format
     - Used in Wall posts to display the posted time
     - Converts from Format : "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
     - Converts to Format : "MMM dd, yyyy hh:mm a"
     - returns: formatted date
     */
    func getDateInDisplayFormat() -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date: Date = fmt.date(from: self) ?? Date()
        fmt.dateFormat = "MMM dd, yyyy hh:mm a"
        let dateStr = fmt.string(from: date)
        return dateStr
    }

    /**
     To convert a date string to Date
     - format - "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
     - locale - "en_US_POSIX"
     - returns: Date
     */
    func getDateFromString() -> Date {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let conDate = fmt.date(from: self)
        return conDate!
    }

    /**
     To convert a date string to the format required to be sent in API
     - format - "yyyy-MM-dd"
     - locale - "en_US_POSIX"
     - returns: Date
     */
    func getDateForAPIString() -> Date {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        let conDate = fmt.date(from: self)
        return conDate!
    }

    /**
     To convert a date string to the format required to be sent in API
     - format - "yyyy-MM-dd"
     - locale - "en_US_POSIX"
     - returns: Date
     */
    static func getStringFromDate(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        let conDate = fmt.string(from: date)
        return conDate
    }

    /**
     Get month string from the Date
     - format - "MMM"
     - locale - "en_US_POSIX"
     - returns: month string
     */
    static func getMonthStringFromDate(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "MMM"
        let conDate = fmt.string(from: date)
        return conDate
    }

    /**
     Get day string from the Date
     - format - "dd"
     - locale - "en_US_POSIX"
     - returns: day string
     */
    static func getDayStringFromDate(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "dd"
        let conDate = fmt.string(from: date)
        return conDate
    }

    /**
     Get year string from the Date
     - format - "yyyy"
     - locale - "en_US_POSIX"
     - returns: year string
     */
    static func getYearStringFromDate(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy"
        let conDate = fmt.string(from: date)
        return conDate
    }
}
