import 'package:expense_tracker/pages/login.dart';
import 'package:expense_tracker/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/expense/expense_bloc.dart';
import 'data/services/expense_service.dart';
import 'data/repository/expense_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'data/services/auth_service.dart';
import 'data/repository/auth_repository.dart';
import 'data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final expenseRepo = ExpenseRepository(ExpenseService());
  final authRepo = AuthRepository(AuthService());

  // ✅ Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final userJson = prefs.getString('user');

  // ✅ Decode saved user if available
  UserModel? savedUser;
  if (userJson != null) {
    savedUser = UserModel.fromJsonString(userJson);
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo, AuthService())),
        BlocProvider(create: (_) => ExpenseBloc(expenseRepo)),
      ],
      child: MyApp(
        isLoggedIn: token != null && savedUser != null,
        savedUser: savedUser,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final UserModel? savedUser;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.savedUser,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? DashboardPage(user: savedUser!)
          : const LoginPage(),
    );
  }
}
