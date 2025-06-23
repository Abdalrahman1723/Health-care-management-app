# 🏥 Healthcare Mobile App

A modular Flutter mobile application for a healthcare system, built with Clean Architecture. It supports multiple user roles (Patient, Doctor, Admin) and communicates with a .NET backend API for business logic and data operations.

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
- **Backend:** .NET Core API

---

## 📁 Project Structure (Clean Architecture + Feature-Based)

<pre>

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

</pre>

---

## 🚀 Getting Started

### 🔨 Prerequisites

- Flutter SDK
- .NET API hosted and accessible
- Android Studio or VS Code

### ⚙️ Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/Abdalrahman1723/Health-care-management-app.git
   cd Health-care-management-app

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up `.env` or config file for base API URL and tokens if needed.**

4. **Run the app**

   ```bash
   flutter run
   ```

---

## 🧪 Testing

To test API features with Dio directly in the UI (temporarily):

```dart
final response = await Dio().get('https://healthcaresystem.runasp.net/api/PatientProfile');
```

---

## 🤖 Machine Learning Integration

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
* **Backend Team** – .NET Developer

---

## 📄 License

This project is licensed under the MIT License.
