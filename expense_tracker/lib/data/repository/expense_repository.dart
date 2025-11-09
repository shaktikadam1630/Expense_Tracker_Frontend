import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseRepository {
  final ExpenseService service;

  ExpenseRepository(this.service);

  Future<List<ExpenseModel>> getAllExpenses() => service.fetchExpenses();
  Future<void> addExpense(String category, double amount, String comments) =>
      service.addExpense(category, amount, comments);
  Future<void> updateExpense(String id, String category, double amount, String comments) =>
      service.updateExpense(id, category, amount, comments);
  Future<void> deleteExpense(String id) => service.deleteExpense(id);
}
