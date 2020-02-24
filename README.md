# Swift MVVM Boilerplate for iOS #


* Swift 5.0
* Deployment Target - iOS 11.0
* Devices - iPhone

### Frameworks used ###

* [Alamofire](https://github.com/Alamofire/Alamofire) Network calls manager
* [RealmSwift](https://cocoapods.org/pods/RealmSwift) Realm database
* [Firebase](https://firebase.google.com/) Firebase Notifications
* [TPKeyboardAvoiding](https://cocoapods.org/pods/TPKeyboardAvoiding) Handling keyboards and textfields in a scrollable screen
* [OHHTTPSTUBS](https://github.com/AliSoftware/OHHTTPStubs) To Stub the network requests. We use it for Unit Testing.
* [SwiftLint](https://github.com/realm/SwiftLint) Tool to enforce Swift style and conventions.

### How do I get set up? ###

* Edit app specific configurations in AppConfig.swift
* For firebase, replace the GoogleService-Info.plist.
* Folder named 'Common' can be added to your projects
* MVVM folder contains authentication module implementaion which can be used as reference for MVVM architecture.

### MVVM Pattern ###

Authentication module is implemented using MVVM design pattern. This can be used as a reference to follow MVVM architecture in your products.

This authentication module covers the following features:

* Email Signup, OTP Verification, Email Login, View/Edit Profile, Change Password, Logout

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



## **Project Setup**

* Install Cocoapod frameworks - In Terminal, goto project root folder and execute
```

$ pod install

```
* In AppConfig.swift, update BaseUrls of different environments


## **Testcase report generation** - [Scan](https://docs.fastlane.tools/actions/run_tests/)

Steps to generate a testcase report as html:

### In terminal, goto your project folder

```
cd <project folder path>
```

### INSTALL the **fastlane** tool called **scan**

```
$ sudo gem install scan
```

### To run the test and generate the report

```
$ fastlane scan

```

Report gets successfully generated in you project root folder under path '/test_output/report.html'. 
This output path will also be displayed in the terminal after generating the report.

**Please Note**: Remove this test_output folder after usage.

## **Add SwiftLint Support**

* Add SwiftLint to pod file 

```

pod 'SwiftLint'

```
* Add a Run script in your project settings - Build Phases

```

"${PODS_ROOT}/SwiftLint/swiftlint"

```
* Copy .swiftlint.yml from this boilerplate root folder to your project root. This will be a hidden file. To view hidden files, use the shortcut on your keyboard - cmd + shift + .

* Now you can build your project and see the warnings and errors thrown by SwiftLint. SwiftLint rules can be customised in the above yml file.
