# RePlate - Food Donation & Redistribution Platform

## 📱 App Information

**App Name:** RePlate

**GitHub Repository:** https://github.com/HASANALI117/RePlate

---

## 👥 Group Members

- Hasan Ali - 202303623
- Basem El Khayat - 202300488
- Abdulla Ebrahim - 202302970
- Ali Husain - 202305488
- Komail Husain - 202300533
- Mahmood Mubarak - 202202839

---

## ✨ Main Features

### 1. User Registration and Profile Setup

**Developer:** Basem Elkhayat  
**Tester:** Hasan Ali

### 2. User Authentication and Settings Management

**Developer:** Basem Elkhayat  
**Tester:** Hasan Ali

### 3. Create and Post Food Donation

**Developer:** Hasan Ali  
**Tester:** Basem Elkhayat

### 4. Browse and Search Donations

**Developer:** Hasan Ali  
**Tester:** Basem Elkhayat

### 5. Accept Donation and Schedule Pickup

**Developer:** Mahmood Ebrahim  
**Tester:** Abdulla Mohamed

### 6. Track Donation Status and Complete Pickup

**Developer:** Mahmood Ebrahim  
**Tester:** Abdulla Mohamed

### 7. Browse and Discover NGO Organizations

**Developer:** Abdulla Mohamed  
**Tester:** Komail Husain

### 8. NGO Verification and Admin Approval Process

**Developer:** Abdulla Mohamed  
**Tester:** Mahmood Ebrahim

### 9. Admin Panel for Managing Users and Overseeing Donation Flow

**Developer:** Ali Husain  
**Tester:** Mahmood Ebrahim

### 10. Community Impact Visualization and Platform Analytics

**Developer:** Ali Husain  
**Tester:** Komail Husain

### 11. In-App Messaging and Communication System

**Developer:** Komail Husain  
**Tester:** Ali Husain

### 12. Notification Management and Alert System

**Developer:** Ali Husain  
**Tester:** Komail Husain

---

## 🎁 Extra Features

### 1. Google Sign In

**Developer:** Hasan Ali

---

## 🎨 Design Changes

### 1. UI Architecture Migration

- Migrated DonationReviewViewController from Storyboard to programmatic UI
- Improved button interaction handling
- Better constraint management and performance

### 2. Simplified Donation Flow

- Streamlined 4-step process
- Removed current location button
- Simplified address input
- Enhanced pickup time handling

### 3. Enhanced Navigation Structure

- Modal presentation for donation creation flow
- Improved navigation between screens
- Added proper dismiss and navigation after successful donation
- Smooth transition to browse page after posting

---

## 📦 Libraries, Packages & External Code

### Firebase iOS SDK (v12.7.0+)

Managed via **Swift Package Manager (SPM)**

- `FirebaseCore` - Core Firebase functionality
- `FirebaseAuth` - User authentication
- `FirebaseDatabase` - Realtime Database
- `FirebaseStorage` - File storage

**Reference:** [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)

### Apple Frameworks

- `MapKit` - Location services and map display
- `PhotosUI` - Photo picker for donation images

**Reference:** [MapKit Documentation](https://developer.apple.com/documentation/mapkit)

---

## 🛠️ Project Setup Instructions

### Prerequisites

- **Xcode:** 16.4 or later
- **macOS:** with iOS 18.5+ SDK
- **Active internet connection** for Firebase

### Setup Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/HASANALI117/RePlate.git
cd RePlate
```

#### 2. Open the Project

```bash
open Replate.xcodeproj
```

Or open manually in Xcode.

#### 3. Firebase Configuration

- The project includes `GoogleService-Info.plist`
- Firebase is already configured (Project ID: `replate-95f0d`)
- No additional Firebase setup required

#### 4. Install Dependencies

- Dependencies are managed via Swift Package Manager
- Xcode should automatically resolve packages on first build
- If needed: **File > Packages > Resolve Package Versions**

#### 5. Build and Run

1. Select a simulator (iPhone 15 or later recommended)
2. Click Run (⌘R) or **Product > Run**
3. The app will build and launch in the simulator

### Troubleshooting

- Clean build folder: **Product > Clean Build Folder** (⇧⌘K)
- Ensure signing & capabilities are configured
- Verify Firebase packages are resolved

---

## 📱 Simulators Used for Testing

### Primary Testing Devices

- iPhone 15 Pro (iOS 18.5)
- iPhone 15 (iOS 18.5)
- iPhone 15 Pro Max (iOS 18.5)

### Secondary Testing Devices

- iPhone 14 Pro (iOS 18.5)

### Supported Orientations

- Portrait (Primary)
- Landscape Left
- Landscape Right

---

## 🔐 Admin/Test Login Credentials

### Test Donor Account

```
Email: donor@test.com
Password: test123
```

### Test Recipient Account

```
Email: recipient@test.com
Password: test123
```

> **Note:** Test accounts should be created in Firebase Authentication Console for the project (replate-95f0d)

---

**Last Updated:** January 2026
