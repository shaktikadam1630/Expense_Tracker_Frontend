import 'package:equatable/equatable.dart';
import '../../data/models/expense_model.dart';

abstract class ExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  ExpenseLoaded(this.expenses);
  @override
  List<Object?> get props => [expenses];
}

class ExpenseSuccess extends ExpenseState {
  final String message;
  ExpenseSuccess(this.message);
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}
