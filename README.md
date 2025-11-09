# 💰 Expense Tracker (Flutter Frontend)

## 📱 1. Project Overview

This is the **frontend** for the **Expense Tracker Application**, built using **Flutter** with **BLoC state management**.  
It connects to a Node.js + MongoDB backend and provides a **beautiful, modern interface** for managing daily expenses.

The app allows users to:
- 🔐 Register and login securely using JWT authentication.
- ➕ Add, edit, and delete expenses.
- 📊 View total and category-wise expenses using a pie chart.
- 👤 Manage profile and logout easily.

---

## 🚀 2. Key Features

✅ Secure authentication (Login / Signup)  
✅ Interactive Dashboard with pie chart visualization  
✅ CRUD operations for expenses  
✅ Responsive and modern Flutter UI  
✅ Integrated with Node.js REST API backend  

---

## 🧠 3. Tech Stack

| Technology | Purpose |
|-------------|----------|
| **Flutter** | UI Framework |
| **Dart** | Programming Language |
| **BLoC Pattern** | State Management |
| **HTTP** | REST API Integration |
| **SharedPreferences** | Local Token Storage |
| **Node.js + Express.js** | Backend APIs |
| **MongoDB** | Database |

---

## 🛠️ 4. Setup & Run Instructions

### 1️⃣ Clone the repository
```bash
git clone https://github.com/shaktikadam1630/Expense_Tracker_Frontend.git
cd Expense_Tracker_Frontend
2️⃣ Install Dependencies
bash
Copy code
flutter pub get
3️⃣ Update Backend API URL
Open these files:

swift
Copy code
/lib/data/services/auth_service.dart
/lib/data/services/expense_service.dart
Replace the baseUrl with your system IP (find it using ipconfig in CMD):

dart
Copy code
final String baseUrl = "http://192.168.x.x:5000";
⚠️ Both your mobile device and PC must be on the same Wi-Fi network.

4️⃣ Run the App
bash
Copy code
flutter run
🧩 5. Folder Structure
bash
Copy code
lib/
│
├── bloc/                # BLoC files for Auth & Expense logic
│
├── data/
│   ├── models/          # Data models (User, Expense)
│   ├── repository/      # Repository pattern for clean architecture
│   └── services/        # API calls (HTTP)
│
├── pages/               # UI Screens
│   ├── login.dart
│   ├── signup.dart
│   ├── dashboard_page.dart
│   ├── expense_list_page.dart
│   ├── add_expense_page.dart
│   ├── edit_expense_page.dart
│   └── profile_page.dart
│
└── widgets/             # Reusable UI components
🎨 6. UI Screenshots
🟪 Login Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/login.jpg?raw=true" width="320"/>
🟦 Signup Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/signup.jpg?raw=true" width="320"/>
🟩 Dashboard Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/dashboard.jpg?raw=true" width="320"/>
🟨 All Expenses Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/all_expenses.jpg?raw=true" width="320"/>
🟧 Add Expense Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/add_expense.jpg?raw=true" width="320"/>
🟫 Edit Expense Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/edit_expense.jpg?raw=true" width="320"/>
🟦 Profile Page
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/profile.jpg?raw=true" width="320"/> ```






