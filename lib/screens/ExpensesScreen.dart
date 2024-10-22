import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../service/expenseService.dart';
import '../ui components/expense_list_view.dart';

class ExpensesScreen extends StatefulWidget {
  final dynamic userId;
  const ExpensesScreen({super.key, required this.userId});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF243642),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF387478),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Spend",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Colors.white38,
                        thickness: 1,
                        height: 20,
                        indent: 40,
                        endIndent: 40,
                      ),
                      StreamBuilder<double>(
                        stream: _expenseService.getTotalExpenses(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              "Error",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            );
                          }
                          double totalExpense = snapshot.data ?? 0;
                          String formattedExpense = NumberFormat.currency(
                            locale: 'en_IN',
                            symbol: 'Rs ',
                          ).format(totalExpense);
                          return Text(
                            formattedExpense,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 5.0,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: ExpenseListView(
                userId: widget.userId,
                expenseService: _expenseService,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

