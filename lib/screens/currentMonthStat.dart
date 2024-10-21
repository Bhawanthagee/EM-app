import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrentMonthStat extends StatefulWidget {
  final dynamic userId;

  const CurrentMonthStat({super.key, required this.userId});

  @override
  State<CurrentMonthStat> createState() => _currentMonthStat();
}

class _currentMonthStat extends State<CurrentMonthStat> {
  List<_ExpenseData> chartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    await fetchExpensesByUserId(widget.userId);
  }

  Future<void> fetchExpensesByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();


      Map<String, double> expenseMap = {};

      for (var doc in querySnapshot.docs) {
        double amount = doc['amount'].toDouble();
        String expenseType = doc['expenseType'];

        // Sum the amounts for each expense type
        if (expenseMap.containsKey(expenseType)) {
          expenseMap[expenseType] = expenseMap[expenseType]! + amount;
        } else {
          expenseMap[expenseType] = amount;
        }
      }

      // Convert the Map to a List of _ExpenseData
      List<_ExpenseData> tempChartData = expenseMap.entries
          .map((entry) => _ExpenseData(entry.key, entry.value))
          .toList();

      // Once data is fetched, update the state to display the chart
      setState(() {
        chartData = tempChartData;
        isLoading = false; // Data has been loaded
      });
    } catch (e) {
      print('Error fetching expenses: $e');
      setState(() {
        isLoading = false; // Set loading to false if an error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SfCircularChart(
          title: ChartTitle(text: 'Expense Breakdown'),
          legend: Legend(isVisible: true),
          series: <CircularSeries>[
            PieSeries<_ExpenseData, String>(
              dataSource: chartData,
              xValueMapper: (_ExpenseData data, _) => data.expenseType,
              yValueMapper: (_ExpenseData data, _) => data.amount,
              dataLabelMapper: (_ExpenseData data, _) => data.expenseType,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ),
    );
  }
}

// Data model for expense chart
class _ExpenseData {
  _ExpenseData(this.expenseType, this.amount);

  final String expenseType;
  final double amount;
}
