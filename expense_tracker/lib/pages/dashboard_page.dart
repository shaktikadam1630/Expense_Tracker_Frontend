import 'package:expense_tracker/data/models/user_model.dart';
import 'package:expense_tracker/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/gradient_card.dart';
import '../bloc/expense/expense_bloc.dart';
import '../bloc/expense/expense_event.dart';
import '../bloc/expense/expense_state.dart';
import 'add_expense_page.dart';
import 'expense_list_page.dart';
import 'profile_page.dart';
import 'dart:math';

class DashboardPage extends StatefulWidget {
  final UserModel user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpensesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, ${widget.user.name.split(' ').first} 👋",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(user: widget.user),
                ),
              );
            },
          ),
        ],
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
                child: Text("No expenses added yet 😅",
                    style: TextStyle(fontSize: 16)),
              );
            }

            // ✅ Pie Chart + Category Legend colors
            double total = expenses.fold(0, (sum, e) => sum + e.amount);
            Map<String, double> categoryTotals = {};
            for (var e in expenses) {
              categoryTotals[e.category] =
                  (categoryTotals[e.category] ?? 0) + e.amount;
            }

            final colors = [
              Colors.indigo,
              Colors.pinkAccent,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.teal,
              Colors.cyan,
              Colors.amber,
            ];

            final categoryList = categoryTotals.keys.toList();

            final recentExpenses = expenses.take(3).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Spent",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16)),
                        Text("₹${total.toStringAsFixed(0)}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Pie chart + Legend
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: CustomPaint(
                            painter: _PieChartPainter(categoryTotals, colors),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: List.generate(categoryList.length, (i) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: colors[i % colors.length],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  categoryList[i],
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black87),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Recent Expenses
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recent Expenses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ExpenseListPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(color: Colors.indigo),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Column(
                            children: recentExpenses.map((e) {
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                color: Colors.indigo.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.receipt_long,
                                      color: Colors.indigo),
                                  title: Text(
                                    e.category,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    e.comments ?? '',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  trailing: Text(
                                    "₹${e.amount}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
          if (newExpense != null) {
            context.read<ExpenseBloc>().add(LoadExpensesEvent());
          }
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ✅ Reusable Painter with colors for chart
class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;

  _PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final total = data.values.fold(0.0, (a, b) => a + b);
    double startAngle = -pi / 2;
    final radius = min(size.width / 2, size.height / 2);

    int index = 0;
    data.forEach((_, value) {
      final sweep = (value / total) * 2 * pi;
      paint.color = colors[index % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );
      startAngle += sweep;
      index++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
