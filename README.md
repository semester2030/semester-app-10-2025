# Semester Student Ride App 🚗

A comprehensive Flutter-based ride sharing application designed specifically for university students and drivers.

## 📱 Project Overview

This is a complete ride sharing platform that connects students with drivers within university campuses. The app features separate interfaces for students and drivers, real-time tracking, payment integration, and advanced notification systems.

## 🏗️ Architecture

- **Frontend**: Flutter 3.3+ with Dart 3.0+
- **Backend**: Firebase Suite (Authentication, Firestore, Cloud Functions)
- **Maps**: Google Maps API integration
- **State Management**: Riverpod
- **Code Generation**: Freezed
- **Routing**: Go Router
- **Notifications**: Firebase Cloud Messaging (FCM)

## 📊 Project Statistics

- **Total Files**: 297 Dart files
- **Screens**: 122 screens
- **Services**: 36 services
- **Models**: 25 models
- **Widgets**: 47 widgets
- **Cloud Functions**: 1 Cloud Function

## 🚀 Features

### ✅ Completed Features (70%)

#### Authentication System (100% Complete)
- Complete login system with Firebase Authentication
- Separate registration for students and drivers
- Multi-step registration flow
- Error handling and validation

#### User Interface (90% Complete)
- **Student Interface**: Complete with all features
- **Driver Interface**: Separate interface with trip management
- **Navigation**: Bottom navigation with multiple tabs
- **Settings**: Comprehensive settings system

#### Notification System (75% Complete)
- Firebase Cloud Messaging integration
- Push notifications
- In-app notifications
- 15+ Cloud Functions for notifications

### 🔄 In Progress Features (20%)

#### Booking System (40% Complete)
- Booking interfaces exist
- Service layer implemented
- ⚠️ **TODO**: Connect with Firebase backend

### ❌ Pending Features (10%)

#### Payment System (25% Complete)
- Payment UI components exist
- RevenueCat configured in Cloud Functions
- ❌ **Missing**: payment_service.dart
- ❌ **Missing**: Payment gateway integration

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK 3.3+
- Dart 3.0+
- Android Studio / VS Code
- Firebase CLI
- Git
- Node.js (for Cloud Functions)
- Google Maps API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Semester--Student-Ride-App-
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase (if not already done)
   firebase init
   ```

4. **Configure Google Maps**
   - Get Google Maps API key
   - Add to `lib/config/google_maps_config.dart`

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── config/           # Configuration files
├── constants/        # App constants
├── enums/           # Enumerations
├── l10n/            # Localization files
├── models/          # Data models (25 files)
├── providers/       # State management (24 files)
├── screens/         # UI screens (122 files)
├── services/        # Business logic (36 files)
├── utils/          # Utility functions (25 files)
├── widgets/         # Reusable widgets (47 files)
└── view_models/     # View models (1 file)

functions/           # Firebase Cloud Functions
├── index.js         # Main Cloud Functions file
├── package.json     # Node.js dependencies
└── package-lock.json

assets/              # Static assets
├── data/           # JSON data files
├── icons/          # App icons
├── images/         # Images
└── logo/           # Logo files
```

## 🔧 Development Phases

### Phase 1: Fix Fundamentals (1 Week)
- [ ] Fix current code errors
- [ ] Connect booking system with Firebase
- [ ] Complete OTP verification system
- [ ] Improve user interface
- [ ] Add more tests

### Phase 2: Payment System (1 Week)
- [ ] Develop payment_service.dart
- [ ] Integrate RevenueCat
- [ ] Test payment system
- [ ] Improve payment interface
- [ ] Add more payment methods

### Phase 3: Core Features (1 Week)
- [ ] Complete document upload system
- [ ] Improve notification system
- [ ] Add rating system
- [ ] Improve tracking system
- [ ] Add more features

### Phase 4: Testing & Deployment (1 Week)
- [ ] Comprehensive app testing
- [ ] Fix discovered errors
- [ ] Improve security
- [ ] Prepare for deployment
- [ ] Final documentation

## 📱 Screenshots

*Screenshots will be added here*

## 🧪 Testing

```bash
# Run tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release
```

## 📝 API Documentation

### Firebase Collections
- `users` - User profiles
- `bookings` - Ride bookings
- `offers` - Driver offers
- `messages` - Chat messages
- `notifications` - User notifications

### Cloud Functions
- `sendNotification` - Send push notifications
- `handleRevenueCatWebhook` - Process payments
- `createBooking` - Create new booking
- `updateBookingStatus` - Update booking status

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Project Manager**: [Name]
- **Lead Developer**: [Name]
- **UI/UX Designer**: [Name]

## 📞 Support

For support, email [email] or create an issue in this repository.

## 🔄 Changelog

### Version 1.0.0 (Current)
- Initial release
- Authentication system
- Basic UI implementation
- Notification system
- Cloud Functions setup

---

**📅 Last Updated**: September 27, 2025  
**🔄 Status**: 70% Complete - Development Phase  
**⏱️ Expected Completion**: 4 weeks (280 hours)