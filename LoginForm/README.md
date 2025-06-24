# 🔐 LoginForm — Flutter + PHP Authentication

A simple yet effective **Login and Signup UI** built with Flutter, connected to a **PHP + MySQL backend** running on localhost (XAMPP or similar).

This app demonstrates full-stack authentication — client-side form validation + backend communication via HTTP POST.

---

## 🚀 Features

- 📲 Login and Signup screens
- ✅ Form validation (email, password)
- 🔐 Secure HTTP POST requests to PHP backend
- 🧪 Works with localhost (XAMPP/WAMP)
- 📁 Clean folder structure (MVC style)

---

## 🧰 Tech Stack

| Layer     | Technology          |
|-----------|---------------------|
| Frontend  | Flutter (Dart)      |
| Backend   | PHP (Localhost)     |
| Database  | MySQL (via XAMPP)   |
| Protocol  | RESTful HTTP (POST) |

---

## 📸 Screenshots

> (Add your UI screenshots here if possible)

---

## 🛠️ How to Run

### ✅ 1. **Backend Setup**

1. Install [XAMPP](https://www.apachefriends.org/) or WAMP.
2. Place your `login.php` & `signup.php` files in:

```
htdocs/LoginApp/
```

3. Make sure your MySQL server is running and database is set up.

### ✅ 2. **Flutter App Setup**

1. Clone the repo or navigate to:

```bash
cd FlutterCourse/LoginForm
```

2. Get packages:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

> Make sure to replace the `localhost` URL with your actual IP address if testing on a physical device.

---

## 📂 Folder Structure

```bash
LoginForm/
├── lib/
│   ├── login.dart
│   ├── signup.dart
│   └── api_service.dart
├── assets/
├── pubspec.yaml
└── README.md
```

---

## 🙋‍♂️ Author

**Muhammad Ousman**  
📧 [ousmansohail786@gmail.com](mailto:ousmansohail786@gmail.com)  
🔗 [ousman.me](https://ousman.me)

---

## 📄 License

MIT — Free for educational and portfolio use.

---

> ✨ Great starting point for any Flutter developer looking to build full-stack apps with PHP.
