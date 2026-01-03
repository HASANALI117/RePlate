# RePlate iOS App

A comprehensive iOS application for food donation management, built according to exact Figma specifications with pixel-perfect accuracy.

## Project Overview

RePlate is an iOS app that helps reduce food waste by connecting food donors with NGOs and people in need. The app features:

- **Login Screen**: Clean authentication interface
- **Admin Dashboard**: Overview with metrics, pending actions, and quick actions
- **Donation Management**: Pixel-perfect implementation matching CSS specifications
- **Your Impact**: Personal impact tracking with statistics and charts
- **Tab Navigation**: 5-tab structure with proper state management

## Features

### 1. Login Screen
- Welcome interface with RePlate branding
- Email and password authentication
- Clean, modern design with green color scheme

### 2. Admin Dashboard
- Platform overview with key metrics
- Pending actions section with badge notifications
- Recent activity feed
- Quick action buttons (2x2 grid)
- Bottom tab navigation

### 3. Donation Management (Pixel-Perfect Implementation)
- **Exact CSS Implementation**: 430x932 points screen with precise measurements
- **Header Section**: 206.67px height with #357B49 background
- **Search Bar**: 398x43.67px with #F9FAFB background and 14px radius
- **Statistics Cards**: Four cards (77x72px each) with 16px gaps
- **Donation List**: Scrollable cards (382.67x112px each) with exact fonts and colors
- **Status Indicators**: Active (green), Claimed (black), Expired (gray), Flagged (red)
- **Home Indicator**: 144x5px black rounded bar

### 4. Your Impact Screen
- Personal statistics display
- Monthly trend chart (Jan-Apr)
- Achievement system (placeholder)
- Green checkmarks for positive trends

## Technical Implementation

### Architecture
- **MVC Pattern**: Clean separation of concerns
- **Storyboard-based UI**: Main.storyboard and Admin.storyboard
- **Reusable Components**: Custom views for cards, metrics, and UI elements
- **Exact Measurements**: All dimensions match Figma specifications

### Key Components
- `DonationCardView`: Pixel-perfect donation cards with exact CSS measurements
- `MetricCardView`: Reusable metric display cards
- `StatCardView`: Statistics cards for donation management
- `SearchBarView`: Custom search interface
- `TabBarView`: Custom tab bar with proper state management

### Color System
```swift
// Primary Colors
static let primaryGreen = #357B49
static let secondaryGreen = #2E8B57

// Donation Management Colors
static let greenHaze = #00A63E
static let codGray = #0A0A0A
static let grayChateau = #99A1AF
static let redTint = rgba(255, 56, 60, 0.1)
```

### Font System
- **SF Pro Font Family** throughout
- **Exact Font Sizes** from CSS specifications
- **Precise Line Heights** matching design requirements

## File Structure

```
RePlate/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Assets.xcassets/
│   ├── AppIcon.appiconset
│   ├── Colors.colorset
│   └── Icons/
├── Storyboards/
│   ├── Main.storyboard
│   └── Admin.storyboard
├── ViewControllers/
│   ├── LoginViewController.swift
│   ├── AdminDashboardViewController.swift
│   ├── DonationManagementViewController.swift
│   └── YourImpactViewController.swift
├── Views/
│   ├── MetricCardView.swift
│   ├── DonationCardView.swift
│   ├── StatCardView.swift
│   ├── SearchBarView.swift
│   └── TabBarView.swift
├── Models/
│   ├── User.swift
│   ├── Donation.swift
│   └── NGO.swift
└── Utilities/
    ├── ShadowHelper.swift
    ├── FontManager.swift
    └── ColorExtension.swift
```

## Build Instructions

### Requirements
- Xcode 16.2 or later
- iOS 15.0+ deployment target
- Swift 5.0+

### Setup
1. Open the project in Xcode
2. Select your development team in project settings
3. Choose a simulator or connected device
4. Build and run (⌘+R)

### Navigation Flow
```
Login → Tab Bar Controller
├── Tab 1: Dashboard (AdminDashboardViewController)
├── Tab 2: Users (placeholder)
├── Tab 3: Donations (DonationManagementViewController) ← Selected by default
├── Tab 4: NGOs (placeholder)
└── Tab 5: Settings (placeholder)
```

## Key Implementation Details

### Donation Management Screen
- **Exact CSS Implementation**: All measurements, colors, and fonts match the provided CSS code
- **Scroll View**: 430x608px container with 504px content height
- **Statistics Cards**: Horizontal layout with precise 77x72px cards and 16px gaps
- **Donation Cards**: 382.67x112px cards with exact icon positioning and typography
- **Status Colors**: Precise color matching for all donation states

### Shadow System
```swift
// Main container shadow: 0px 30px 60px rgba(0, 0, 0, 0.25)
ShadowHelper.applyMainContainerShadow(to: view)

// Card shadows for donation cards
ShadowHelper.applyCardShadow(to: cardView)
```

### Font Management
```swift
// Exact font sizes from CSS specifications
static let titleFont = UIFont.systemFont(ofSize: 30, weight: .medium)
static let subtitleFont = UIFont.systemFont(ofSize: 13.3, weight: .regular)
static let searchPlaceholderFont = UIFont.systemFont(ofSize: 14.5, weight: .regular)
```

## Testing

The app has been tested to ensure:
- ✅ All screens match exact Figma dimensions
- ✅ Scroll views work smoothly
- ✅ Tab navigation highlights correct tab
- ✅ Donation cards display correct status colors
- ✅ Search bar responds to input
- ✅ Builds without warnings in Xcode 16.2

## Data Models

### Donation Model
```swift
struct Donation {
    let id: String
    let title: String
    let donor: String
    let type: String // "Cooked Meals", "Fresh Produce"
    let status: DonationStatus // .active, .claimed, .expired, .flagged
    let timeAgo: String
    let claimCount: Int
    let iconColor: UIColor
}
```

### Status System
```swift
enum DonationStatus {
    case active    // Green (#00A63E)
    case claimed   // Black (#0A0A0A)
    case expired   // Gray (#99A1AF)
    case flagged   // Red (#FF383C)
}
```

## Critical Implementation Notes

1. **Pixel-Perfect Accuracy**: The Donation Management screen is implemented exactly as per the provided CSS code with precise measurements, colors, fonts, and spacing.

2. **Tab Bar State**: The "Donations" tab is selected (green) while other tabs remain gray, as specified in the requirements.

3. **Exact Measurements**: All dimensions follow the CSS specifications:
   - Screen: 430x932 points
   - Header: 206.67px height
   - Search bar: 398x43.67px
   - Stat cards: 77x72px each
   - Donation cards: 382.67x112px each

4. **Font Precision**: All font sizes match the exact CSS specifications, including line heights and weights.

5. **Color Accuracy**: All colors are implemented with exact hex values from the design specifications.

## Future Enhancements

- User authentication with backend integration
- Real-time donation updates
- Push notifications for new donations
- Advanced filtering and search
- Geolocation-based matching
- Photo upload for donations
- Rating and review system

## License

This project is created for educational purposes as part of the IT8108 Project Demonstration Assessment.