import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final String baseUrl = "http://192.168.43.13:5000/expenses";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
   // print(prefs.getString('jwt_token'));
    return prefs.getString('jwt_token');
  }

  Future<List<ExpenseModel>> fetchExpenses() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/all"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
   // print(token);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ExpenseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load expenses");
    }
  }

  Future<ExpenseModel> addExpense(
    String category,
    double amount,
    String comments,
  ) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/add"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "category": category,
        "amount": amount,
        "comments": comments,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ExpenseModel.fromJson(data['expense']);
    } else {
      throw Exception("Failed to add expense");
    }
  }

  Future<void> updateExpense(
    String id,
    String category,
    double amount,
    String comments,
  ) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("$baseUrl/update/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "category": category,
        "amount": amount,
        "comments": comments,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update expense");
    }
  }

  Future<void> deleteExpense(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/delete/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete expense");
    }
  }
}
