# 💰 Expense Tracker (Flutter Frontend)

## 📱 1. Project Overview

This is the **frontend** for the **Expense Tracker Application**, built using **Flutter** with **BLoC state management**.  
It connects to a **Node.js + MongoDB backend** and provides a **beautiful, modern interface** for managing daily expenses.

The app allows users to:
- 🔐 Register and login securely using JWT authentication  
- ➕ Add, edit, and delete expenses  
- 📊 View total and category-wise expenses using a pie chart  
- 👤 Manage profile and logout easily  

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

### Follow the steps below to run the app:

```bash
# 1️⃣ Clone the repository
git clone https://github.com/shaktikadam1630/Expense_Tracker_Frontend.git
cd Expense_Tracker_Frontend

# 2️⃣ Install dependencies
flutter pub get

# 3️⃣ Update Backend API URL
# Open the following files:
#   lib/data/services/auth_service.dart
#   lib/data/services/expense_service.dart
# Replace the baseUrl with your system IP (find it using ipconfig in CMD)
# Example:
final String baseUrl = "http://192.168.x.x:5000";

# ⚠️ Note: Both your mobile device and PC must be connected to the same Wi-Fi network.

# 4️⃣ Run the App
flutter run

## 🎨 6. UI Screenshots

### 🟪 Login Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/login.jpg?raw=true" width="320"/>

### 🟦 Signup Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/signup.jpg?raw=true" width="320"/>

### 🟩 Dashboard Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/dashboard.jpg?raw=true" width="320"/>

### 🟨 All Expenses Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/all_expenses.jpg?raw=true" width="320"/>

### 🟧 Add Expense Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/add_expense.jpg?raw=true" width="320"/>

### 🟫 Edit Expense Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/edit_expense.jpg?raw=true" width="320"/>

### 🟦 Profile Page  
<img src="https://github.com/shaktikadam1630/Expense_Tracker_Frontend/blob/main/expense_tracker/lib/assets/profile.jpg?raw=true" width="320"/>

---





