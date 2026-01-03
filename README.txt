================================================================================
                              REPLATE - README
================================================================================

APP NAME:
---------
RePlate


GITHUB LINK:
------------
https://github.com/HASANALI117/RePlate


GROUP MEMBERS:
--------------
Hasan Ali - 202303623
Basem El Khayat - 202300488
Abdulla Ebrahim - 202302970
Ali Husain - 202305488
Komail Husain - 202300533
Mahmood Mubarak - 202202839


MAIN FEATURES:
--------------

1. User Registration and Profile Setup
   Developer: Basem Elkhayat
   Tester: Hasan Ali

2. User Authentication and Settings Management
   Developer: Basem Elkhayat
   Tester: Hasan Ali

3. Create and Post Food Donation
   Developer: Hasan Ali
   Tester: Basem Elkhayat

4. Browse and Search Donations
   Developer: Hasan Ali
   Tester: Basem Elkhayat

5. Accept Donation and Schedule Pickup
   Developer: Mahmood Ebrahim
   Tester: Abdulla Mohamed

6. Track Donation Status and Complete Pickup
   Developer: Mahmood Ebrahim
   Tester: Abdulla Mohamed

7. Browse and Discover NGO Organizations
   Developer: Abdulla Mohamed
   Tester: Komail Husain

8. NGO Verification and Admin Approval Process
   Developer: Abdulla Mohamed
   Tester: Mahmood Ebrahim

9. Admin Panel for Managing Users and Overseeing Donation Flow
   Developer: Ali Husain
   Tester: Mahmood Ebrahim

10. Community Impact Visualization and Platform Analytics
    Developer: Ali Husain
    Tester: Komail Husain

11. In-App Messaging and Communication System
    Developer: Komail Husain
    Tester: Ali Husain

12. Notification Management and Alert System
    Developer: Ali Husain
    Tester: Komail Husain


EXTRA FEATURES:
---------------
1. Google Sign In
   Developer: Hasan Ali


LIBRARIES, PACKAGES & EXTERNAL CODE:
-------------------------------------
1. Firebase iOS SDK (v12.7.0+)
   - FirebaseCore
   - FirebaseAuth
   - FirebaseDatabase (Realtime Database)
   - FirebaseStorage
   Package Manager: Swift Package Manager (SPM)
   Reference: https://firebase.google.com/docs/ios/setup

2. MapKit (Apple Framework)
   - Location services
   - Map display in donation location selection
   Reference: https://developer.apple.com/documentation/mapkit

3. PhotosUI (Apple Framework)
   - Photo picker for donation images
   - PHPickerViewController implementation


PROJECT SETUP INSTRUCTIONS:
----------------------------
1. Prerequisites:
   - Xcode 16.4 or later
   - macOS with iOS 18.5+ SDK
   - Active internet connection for Firebase

2. Clone the Repository:
   git clone https://github.com/HASANALI117/RePlate.git
   cd RePlate

3. Open the Project:
   - Open Replate.xcodeproj in Xcode

4. Firebase Configuration:
   - The project includes GoogleService-Info.plist
   - Firebase is already configured (Project ID: replate-95f0d)
   - No additional Firebase setup required

5. Install Dependencies:
   - Dependencies are managed via Swift Package Manager
   - Xcode should automatically resolve packages on first build
   - If needed: File > Packages > Resolve Package Versions

6. Build and Run:
   - Select a simulator (iPhone 15 or later recommended)
   - Click Run (⌘R) or Product > Run
   - The app will build and launch in the simulator

7. Troubleshooting:
   - Clean build folder: Product > Clean Build Folder (⇧⌘K)
   - Ensure signing & capabilities are configured
   - Verify Firebase packages are resolved


SIMULATORS USED FOR TESTING:
-----------------------------
Testing Devices:
- iPhone 15 Pro Max (iOS 18.5)

ADMIN/TEST LOGIN CREDENTIALS:
------------------------------
Email: admin@gmail.com
Password: admin1234

================================================================================
                         END OF README
================================================================================
