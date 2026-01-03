# RePlate - Food Waste Reduction App

## Overview
RePlate is an iOS application designed to reduce food waste by connecting food donors with NGOs and individuals in need. The app facilitates the donation and distribution of surplus food through an intuitive mobile platform.

## Features
- **Admin Dashboard**: Platform overview and management tools
- **Donation Management**: Track and manage food donations with real-time status updates
- **Your Impact**: Personal impact tracking and analytics
- **User Authentication**: Secure login system with role-based access
- **Real-time Data**: Mock Firebase integration for live data synchronization

## Technical Requirements Met
- ✅ Swift UIKit with Storyboards
- ✅ iOS 18.2+ support (Xcode 16.2 compatible)
- ✅ iPhone and iPad compatibility (AutoLayout/Constraints)
- ✅ Mock Firebase backend integration (Auth, Analytics)
- ✅ Table View/Collection View Controllers
- ✅ Light/Dark mode support
- ✅ Launch screen with branding
- ✅ App icon and name

## Backend Integration
- **Mock Firebase**: Simulated real-time database for donations and user data
- **Mock Authentication**: Secure user login simulation
- **Mock Analytics**: User behavior tracking simulation
- **UserDefaults**: App preferences and session management

## Architecture
- **Pattern**: Model-View-Controller (MVC)
- **Data Storage**: Mock Firebase with local UserDefaults for preferences
- **UI Framework**: UIKit with programmatic Auto Layout
- **Design System**: Custom color palette and typography following Apple HIG

## Installation & Setup
1. Clone the repository
2. Open `RePlate.xcworkspace` in Xcode 16.2 (NOT .xcodeproj)
3. Build and run on iOS Simulator or device (iOS 18.2+)
4. Use demo credentials: admin@replate.com / demo123

## Test Data
The app includes comprehensive test data for demonstration:
- 5 sample donations with different statuses (Active, Claimed, Expired, Flagged)
- Admin dashboard metrics (2,847 users, 432 donations, 47 NGOs)
- Impact tracking data (24 donations made, 140 people helped)

## Team Members & Contributions
- **Ali**: Backend integration, Mock Firebase setup, authentication, data models
- **Omar**: UI implementation, design system, view controllers, navigation

## Assessment Requirements Compliance

### ✅ Feature & UI Requirements
- **App Name & Icon**: RePlate with custom app icon
- **Launch Screen**: Branded splash screen with logo and tagline
- **Apple HIG Compliance**: Follows Human Interface Guidelines
- **Table/Collection Views**: DonationListTableViewController & DonationGridCollectionViewController
- **Test Data**: Comprehensive demo data for all features
- **Build Status**: No warnings or errors in Xcode 16.2
- **Light/Dark Mode**: System adaptive color support
- **Universal Support**: iPhone and iPad compatibility with AutoLayout

### ✅ Data Storage & Backend Integration
- **Mock Firebase**: Simulated real-time database for donations
- **Mock Authentication**: Secure user login system simulation
- **Mock Analytics**: User behavior and screen tracking
- **UserDefaults**: App preferences and session management
- **Local Caching**: Offline data support

### ✅ Technical Implementation
- **Architecture**: Model-View-Controller (MVC) pattern
- **Swift UIKit**: Storyboards with programmatic Auto Layout
- **iOS Target**: 18.0+ with universal device support
- **Responsive Design**: AutoLayout constraints for all screen sizes

### 🎯 Demo Preparation
- **Live Demo Ready**: All features functional in iOS Simulator
- **Test Credentials**: admin@replate.com / demo123
- **Sample Data**: 5+ donations with various statuses
- **Navigation Flow**: Complete user journey from login to features

### 📱 Additional Features (Bonus)
1. **Real-time Analytics Dashboard**: Live metrics and performance tracking
2. **Advanced Status Management**: Comprehensive donation lifecycle tracking

## Demo Structure
1. **Introduction**: App overview and purpose (5 min)
2. **Live Demo**: Core features walkthrough (30 min)
   - Login and authentication
   - Admin dashboard navigation
   - Donation management interface
   - Impact tracking visualization
   - Table and Collection view demonstrations
3. **Q&A**: Technical implementation discussion (20 min)

## Build Information
- **Xcode Version**: 16.2
- **iOS Target**: 18.2+
- **Swift Version**: 6.0
- **Dependencies**: Firebase SDK 10.0+ (Mock implementations)
- **Build Status**: ✅ No warnings or errors

## Repository Structure
```
RePlate/
├── ViewControllers/     # Main app screens
├── Views/              # Custom UI components
├── Models/             # Data models
├── Utilities/          # Helper classes and extensions
├── Assets.xcassets/    # Images, colors, and app icon
└── Storyboards/        # Interface Builder files
```