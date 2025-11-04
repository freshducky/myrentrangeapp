# MyRentRange Mobile App

Mobile version of MyRentRange.com - Rent affordability calculator for Flutter.

## Features

- **Rent Affordability Calculator**: Calculate what you can afford based on your income, location, and living situation
- **90+ Cities**: Comprehensive coverage of major US metros with neighborhood-level data
- **Bedroom Configuration**: Studio, 1BR, 2BR, 3+BR options with accurate rent multipliers
- **Theme System**: Light, Warm Light (anti-cortisol), Dark, and Auto themes
- **Calculation History**: Save and review your recent calculations
- **Zillow Data Integration**: Verified rent estimates using Zillow Home Value Index

## Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/freshducky/myrentrangeapp.git
cd my_rent_range_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## App Store Preparation

### Current Version
- Version: 1.0.0
- Build Number: 1

### Required Assets
- [ ] App icon (already exists)
- [ ] Screenshots for different screen sizes
- [ ] Privacy Policy URL: https://myrentrange.com/privacy
- [ ] Terms of Service URL: https://myrentrange.com/terms

### Testing Checklist
- [x] All themes work correctly (Light, Warm, Dark, Auto)
- [x] Settings persist across app restarts
- [x] History saves and loads correctly
- [x] No console errors
- [x] Performance acceptable

## Project Structure

```
lib/
  core/
    calculations/    # Rent calculation engine
    services/        # History and data services
  data/
    models/          # Data models (City, Neighborhood, etc.)
    sources/         # Data sources (cities, neighborhoods, Zillow)
  ui/
    screens/         # Main screens (Home, Settings, History)
    widgets/         # Reusable UI components
    theme/           # Theme configuration
```

## Dependencies

- `shared_preferences`: Persistent storage for settings and history
- `package_info_plus`: App version information
- `url_launcher`: Opening external links (Privacy Policy, Terms)
- `intl`: Internationalization and formatting
- `http`: HTTP requests (if needed for future API integration)

## Data Sources

- **Zillow Home Value Index (ZHVI)**: Used for rent estimates and trends
- **City Data**: 90+ cities with verified rent and income data
- **Neighborhood Data**: 87 neighborhoods across 7 major metros

## License

Private package - not for publication.

## Attribution

Powered by Zillow Data - Rent estimates use Zillow Home Value Index.
