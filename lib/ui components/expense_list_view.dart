import 'package:app01/model/expenses.dart';
import 'package:app01/service/expenseService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListView extends StatelessWidget {
  final String userId;
  final ExpenseService expenseService;

  const ExpenseListView({
    super.key,
    required this.userId,
    required this.expenseService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: expenseService.getExpenses(userId),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List expenses = snapShot.data?.docs ?? [];
        if (expenses.isEmpty) {
          return const Center(
            child: Text("Add an Expense!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          );
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            Expenses expense = Expenses.fromMap(expenses[index].data());
            String expenseId = expenses[index].id;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F1E7),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  leading: Text(
                    expense.expenseType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  title: Text(
                    expense.comment,
                    style: const TextStyle(

                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat("dd-MM-yyyy h:mm a")
                        .format(expense.createdOn.toDate()),
                    style: const TextStyle(color: Colors.grey),
                  ),

                  trailing: Text(
                    "Rs. ${expense.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  onLongPress: () {
                    expenseService.deleteExpense(expenseId);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
