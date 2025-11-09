import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../../data/repository/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc(this.repository) : super(ExpenseInitial()) {
    on<LoadExpensesEvent>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final expenses = await repository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await repository.addExpense(event.category, event.amount, event.comments);
        final expenses = await repository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<UpdateExpenseEvent>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await repository.updateExpense(event.expenseId, event.category, event.amount, event.comments);
        final expenses = await repository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<DeleteExpenseEvent>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await repository.deleteExpense(event.expenseId);
        final expenses = await repository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });
  }
}
