import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';
import 'expense_list_page.dart';

class EditExpensePage extends StatefulWidget {
  final Map<String, dynamic> expense;

  const EditExpensePage({super.key, required this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _commentCtrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _categoryCtrl = TextEditingController(text: widget.expense['category']);
    _amountCtrl = TextEditingController(
        text: widget.expense['amount'].toString());
    _commentCtrl = TextEditingController(text: widget.expense['comments'] ?? '');
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    _amountCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  void _updateExpense() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final id = widget.expense['_id']?.toString() ??
          widget.expense['id']?.toString() ??
          '';

      if (id.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("⚠️ Expense ID is missing"),
          backgroundColor: Colors.redAccent,
        ));
        setState(() => _isSubmitting = false);
        return;
      }

      context.read<ExpenseBloc>().add(
            UpdateExpenseEvent(
              expenseId: id,
              category: _categoryCtrl.text.trim(),
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
        title: const Text(
          "Edit Expense",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                content: Text("✅ Expense updated successfully"),
                backgroundColor: Colors.green,
              ),
            );

            // ✅ Navigate back to expense list page
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
                  "Update Expense Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Category Field
                TextFormField(
                  controller: _categoryCtrl,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    hintText: "e.g. Food, Rent, Shopping",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Please enter category" : null,
                ),
                const SizedBox(height: 12),

                // ✅ Amount Field
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    hintText: "Enter amount in ₹",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Please enter amount" : null,
                ),
                const SizedBox(height: 12),

                // ✅ Comments Field
                TextFormField(
                  controller: _commentCtrl,
                  decoration: const InputDecoration(
                    labelText: "Comments (optional)",
                    hintText: "Add any notes",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                // ✅ Update Button
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
                    onPressed: _isSubmitting ? null : _updateExpense,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Update Expense",
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
