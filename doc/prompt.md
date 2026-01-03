# Complete Xcode Project Generation Prompt for Amazon Q

## Project Overview
Create an iOS application named "RePlate" using Xcode 16.2 and macOS 15. The application should implement food donation management with admin functionality, matching exactly the Figma designs provided. The app should have three main user flows: Admin Dashboard, Donation Management, and User Impact visualization.

## Technical Specifications
- **Platform**: iOS 17.0+
- **Language**: Swift 5.9
- **UI Framework**: UIKit (not SwiftUI)
- **Architecture**: MVC with Storyboards
- **Device Support**: iPhone only (portrait)
- **Screen Size**: 430x932 points (iPhone 15 Pro Max equivalent)
- **Minimum Deployment**: iOS 17.0

## Required Screens & Storyboards

### 1. Main Storyboard (`Main.storyboard`)
```
- Navigation Controller (initial)
  - Login View Controller (root)
  - Tab Bar Controller (after login)
```

### 2. Login Screen (`LoginViewController.swift` + Storyboard)
**Design Reference**: File 1.jpeg
**Layout**:
- Background: White (#FFFFFF) with 30px corner radius and shadow
  - Shadow: 0px 30px 60px rgba(0, 0, 0, 0.25)
  - Corner radius: 30px
- Header: "RePlate" (large font), "Welcome Back" (subtitle)
- Email field: Pre-filled "john@example.com"
- Password field: Secure entry with placeholder
- Error message: "Incorrect password" (red text)
- "Forgot Password?" link (blue, underlined)
- "Sign in" button (green background, white text)
- Divider with "or" text
- "Don't have an account? Sign Up" link

**Code Requirements**:
```swift
// Use provided UIView shadow code from prompt
// Implement email/password validation
// Add keyboard handling
// Include transition to Admin Dashboard on successful login
```

### 3. Admin Dashboard (`AdminDashboardViewController.swift` + Storyboard)
**Design Reference**: admin_dashboard.png & CSS code in prompt
**Exact Measurements**: Use the provided CSS code for pixel-perfect layout

**Layout Components**:
- Status bar: White text on #357B49 background
- Header: "Admin Dashboard" (30px, white), "Platform Overview & Management" (13.3px, white 80%)
- Four metric cards (2x2 grid):
  1. Total Users (2,847)
    - Icon: Blue outline people icon (#2B7FFF)
    - Background: rgba(53, 123, 73, 0.1)
  2. Active Donations (432)
    - Icon: Green box icon (#2E8B57)
    - Background: rgba(53, 123, 73, 0.1)
  3. Verified NGOs (47)
    - Icon: Purple building icon (#AD46FF)
    - Background: rgba(53, 123, 73, 0.1)
  4. Total Impact (12.4K meals)
    - Icon: Orange chart icon (#FF8C42)
    - Background: rgba(53, 123, 73, 0.1)
- Pending Actions section (with "3" badge)
  - Three action items with timestamps and green check buttons
- Recent Activity section
  - Four activity items with icons and timestamps
- Quick Actions (2x2 grid):
  1. Manage Users (people icon)
  2. Review NGOs (building icon)
  3. View Donations (box icon)
  4. Flagged Content (alert icon)
- Bottom Tab Bar (5 items):
  - Dashboard (selected, green)
  - Users (gray)
  - Donations (gray)
  - NGOs (gray)
  - Settings (gray)

**Code Requirements**:
```swift
// Implement exact shadow effects from provided code:
// view.frame = CGRect(x: 0, y: 0, width: 430, height: 932)
// shadows with UIBezierPath, CALayer, shadowColor, shadowOpacity, shadowRadius
// Use SF Pro font system (fallback to system font)
// Implement scroll view for content
// Add tap handlers for all buttons and cards
```

### 4. Donation Management Screen (`DonationManagementViewController.swift`)
**Design Reference**: donation_management.png
**Layout**:
- Header: "Donation Management" with back button
- Search bar with placeholder "Search donations..."
- Four stat cards: Total (432), Active (264), Claimed (128), Flagged (2)
- Donation list (4 items):
  1. Box of Assorted Pastries (Corner Bakery)
  2. Fresh Organic Vegetables (Green Market)
  3. Home-cooked Indian Dinner (Priya's Kitchen)
  4. Deli Sandwiches (Downtown Deli)
- Each item shows: food type, time ago, claim count
- Bottom Tab Bar (Donations selected)

### 5. Your Impact Screen (`YourImpactViewController.swift`)
**Design Reference**: your_impact.png
**Layout**:
- Header: "Your Impact" with subtitle
- Four stat cards:
  1. Donations Made (24)
  2. People Helped (140)
  3. Food Rescued (287 lbs)
  4. Impact Score (95 - Top 10%)
- Monthly trend chart (Jan-Apr with bars)
- Achievements section (placeholder)
- Green checkmarks for positive trends

## Color Palette (Exact Values)
```swift
let primaryGreen = UIColor(red: 53/255, green: 123/255, blue: 73/255, alpha: 1) // #357B49
let seaGreen = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1) // #2E8B57
let coral = UIColor(red: 255/255, green: 140/255, blue: 66/255, alpha: 1) // #FF8C42
let heliotrope = UIColor(red: 173/255, green: 70/255, blue: 255/255, alpha: 1) // #AD46FF
let dodgerBlue = UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 1) // #2B7FFF
let redOrange = UIColor(red: 251/255, green: 44/255, blue: 54/255, alpha: 1) // #FB2C36
let ebony = UIColor(red: 16/255, green: 24/255, blue: 40/255, alpha: 1) // #101828
let paleSky = UIColor(red: 106/255, green: 114/255, blue: 130/255, alpha: 1) // #6A7282
let athensGray = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1) // #F9FAFB
```

## Font System
- Use SF Pro font family
- Font weights: Regular (400), Medium (590)
- Font sizes: Exactly as specified in CSS code (30px, 21.8px, 14.9px, 13.3px, etc.)
- Line heights: As per CSS specifications

## Required Files Structure
```
RePlate/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Assets.xcassets/
│   ├── AppIcon.appiconset
│   ├── Colors.colorset (all colors defined)
│   └── Icons (all vector icons from designs)
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
│   ├── PendingActionView.swift
│   ├── RecentActivityView.swift
│   └── QuickActionButton.swift
├── Models/
│   ├── User.swift
│   ├── Donation.swift
│   └── NGO.swift
└── Utilities/
    ├── ShadowHelper.swift (with exact shadow code from prompt)
    └── FontManager.swift
```

## Implementation Notes

### 1. Shadow Implementation
Use the exact shadow code provided in the prompt:
```swift
func applyCardShadow(to view: UIView) {
    let shadows = UIView()
    shadows.frame = view.frame
    shadows.clipsToBounds = false
    view.addSubview(shadows)
    
    let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
    let layer0 = CALayer()
    layer0.shadowPath = shadowPath0.cgPath
    layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    layer0.shadowOpacity = 1
    layer0.shadowRadius = 60
    layer0.shadowOffset = CGSize(width: 0, height: 30)
    layer0.bounds = shadows.bounds
    layer0.position = shadows.center
    shadows.layer.addSublayer(layer0)
    
    let shapes = UIView()
    shapes.frame = view.frame
    shapes.clipsToBounds = true
    view.addSubview(shapes)
    
    let layer1 = CALayer()
    layer1.backgroundColor = UIColor.white.cgColor
    layer1.bounds = shapes.bounds
    layer1.position = shapes.center
    shapes.layer.addSublayer(layer1)
    shapes.layer.cornerRadius = 30
}
```

### 2. Navigation Flow
```
Login → Admin Dashboard (default tab)
Tab Bar Navigation:
- Dashboard (admin home)
- Users (placeholder)
- Donations (Donation Management screen)
- NGOs (placeholder)
- Settings (placeholder)
```

### 3. Data Requirements
- Use mock data matching the screenshots
- Implement simple data models
- No backend connectivity required (static data)

### 4. Animation & Transitions
- Smooth tab transitions
- Button tap animations
- Scroll view bounce effects

### 5. Constraints
- All screens must match exact dimensions: 430x932 points
- Use Auto Layout with exact constraints from CSS
- Maintain aspect ratios for all elements

## Testing Requirements
- Builds without warnings in Xcode 16.2
- Runs on iOS 17+ simulator
- All buttons are tappable
- Scroll views work correctly
- Tab navigation functions properly

## Deliverables
1. Complete Xcode project with all files
2. Storyboards with exact layout matching Figma
3. All Swift code files with proper comments
4. Assets catalog with colors and icons
5. Info.plist configured correctly
6. README with build instructions

**Note**: The implementation must be pixel-perfect to the Figma designs. Use the exact measurements from the provided CSS code for the Admin Dashboard. All colors, fonts, spacing, and shadows must match exactly.

for the donation management screen use it from the below prompt:
# Updated Complete Xcode Project Generation Prompt for Amazon Q

## Project Overview
Create an iOS application named "RePlate" using Xcode 16.2 and macOS 15. The application should implement food donation management with admin functionality, matching exactly the Figma designs provided. The app should have three main user flows: Login, Admin Dashboard, Donation Management, and User Impact visualization.

## Technical Specifications
- **Platform**: iOS 17.0+
- **Language**: Swift 5.9
- **UI Framework**: UIKit (not SwiftUI)
- **Architecture**: MVC with Storyboards
- **Device Support**: iPhone only (portrait)
- **Screen Size**: 430x932 points (iPhone 15 Pro Max equivalent)
- **Minimum Deployment**: iOS 17.0

## Required Screens & Storyboards

### 1. Main Storyboard (`Main.storyboard`)
```
- Navigation Controller (initial)
  - Login View Controller (root)
  - Tab Bar Controller (after login)
```

### 2. Login Screen (`LoginViewController.swift` + Storyboard)
**Design Reference**: File 1.jpeg
**Layout**:
- Background: White (#FFFFFF) with 30px corner radius and shadow
  - Shadow: 0px 30px 60px rgba(0, 0, 0, 0.25)
  - Corner radius: 30px
- Header: "RePlate" (large font), "Welcome Back" (subtitle)
- Email field: Pre-filled "john@example.com"
- Password field: Secure entry with placeholder
- Error message: "Incorrect password" (red text)
- "Forgot Password?" link (blue, underlined)
- "Sign in" button (green background, white text)
- Divider with "or" text
- "Don't have an account? Sign Up" link

**Code Requirements**:
```swift
// Use provided UIView shadow code from prompt
// Implement email/password validation
// Add keyboard handling
// Include transition to Admin Dashboard on successful login
```

### 3. Admin Dashboard (`AdminDashboardViewController.swift` + Storyboard)
**Design Reference**: admin_dashboard.png & CSS code in prompt
**Exact Measurements**: Use the provided CSS code for pixel-perfect layout

**Layout Components**:
- Status bar: White text on #357B49 background
- Header: "Admin Dashboard" (30px, white), "Platform Overview & Management" (13.3px, white 80%)
- Four metric cards (2x2 grid):
  1. Total Users (2,847)
    - Icon: Blue outline people icon (#2B7FFF)
    - Background: rgba(53, 123, 73, 0.1)
  2. Active Donations (432)
    - Icon: Green box icon (#2E8B57)
    - Background: rgba(53, 123, 73, 0.1)
  3. Verified NGOs (47)
    - Icon: Purple building icon (#AD46FF)
    - Background: rgba(53, 123, 73, 0.1)
  4. Total Impact (12.4K meals)
    - Icon: Orange chart icon (#FF8C42)
    - Background: rgba(53, 123, 73, 0.1)
- Pending Actions section (with "3" badge)
  - Three action items with timestamps and green check buttons
- Recent Activity section
  - Four activity items with icons and timestamps
- Quick Actions (2x2 grid):
  1. Manage Users (people icon)
  2. Review NGOs (building icon)
  3. View Donations (box icon)
  4. Flagged Content (alert icon)
- Bottom Tab Bar (5 items):
  - Dashboard (selected, green)
  - Users (gray)
  - Donations (gray)
  - NGOs (gray)
  - Settings (gray)

### 4. Donation Management Screen (`DonationManagementViewController.swift`)
**Design Reference**: donation_management.png and provided CSS code
**Exact Layout from CSS Code**:

**Screen Container**:
- Dimensions: 430x932 points
- Background: White (#FFFFFF)
- Shadow: 0px 30px 60px rgba(0, 0, 0, 0.25)
- Corner radius: 30px
- Home indicator: 144x5px black rounded bar at bottom

**Header Section** (206.67px height):
- Background: #357B49
- Status bar with time (17px, SF Pro, 590 weight), cellular/wifi/battery icons
- Title: "Donation Management" (30px, white)
- Subtitle: "Platform Overview & Management" (13.3px, white 80%)
- Search bar: 398x43.67px, #F9FAFB background, 14px radius
  - Search icon (20x20px, gray)
  - Placeholder: "Search donations..." (14.5px, #0A0A0A at 50% opacity)

**Statistics Cards Section** (72px height):
- Four cards in horizontal layout, each 77x72px with 16px gap
  1. Total (432): Green tint background rgba(53, 123, 73, 0.1)
  2. Active (264): White background, green text (#357B49)
  3. Claimed (128): White background
  4. Flagged (2): Red tint background rgba(255, 56, 60, 0.1)

**Donation List Section** (504px scrollable height):
- Four donation cards, each 382.67x112px with white background and shadow
- Card 1: Box of Assorted Pastries
  - Icon: Green box on green tint background
  - Status: Active (green #00A63E)
  - Type: Cooked Meals • 2 hours ago
  - Claims: 3 claims
- Card 2: Fresh Organic Vegetables
  - Icon: Green box on green tint background
  - Status: Active (green #00A63E)
  - Type: Fresh Produce • 5 hours ago
  - Claims: 1 claim
- Card 3: Home-cooked Indian Dinner
  - Icon: Black box icon
  - Status: Claimed (black #0A0A0A)
  - Type: Cooked Meals • 1 day ago
  - Claims: 1 claim
- Card 4: Deli Sandwiches
  - Icon: Gray box on gray background
  - Status: Expired (gray #99A1AF)
  - Type: Cooked Meals • 2 days ago
  - Claims: 0 claims

**Bottom Tab Bar** (51px height):
- Same 5-tab structure as Admin Dashboard
- Donations tab selected (green icon and text #2E8B57)
- Other tabs inactive (gray #99A1AF)

**Code Requirements**:
```swift
// Implement exact layout from CSS code with scroll views
// Use Auto Layout constraints matching exact pixel measurements
// Create reusable donation card view component
// Implement search functionality
// Add tap handlers for donation cards
```

### 5. Your Impact Screen (`YourImpactViewController.swift`)
**Design Reference**: your_impact.png
**Layout**:
- Header: "Your Impact" with subtitle
- Four stat cards:
  1. Donations Made (24)
  2. People Helped (140)
  3. Food Rescued (287 lbs)
  4. Impact Score (95 - Top 10%)
- Monthly trend chart (Jan-Apr with bars)
- Achievements section (placeholder)
- Green checkmarks for positive trends

## Additional Color Palette for Donation Management
```swift
let greenHaze = UIColor(red: 0/255, green: 166/255, blue: 62/255, alpha: 1) // #00A63E
let codGray = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1) // #0A0A0A
let grayChateau = UIColor(red: 153/255, green: 161/255, blue: 175/255, alpha: 1) // #99A1AF
let redTint = UIColor(red: 255/255, green: 56/255, blue: 60/255, alpha: 0.1) // rgba(255, 56, 60, 0.1)
```

## Font System (Updated for Donation Management)
- SF Pro font family throughout
- Font weights: Regular (400), Medium (590)
- Exact font sizes from CSS:
  - Title: 30px (line height 36px)
  - Subtitle: 13.3px (line height 20px)
  - Search placeholder: 14.5px (line height 17px)
  - Stat numbers: 21.8px, 21.2px, 23.4px, 22.1px (all line height 32px)
  - Stat labels: 10.7px, 11.3px, 11.1px (all line height 16px)
  - Donation titles: 14.6px, 15.1px (line height 24px)
  - Donation subtitles: 12.9px, 13.2px, 12.8px, 13.3px (line height 20px)
  - Status labels: 11.1px, 11.3px (line height 16px)
  - Details: 13.2px, 13.6px, 12.7px, 13.1px (line height 20px)
  - Tab labels: 9.4px, 8.8px, 9.5px, 9.1px (line height 15px)

## Required Files Structure (Updated)
```
RePlate/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Assets.xcassets/
│   ├── AppIcon.appiconset
│   ├── Colors.colorset (all colors defined)
│   └── Icons/
│       ├── search.icon
│       ├── users.icon
│       ├── donations.icon
│       ├── ngo.icon
│       ├── settings.icon
│       ├── dashboard.icon
│       ├── active.icon
│       ├── claimed.icon
│       └── expired.icon
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
    ├── ShadowHelper.swift (with exact shadow code from prompt)
    ├── FontManager.swift
    └── ColorExtension.swift
```

## Implementation Details for Donation Management

### 1. Scroll View Implementation
```swift
// Main container scroll view as per CSS:
// position: absolute; width: 430px; height: 608px; top: 210px; overflow: scroll;
let scrollView = UIScrollView()
scrollView.frame = CGRect(x: 0, y: 210, width: 430, height: 608)
scrollView.contentSize = CGSize(width: 430, height: 504) // Content height
```

### 2. Statistics Cards Horizontal Layout
```swift
// Container for stats: 430x72px with 20px horizontal padding
// Four cards each 77x72px with 16px gap
let statsContainer = UIView()
statsContainer.frame = CGRect(x: 0, y: 0, width: 430, height: 72)

for i in 0..<4 {
    let card = StatCardView()
    card.frame = CGRect(x: 20 + (i * (77 + 16)), y: 0, width: 77, height: 72)
    // Apply specific backgrounds and colors per card
}
```

### 3. Donation Card Component
```swift
class DonationCardView: UIView {
    // Card: 382.67x112px with 16px padding
    // Icon container: 40x40px with tinted background
    // Title: 233.67x24px (or 222.67x24px for some)
    // Subtitle: same width, 20px height
    // Status indicator: variable width, 16px height
    // Details row: 350.67x20px with type, dot, time, and claims
}
```

### 4. Status Icons Implementation
```swift
// Active status icon (green check in circle):
func createActiveIcon() -> UIView {
    let icon = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
    // Vector paths from CSS:
    // left: 8.34%, right: 8.32%, top: 8.32%, bottom: 8.35% - circle
    // left: 37.5%, right: 8.33%, top: 16.67%, bottom: 41.66% - check mark
    return icon
}
```

### 5. Tab Bar Implementation
```swift
// Tab bar with 5 equal-width buttons (82.8px each)
// Selected tab: green icon (#2E8B57) and text
// Unselected tabs: gray icon (#99A1AF) and text (#6A7282)
// Icons are 24x24px with 2px border
```

## Navigation Flow
```
Login → Tab Bar Controller
Tab 1: Dashboard (AdminDashboardViewController)
Tab 2: Users (placeholder)
Tab 3: Donations (DonationManagementViewController)
Tab 4: NGOs (placeholder)
Tab 5: Settings (placeholder)
```

## Data Models
```swift
struct Donation {
    let id: String
    let title: String
    let donor: String
    let type: String // "Cooked Meals", "Fresh Produce"
    let status: DonationStatus // .active, .claimed, .expired
    let timeAgo: String
    let claimCount: Int
    let iconColor: UIColor
}

enum DonationStatus {
    case active
    case claimed
    case expired
    case flagged
}
```

## Testing Requirements
- All screens match exact Figma dimensions
- Scroll views work smoothly
- Tab navigation highlights correct tab
- Donation cards display correct status colors
- Search bar responds to input
- Builds without warnings in Xcode 16.2

## Deliverables
1. Complete Xcode project with all files
2. Storyboards with exact layout matching Figma
3. All Swift code files with proper comments
4. Assets catalog with colors and icons
5. Info.plist configured correctly
6. README with build instructions

**Critical Note**: The Donation Management screen must be implemented exactly as per the provided CSS code with pixel-perfect accuracy. All measurements, colors, fonts, and spacing must match exactly. The bottom tab bar should have the "Donations" tab selected (green) while other tabs are gray.