# Swift MVVM Boilerplate for iOS #


* Swift 5.0
* Deployment Target - iOS 11.0
* Devices - iPhone

### How do I get set up? ###

* Folder named 'Common' can be added to your projects
* Edit app specific configurations in AppConfig.swift, Constants.swift and the extensions of Color, Font
* For firebase, replace the GoogleService-Info.plist.
* MVVM folder contains an authentication module which can be used as reference for apps being build with Swift and MVVM

### Frameworks used ###

* [Alamofire](https://github.com/Alamofire/Alamofire) Network calls manager
* [RealmSwift](https://cocoapods.org/pods/RealmSwift) Realm database
* [Firebase](https://firebase.google.com/) Firebase Notifications
* [TPKeyboardAvoiding](https://cocoapods.org/pods/TPKeyboardAvoiding) Handling keyboards and textfields in a scrollable screen
* [OHHTTPSTUBS](https://github.com/AliSoftware/OHHTTPStubs) To Stub the network requests. We use it for Unit Testing.
* [SwiftLint](https://github.com/realm/SwiftLint) Tool to enforce Swift style and conventions.

### MVVM Pattern ###

Authentication module is implemented using MVVM design pattern. This can be used as a reference to follow MVVM architecture in your products.

This authentication module covers the following features:

* Email Signup
* OTP Verification
* Email Login
* Profile
* Edit Profile
* Change Password
* Logout

### Local database sample - Core Data ###

A sample screen is implemented with CoreData as local database. This CoreDataMembers classes can be used as reference for CoreData Operations.

* Gets Users list and handles database operations like create, update, delete and fetch.

### Local database sample - Realm ###

A sample screen is implemented with Realm as local database. This RealmMembers classes can be used as reference for Realm DB operations

* Gets Users list and handles database operations like create, update, delete and fetch.

### Offline Handling sample using Core Data ###

A sample to show how users can be added offline and synced later. This is done in the Core Data Sample class, CoreDataMembersViewModel.

### Network Stubbing using OHHTTPStubs  ###

A set of sample testcases to do unit testing by stubbing the network requests is written in MembersCoreDataTests.swift class.

### SwiftLint support ###

SwiftLint is added to enforce swift styles and conventions. 



# Note: Refer wiki for help on report generation and SwiftLint #