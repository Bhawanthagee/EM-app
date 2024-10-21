import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatScreen extends StatefulWidget {
  final dynamic userId;

  const StatScreen({super.key, required this.userId});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  List<_ExpenseData> chartData = [];
  List<_ExpenseData> chartDataCurrentMonth = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    await fetchExpensesByUserId(widget.userId);
    await fetchExpensesByUserIdForCurrentMonth(widget.userId);
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

        if (expenseMap.containsKey(expenseType)) {
          expenseMap[expenseType] = expenseMap[expenseType]! + amount;
        } else {
          expenseMap[expenseType] = amount;
        }
      }
      List<_ExpenseData> tempChartData = expenseMap.entries
          .map((entry) => _ExpenseData(entry.key, entry.value))
          .toList();

      setState(() {
        chartData = tempChartData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching expenses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchExpensesByUserIdForCurrentMonth(String userId) async {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();

      Map<String, double> expenseMap = {};

      for (var doc in querySnapshot.docs) {
        double amount = doc['amount'].toDouble();
        String expenseType = doc['expenseType'];
        Timestamp createdOn = doc['createdOn'];
        DateTime createdOnDate = createdOn.toDate();

        if (createdOnDate.isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
            createdOnDate.isBefore(lastDayOfMonth.add(const Duration(days: 1)))) {
          if (expenseMap.containsKey(expenseType)) {
            expenseMap[expenseType] = expenseMap[expenseType]! + amount;
          } else {
            expenseMap[expenseType] = amount;
          }
        }
      }

      List<_ExpenseData> tempChartData = expenseMap.entries
          .map((entry) => _ExpenseData(entry.key, entry.value))
          .toList();

      setState(() {
        chartDataCurrentMonth = tempChartData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching current month expenses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalCurrentMonthAmount = chartDataCurrentMonth.fold(0, (sum, item) => sum + item.amount);
    double totalOverallAmount = chartData.fold(0, (sum, item) => sum + item.amount);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF243642),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF387478),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SfCircularChart(
                      title: ChartTitle(text: 'Current Month Expenses', textStyle: const TextStyle(color: Colors.white)),
                      legend: Legend(isVisible: true, textStyle: const TextStyle(color: Colors.white)),
                      series: <CircularSeries>[
                        PieSeries<_ExpenseData, String>(
                          dataSource: chartDataCurrentMonth,
                          xValueMapper: (_ExpenseData data, _) => data.expenseType,
                          yValueMapper: (_ExpenseData data, _) => data.amount,
                          dataLabelMapper: (_ExpenseData data, _) => data.expenseType,
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                    Text(
                      'Total: Rs ${totalCurrentMonthAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF387478),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SfCircularChart(
                      title: ChartTitle(text: 'Total Expense Till now', textStyle: const TextStyle(color: Colors.white)),
                      legend: Legend(isVisible: true, textStyle: const TextStyle(color: Colors.white)),
                      series: <CircularSeries>[
                        PieSeries<_ExpenseData, String>(
                          dataSource: chartData, // Using the same data for the second chart
                          xValueMapper: (_ExpenseData data, _) => data.expenseType,
                          yValueMapper: (_ExpenseData data, _) => data.amount,
                          dataLabelMapper: (_ExpenseData data, _) => data.expenseType,
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                    Text(
                      'Total: Rs ${totalOverallAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _ExpenseData {
  _ExpenseData(this.expenseType, this.amount);

  final String expenseType;
  final double amount;
}
