![](https://img.shields.io/badge/build-1.0.0+2-brightgreen)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)




<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/najeebaslan/AppIssue">
    <img src="assets/images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h2 align="center">Prison Dates</h2>

  <p align="center">
     Complete management of prisoners' appointments.
    <br />
    <br />
  <a href='https://play.google.com/store/apps/details?id=najeeb.aslan.issue&pcampaignid=web_share'>
<img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" width="150">
</a>
<a href='https://apps.apple.com/ye/app/6746951512?platform=iphone'>
<img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" width="150">
</a>
  </p>
</div>

## About The Project
This application allows you to add the accused and manage all his data in terms of modification, deletion, etc. It shows alerts when the time available for the accused expires and the time specified for alerting is the first week from the date of adding the accused, then after forty-five days, then also after another forty-five days.

# Application Screens:(Screens 20+)
<table>
  <tr>
    <td><img src="screen_shoots/onboarding4.png" alt="Image 2"></td>
    <td><img src="screen_shoots/onboarding3.png" alt="Image 2"></td>
    <td><img src="screen_shoots/onboarding2.png" alt="Image 2"></td>
    <td><img src="screen_shoots/onboarding1.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/onboarding5.png" alt="Image 2"></td>
    <td><img src="screen_shoots/for_got_password.png" alt="Image 2"></td>
    <td><img src="screen_shoots/login.png" alt="Image 2"></td>
    <td><img src="screen_shoots/signup.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/empty_home_view.png" alt="Image 2"></td>
    <td><img src="screen_shoots/filter_view.png" alt="Image 2"></td>
    <td><img src="screen_shoots/selected_accused.png" alt="Image 2"></td>
    <td><img src="screen_shoots/home_view.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/filter_bottom_sheet.png" alt="Image 2"></td>
    <td><img src="screen_shoots/add_accused.png" alt="Image 2"></td>
    <td><img src="screen_shoots/notifications_view.png" alt="Image 2"></td>
    <td><img src="screen_shoots/profile.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/settings.png" alt="Image 2"></td>
    <td><img src="screen_shoots/setting_english.png" alt="Image 2"></td>
    <td><img src="screen_shoots/upload_image_profile_light.png" alt="Image 2"></td>
    <td><img src="screen_shoots/delete_my_account.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/choose_backup.png" alt="Image 2"></td>
    <td><img src="screen_shoots/get_backups.png" alt="Image 2"></td>
    <td><img src="screen_shoots/change_language.png" alt="Image 2"></td>
    <td><img src="screen_shoots/choose_type_backup.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/onboarding1_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/for_got_password_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/signup_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/home_dark.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/details_accused_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/loading_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/selected_backup_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/create_backup_dark.png" alt="Image 2"></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screen_shoots/biometrics.png" alt="Image 2"></td>
    <td><img src="screen_shoots/notification_view_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/search_history_dark.png" alt="Image 2"></td>
    <td><img src="screen_shoots/empty_filter_dark.png" alt="Image 2"></td>
  </tr>
</table>

# Table of contents
 - [Features](#features)
 - [Technologies Used](#technologies-used)
 - [Application structure](#application-structure)
 - [Support](#platform-support)
 - [Libraries and tools used](#libraries-and-tools-used)
 - [Prerequisites](#prerequisites)
 - [Installation](#installation)

## ✨Features
  - Alerts after one week of adding the accused, known as the first alert.
  - An alert after forty-five days from the first alert, known as the second alert.
  - An additional alert after forty-five days from the second alert, known as the third alert, which is the final notification to inform you of the complete end of the charge. 
  - Ability to add a new accused.
  - Modify the accused's details when necessary.
  - End the charge against the accused.
  - Delete the accused from the system.
  - Share the charge as file PDF 📂.
  - Search - Filter - Sort Details 🔍.
  - Manage backups (add,delete,restore) and support auto backup [daily-weekly-monthly].
  - Manage notifications enable or disable it,and deleted from Database[daily-weekly-monthly] 🔔. 
  - Support two languages Arabic - English (🇸🇦,🇺🇸).
  - Support Dark and Light Mode (☽,☀️).
  - Able to change profile and delete account.
  - The application provides strong protection when logging in via fingerprint or iris scanner, ensuring your data is secure from tampering.

## Technologies Used

  - Frontend: Flutter(version: 3.29.2,Channel stable)
 
  - Database: Sqflite,cloud_firestore,firebase_storage
  - Authentication: Firebase_auth,Google_sign_in,ign_in_with_apple

# Platform Support
| Android | iOS |
| :-----: | :-: |
|   ✔️    | ✔️  |



## Application structure

After successful build, your application structure should look like this:

```
├── android         - Contains the necessary files to run the application on an Android 
├── assets          - Stores all images,fonts and translations used in the application.
├── ios             - Includes the files required to run the application on an iOS platform.
├── lib             - The core folder for writing the majority of the Dart code.
├── main.dart       - The entry point of the application.
├── core
│   ├── extensions  - Holds commonly used file extensions for enhanced functionality. 
│   ├── helper      - Contains commonly used file imports to assist in development.
│   ├── networking  - Includes commonly used imports for networking tasks.
│   ├── router      - Manages commonly used imports for routing within the application.
│   ├── services    - Handles commonly used imports for various services.
│   ├── theme       - Handles theme-related configurations for consistent visual styling.
│   ├── constants   - Stores commonly used constants like asset paths, icons, and default settings.
│   ├── widgets     - Provides commonly used imports for reusable widgets.
├── data
│   ├── database    - Manages the app's local database configuration.
│   ├── models      - Defines data models that represent the structure of data used throughout the app.
│   ├── repositories- Encapsulates data access logic, providing a clean API for data retrieval.
├── features        - Contains the application's feature modules for organized development.
│   ├─── auth feature     - Manages authentication-related functionality,
│   ├─── accused feature  - Handles to managing accused individuals, including adding, editing.
│   ├─── backup feature   - Implements functionality for backing up user data securely.
│   ├─── filter feature   - Provides filtering options for displaying lists of accused individuals.
│   ├─── home feature     - Manages displaying relevant information and navigation options.
│   ├─── settings feature - Handles application settings, allowing for customization and configuration.
│   ├─── onboarding feature - Manages the onboarding process for new users,show them initial features.
│   ├─── notifications feature -Implements push notifications and in-app alerts to keep users informed.
└── app.dart  -The main application file that initializes the app and sets up the entry point.
```
## ⚙️ Libraries and tools used 
I will explain the packages that are important to know before starting the project.
- [flutter_bloc](https://pub.dev/packages/flutter_bloc):-as State Management.
- [workmanager](https://pub.dev/packages/workmanager):-Schedule tasks in the background on Android and IOS
- [sqflite](https://pub.dev/packages/sqflite):- Local database.
- [googleapis](https://pub.dev/packages/googleapis):-manage backups with `Google Drive`
- [firebase_auth](https://pub.dev/packages/firebase_auth):- use it for manage auth like Email/Password and google and apple sign-in.
- [cloud_firestore](https://pub.dev/packages/cloud_firestore):-save user details like image name and other information.
- [firebase_storage](https://pub.dev/packages/firebase_storage):-store images application.
- [easy_localization](https://pub.dev/packages/easy_localization):-Easy and Fast internationalizing and localization.
- [get_it](https://pub.dev/packages/get_it):-This for injection dependency.
- [local_auth](https://pub.dev/packages/local_auth):-Allow local authentication via fingerprint, touch ID, face ID, passcode, pin, or pattern.
- [google_sign_in](https://pub.dev/packages/google_sign_in):- To able to connect with your google drive should allow application to connect with your account by this package.
- [envied](https://pub.dev/packages/envied):-Explicitly reads environment variables into a dart file from a .env file for more security and faster start up times.
- [encrypt](https://pub.dev/packages/encrypt):-Use it for encrypted and decrypted backups.
## Installation
1 Clone the repository:
```bash
git clone https://github.com/najeebaslan/AppIssue.git
```
## Prerequisites
🕒 Setup Work Manager
- ⇢  Setup with (IOS OS):
- 1- Go to file ios/Runner/AppDelegate.swift and add ```import workmanager```.
- 2- Add this code  
``` 
Bool{
UNUserNotificationCenter.current().delegate = self
WorkmanagerPlugin.setPluginRegistrantCallback {
 registry in GeneratedPluginRegistrant.register(with: registry)
} }
```
- 3- Add outside the ```Bool{}``` breakpoint this code for show notification in foreground
```
override func userNotificationCenter(
_ center: UNUserNotificationCenter,
willPresent notification: UNNotification,
withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
completionHandler(.alert) // shows banner even if app is in foreground
}
```

For more information open this link
[here](https://docs.page/fluttercommunity/flutter_workmanager/quickstart)

- 4- Add this code in ios/Runner/Info.plist
``` 
<key>UIBackgroundModes</key>
<array>
<string>fetch</string>
<string>processing</string>
</array>
<!-- If you want know why do this look the link https://poe.com/s/oMOikdWDl6F5svpSgdzg -->
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
<string>task-identifier</string>
<string>com.example.issues_new_version0</string><!-- First task at 8:00 AM -->
<string>com.example.issues_new_version1<!-- Second task at 8:00 PM -->
</array>
```
* Note==> Replace [```com.example.issues_new_version0``` and ```com.example.issues_new_version1```] by your task identifier 

- 5- Add file sound like this:- ```ios/notification_sound.wav```

* Note:- now you are ready for test task with ```Iphone```.
  But if you using ios simulator should by do some steps below
- Open ios folder with `XCode` and then open ios/Runner/AppDelegate.swift
- Click breakpoint on ```override func application```
- Run project and the it's when the `XCode` will stop in your breakpoint 
- open terminal form `XCode` it's found it in the bottom screen
- Paste this code and click enter
```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.example.issues_new_version0"]
```
- Click button `Debug` and selected `Simulate Background Fetch` 
- Then pressed icon ▶️ from `terminal` 
### ⚠️ Important Notes
* replace ``com.example.issues_new_version0`` by your task identifier
 <td><img src="screen_shoots/setup_AppDelegate.png" alt="Image 2"></td>
    <td><img src="screen_shoots/first_step.png" alt="Image 2"></td>
    <td><img src="screen_shoots/second_step.png" alt="Image 2"></td>
    <td><img src="screen_shoots/result.png" alt="Image 2"></td>
  </tr>
</table> -->

- ⇢ Setup with (Android OS)
- 1- Go to the following path 
`android/app/src/main/kotlin/com/example/issues_new_version/MainActivity.kt`
and Replace it by this code
```
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {

}
```
- 2- Add permission in file path `android/app/src/main/AndroidManifest.xml`
```<uses-permission android:name="android.permission.USE_BIOMETRIC"/>```


◉ Setup splash screen images 
- 1-The create the box by size 640*640. 
- 2-After that make the radius 320... and  so i do that because the android 12 required the steps.
- 3-And after that add it inside box by size 960*960 in the center position

◉ Change App Name And PackageID
- 1- Change application name [rename](https://pub.dev/packages/rename) or go to 
`android/app/src/main/AndroidManifest.xml` and change ```android:label="yourAppName"```
- 2- Change application, To avoid inevitable problems use [rename](https://pub.dev/packages/rename) 

[![Firebase](https://skillicons.dev/icons?i=firebase)](https://skillicons.dev)

◉ Setup Firebase 
- 1- Use cli for integration with firebase 
- 2- Make sure change app name and PackageID
- 3- Make sure to add sha1 and sha254
- 4- Enable  Sign-in method ``Email/Password`` and ``Google``
## ⚠️ Important Notes
- 5-When enable the `firestore Database` choose the location ```europe-west6```
because it's nearly server database for arabic countries

- 6- Replace your `firestore Database Rules` by this Rules
```
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read data
    match /{document=**} {
      allow read;
    }

    // Allow authenticated users to write data
    match /{document=**} {
      allow write: if request.auth != null;
    }
  }
}
```
- 7- Enable firebase storage and update `Rules` like this 
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read;
      allow write: if true;
    }
  }
}
```
<!-- [![Google](https://skillicons.dev/icons?i=gcp)](https://skillicons.dev) -->
<img src="assets/images/googleDrive.png" alt="Logo" width="30" height="30">
◉ Setup Google Drive
- 1- Enable Google Drive api from google console  

[contributors-shield]: https://img.shields.io/github/contributors/astubenbord/paperless-mobile.svg?style=for-the-badge

◉ Setup ENCRYPTION_KEY for using it when do encryption backups
- 1- Create file by name ```.env.dev``` in the root project
- 2- Add this line```ENCRYPTION_KEY =(Add here key base64)```
- 3- Run this code in root project terminal 
```
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### versions used 
<details open><summary>Doctor output</summary>

```console
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.29.2, on macOS 14.5 23F79 darwin-arm64, locale en-YE)
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2025.1)
[✓] VS Code (version 1.103.2)
[✓] Connected device (3 available)
[✓] Network resources

• No issues found!
```

</details>

MIT: https://mit-license.org.

Copyright (c) 2025 Najeeb Aslan. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<!-- https://icon.kitchen -->
Minor update
