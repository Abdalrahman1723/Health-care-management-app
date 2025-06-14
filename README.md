```markdown
# 🏥 Healthcare Mobile App

A modular Flutter mobile application for a healthcare system, built with Clean Architecture. It supports multiple user roles (Patient, Doctor, Admin), integrates with Firebase for authentication, and communicates with a .NET backend API for business logic and data operations.

---

## 📱 Features

### ✅ General
- Modular structure (Patient, Doctor, Admin)
- Clean Architecture (Domain, Data, and Presentation layers)
- Shared Entities and Utilities
- Secure API communication via Dio
- Shared Preferences for local data storage
- JWT token-based authentication
- Image picker and upload
- Pull-to-refresh and responsive UI

### 👨‍⚕️ Patient
- View and update profile (Personal & Medical Info)
- Book appointments
- View doctors based on specialty
- Favorite doctors
- Receive health-related notifications

### 👩‍⚕️ Doctor
- Manage schedule and appointments
- View and respond to patient cases
- Update medical notes

### 🧑‍💼 Admin
- Oversee doctor and patient records
- Approve new doctor accounts

---

## 🔧 Tech Stack

- **Frontend:** Flutter, Dart
- **State Management:** Bloc / Cubit
- **Local Storage:** Shared Preferences
- **Network:** Dio with Interceptors
- **Authentication:** Firebase Auth
- **Backend:** .NET Core API
- **Notifications:** Firebase Cloud Messaging (or custom)

---

## 📁 Project Structure (Clean Architecture + Features)

```

lib/
├── core/                 # App-wide constants, services, utils
├── global/               # Shared entities and models
├── patient/
│   ├── data/
│   ├── domain/
│   ├── presentation/
├── doctor/
│   ├── data/
│   ├── domain/
│   ├── presentation/
├── admin/
│   ├── data/
│   ├── domain/
│   ├── presentation/
├── main.dart

````

---

## 🚀 Getting Started

### 🔨 Prerequisites

- Flutter SDK
- Firebase Project (Web + Android configured)
- .NET API hosted and accessible
- Android Studio or VS Code

### ⚙️ Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/YourUsername/healthcare_app.git
   cd healthcare_app
````

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   * Replace `firebase_options.dart` with your own.
   * Run:

     ```bash
     flutterfire configure
     ```

4. **Set up `.env` or config file for base API URL and tokens if needed.**

5. **Run the app**

   ```bash
   flutter run
   ```

---

## 🧪 Testing

To test API features with Dio directly in the UI (temporarily):

```dart
final response = await Dio().get('https://your-api.com/patient/1');
```

---

## 🧠 Machine Learning Integration

* Hosted Python ML model predicts required doctor specialty based on symptoms.
* Flutter sends symptoms via API to the Python backend.
* Suggested doctors shown to the user.

---

## 📦 Build APK

```bash
flutter build apk --release
```

---

## 🙋‍♂️ Contributors

* **Abdalrahman Alaa Eldin** – Flutter Developer
* **Helana Emad** – Flutter Developer
* **the Backend Team** – .NET Developer

---

## 📄 License

This project is licensed under the HU License.

```

---

Would you like me to add badges (build, version, etc.), a GitHub actions workflow, or auto-deploy setup?
```
