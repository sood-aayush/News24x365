# 📰 News 24x365 - Your Daily Dose of News

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)](https://dart.dev/)
## ✨ Overview
News 24x365 is a modern, cross-platform news application built with Flutter. It allows users to browse the latest articles, filter by categories, search for specific topics, mark articles as favorites, and receive local notifications for new content. The app consumes data from a WordPress REST API endpoint.
## 🚀 Features* **Latest News Feed:** Displays the most recent articles from the configured API endpoint.* **Category Filtering:** Easily filter news articles by different categories.* **Article Search:** Powerful search functionality to find articles by keywords.* **Detailed Article View:** Read full articles with rich HTML content and embedded images.* **Favorites System:** Mark articles as favorites for quick access later (locally stored).* **Theme Switching:** Seamlessly switch between Light and Dark modes for a comfortable reading experience.* **Local Notifications:** Receive alerts for new articles (requires app to be active or basic periodic notification setup).* **Share Articles:** Share news articles with others directly from the app.* **Responsive UI:** Adapts to various screen sizes and orientations.
---
## 🛠️ Technologies Used* 
**Flutter:** UI Toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.* **Dart:** Programming language for Flutter.* [`http`](https://pub.dev/packages/http): For making HTTP requests to the WordPress REST API.* [`provider`](https://pub.dev/packages/provider): For state management (e.g., ThemeProvider).* [`shared_preferences`](https://pub.dev/packages/shared_preferences): For local data storage (favorites, theme preference, last seen post ID).* [`cached_network_image`](https://pub.dev/packages/cached_network_image): For efficient caching and display of network images.* [`flutter_html`](https://pub.dev/packages/flutter_html): For rendering HTML content from API responses.* [`share_plus`](https://pub.dev/packages/share_plus): For sharing article links.* [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications): For managing and displaying local notifications.* [`timezone`](https://pub.dev/packages/timezone): Required by `flutter_local_notifications` for scheduling.* [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons): Dev dependency for generating app icons.
---
## ⚙️ Getting Started

Follow these steps to set up and run the project locally.
### Prerequisites* 
[Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x or higher recommended)* 
[Android Studio](https://developer.android.com/studio) / [VS Code](https://code.visualstudio.com/) with Flutter extensions* An Android or iOS emulator/device
### Installation1.  **Clone the repository:** ```bash
    git clone [https://github.com/your-username/news_app.git](https://github.com/your-username/news_app.git)
    cd news_app
    ```2.  **Install dependencies:** ```bash
    flutter pub get
    ```3.  **Generate Launcher Icons:** Ensure you have your `logo.jpg` (or `logo.png` - recommended for transparency) in the `assets/` folder.
    ```bash
    flutter pub run flutter_launcher_icons:main
    ```4.  **Update App Name (Optional):** * **Android:** In `android/app/src/main/AndroidManifest.xml`, change `android:label` in the `<application>` tag.    * **iOS:** In `ios/Runner/Info.plist`, modify `CFBundleDisplayName` and `CFBundleName`.5.  **Run the app:** ```bash
    flutter run
    ```
    To build a release APK for Android:
    ```bash
    flutter build apk --release
    ```
---
## ⚠️ Important Configuration Notes* 
**API Base URL:** The app is configured to fetch news from `https://news24x365.com/wp-json/wp/v2`. If you wish to use a different WordPress API, update the `_baseUrl` constant in `lib/services/api_service.dart`.* **Notification Icon:** For Android notifications, ensure you have an `ic_notification.png` in `android/app/src/main/res/drawable/` (or update the reference in `AndroidManifest.xml` and `lib/services/notification_service.dart`).* **Payload Handling:** When a notification is tapped, the app attempts to navigate to the Post Detail Screen using the post ID passed in the notification payload. Ensure your `ApiService` can retrieve a single post by ID if needed, or adjust the payload to contain enough information for direct navigation.
---
## 📈 Future Enhancements* 
**Push Notifications (FCM):** Implement Firebase Cloud Messaging for server-sent "breaking news" alerts.* **Background Fetching:** Use `workmanager` or native background tasks to periodically check for new posts even when the app is closed.* **Offline Reading:** Implement local caching for articles to allow reading without an internet connection.* **User Authentication:** Allow users to log in for personalized features (e.g., commenting, saving articles to a cloud account).* **Deep Linking:** Improve navigation from notifications and external links.* **Better Error Handling UI:** More user-friendly error messages and retry options.* **Pull-to-Refresh:** Implement pull-to-Refresh on content lists.
---
## 🤝 Contributing

Contributions are welcome! If you have any suggestions, bug reports, or want to contribute to the codebase, please feel free to open an issue or submit a pull request.
---
## 📧 Contact* **Aayush Sood** - [Link to your GitHub profile](https://github.com/your-username)
* **Email:** soodaayush170@gmail.com
