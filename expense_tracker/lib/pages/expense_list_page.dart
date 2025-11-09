import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';
import 'add_expense_page.dart';
import 'edit_expense_page.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpensesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        title: const Text(
          "All Expenses 💰",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseError) {
            return Center(
              child: Text(
                "❌ ${state.message}",
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          }

          if (state is ExpenseLoaded) {
            final expenses = state.expenses;

            if (expenses.isEmpty) {
              return const Center(
                child: Text(
                  "No expenses added yet 😅",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final e = expenses[index];

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ✅ Leading Avatar
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.indigo.withOpacity(0.1),
                            child: const Icon(Icons.receipt_long,
                                color: Colors.indigo, size: 26),
                          ),
                          const SizedBox(width: 12),

                          // ✅ Expense Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e.comments.isNotEmpty
                                      ? e.comments
                                      : "No comments",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ✅ Trailing Section (no overflow)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "₹${e.amount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueAccent, size: 20),
                                    onPressed: () async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditExpensePage(
                                            expense: e.toJson(),
                                          ),
                                        ),
                                      );
                                      if (updated != null) {
                                        context.read<ExpenseBloc>().add(
                                              UpdateExpenseEvent(
                                                expenseId: e.id,
                                                category: updated['category'],
                                                amount: updated['amount'],
                                                comments: updated['comments'],
                                              ),
                                            );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      context
                                          .read<ExpenseBloc>()
                                          .add(DeleteExpenseEvent(e.id));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add),
        label: const Text("Add Expense"),
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
          if (newExpense != null) {
            context.read<ExpenseBloc>().add(
                  AddExpenseEvent(
                    category: newExpense['category'],
                    amount: newExpense['amount'],
                    comments: newExpense['comments'],
                  ),
                );
          }
        },
      ),
    );
  }
}
