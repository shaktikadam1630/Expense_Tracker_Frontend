import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

// ✅ Load All Expenses
class LoadExpensesEvent extends ExpenseEvent {}

// ✅ Add Expense Event
class AddExpenseEvent extends ExpenseEvent {
  final String category;
  final double amount;
  final String comments;

  const AddExpenseEvent({
    required this.category,
    required this.amount,
    required this.comments,
  });

  @override
  List<Object?> get props => [category, amount, comments];
}

// ✅ Update Expense Event
class UpdateExpenseEvent extends ExpenseEvent {
  final String expenseId;
  final String category;
  final double amount;
  final String comments;

  const UpdateExpenseEvent({
    required this.expenseId,
    required this.category,
    required this.amount,
    required this.comments,
  });

  @override
  List<Object?> get props => [expenseId, category, amount, comments];
}

// ✅ Delete Expense Event
class DeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;

  const DeleteExpenseEvent(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}
