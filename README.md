# Note Taking App

A note-taking application built with Flutter and Firebase. The app features user authentication, CRUD operations for notes, and a clean, maintainable architecture using the Provider package for state management.

## Features

- User authentication (sign up, login, logout) with Firebase Auth
- Create, read, update, and delete notes
- Responsive UI for mobile
- Clean architecture: separation of presentation, domain, and data layers
- Robust state management with Provider
- Error and success feedback with SnackBars
- Confirmation dialogs for destructive actions

## Architecture Overview

This project follows a **clean architecture** pattern:

```
lib/
├── core/           # Shared widgets and utilities
├── features/
│   ├── auth/
│   │   ├── data/      # Data sources, repositories
│   │   ├── domain/    # Providers (business logic)
│   │   └── presentation/ # UI screens and widgets
│   └── notes/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

### **Architecture Diagram**

```
+-------------------+
|   Presentation    |  <-- UI Widgets, Screens
+-------------------+
          |
          v
+-------------------+
|      Domain       |  <-- Providers (ChangeNotifier), Business Logic
+-------------------+
          |
          v
+-------------------+
|       Data        |  <-- Models, Repositories, Data Sources
+-------------------+
```

- **Presentation**: UI widgets and screens, only interact with providers.
- **Domain**: Providers (using Provider/ChangeNotifier), business logic, exposes state to UI.
- **Data**: Models and repositories, handles data fetching and persistence (e.g., Firebase).

## State Management

State is managed exclusively with the **Provider** package.

- All app state (authentication, notes) is handled by ChangeNotifier-based providers.
- No global `setState` calls are used outside trivial widget rebuilds.
- UI widgets listen to providers and rebuild only when relevant data changes.
- This ensures a predictable, maintainable, and scalable codebase.

**How it works:**

1. Providers are created in the domain layer and exposed to the widget tree using `ChangeNotifierProvider`.
2. UI widgets access and react to state changes via `Provider.of<T>(context)` or `Consumer<T>`.
3. All business logic and state mutations are encapsulated in the provider classes.

## Getting Started

### **Prerequisites**

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for setup)
- A Firebase project with Authentication enabled

### **Setup Steps**

1. **Clone the repository**

   ```sh
   git clone <your-repo-url>
   cd note_taking_app
   ```

2. **Install dependencies**

   ```sh
   flutter pub get
   ```

3. **Firebase setup**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable Email/Password authentication.
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the appropriate directories:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`
   - If using FlutterFire CLI, run:
     ```sh
     flutterfire configure
     ```

4. **Run the app**
   ```sh
   flutter run
   ```




