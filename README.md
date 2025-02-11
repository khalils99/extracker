# Expense Tracker App

A simple Flutter-based Expense Tracker application that allows users to manage their expenses
efficiently. The app supports adding, listing, categorizing expenses, generating reports, and
exporting data in Excel and PDF formats.

## 🚀 Features

- Add, edit, and delete expenses
- Categorize expenses (Food, Transport, Shopping, etc.)
- View expenses with beautiful pie charts using `fl_chart`
- Export expense data to Excel and PDF
- Supports multiple currencies with conversion rates
- Offline data storage using Hive

## 🚀 Tech Stack

- **Frontend:** Flutter
- **State Management:** BLoC
- **Database:** Hive
- **Charting:** fl_chart
- **File Export:** excel, pdf, path_provider

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/expense-tracker.git
   cd expense-tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🔊 Permissions

For Android:

- **Storage Permission**: Required to save Excel and PDF files.

Add this to `AndroidManifest.xml`:

```xml

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" /><uses-permission
android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## 💰 Exporting Data

### Excel Export

- Exports data in `.xlsx` format.
- Saved to the **Downloads** folder (Android) or **Documents** (iOS).

### PDF Export

- Generates clean, printable PDF reports of your expenses.

## 🌐 Folder Structure

```
lib/
├── core/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── expenses/
│   └── home/
└── main.dart
```

## 📢 Contribution

1. Fork the repo.
2. Create a new branch: `git checkout -b feature-branch`.
3. Make your changes.
4. Commit and push: `git push origin feature-branch`.
5. Open a Pull Request.

## 🚨 License

This project is licensed under the [MIT License](LICENSE).

# extracker
