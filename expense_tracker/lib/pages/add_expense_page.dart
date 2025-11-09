import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';
import 'expense_list_page.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  String? _selectedCategory;

  // ✅ Predefined categories
  final List<String> categories = [
    "Food",
    "Travel",
    "Bills",
    "Shopping",
    "Health",
    "Entertainment",
    "Groceries",
    "Education",
    "Fuel",
    "House Rent",
    "Mobile Recharge",
    "Investment",
    "Gifts",
    "Subscriptions",
    "Other"
  ];

  bool _isSubmitting = false;

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      context.read<ExpenseBloc>().add(
            AddExpenseEvent(
              category: _selectedCategory!,
              amount: double.parse(_amountCtrl.text.trim()),
              comments: _commentCtrl.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Expense 💸"),
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
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseLoaded) {
            setState(() => _isSubmitting = false);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("✅ Expense added successfully!"),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ExpenseListPage()),
              (route) => false,
            );
          } else if (state is ExpenseError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ ${state.message}"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter Expense Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null ? "Please select a category" : null,
                ),
                const SizedBox(height: 12),

                // ✅ Amount Input
                TextFormField(
                  controller: _amountCtrl,
                  decoration: const InputDecoration(
                    labelText: "Amount (₹)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v!.isEmpty ? "Please enter an amount" : null,
                ),
                const SizedBox(height: 12),

                // ✅ Comment Input
                TextFormField(
                  controller: _commentCtrl,
                  decoration: const InputDecoration(
                    labelText: "Comments (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                // ✅ Add Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _addExpense,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add Expense",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
