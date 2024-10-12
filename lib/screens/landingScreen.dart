import 'package:app01/screens/ExpensesScreen.dart';
import 'package:app01/screens/Stat.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../service/expenseService.dart';
import '../ui components/ExpenseInputDialog.dart';

class LandingScreen extends StatefulWidget {
  final dynamic userId;

  const LandingScreen({super.key, required this.userId});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late List<Widget> Screens;
  @override
  void initState() {
    super.initState();

    Screens = [
      ExpensesScreen(userId: widget.userId),
      const StatScreen(),
    ];
  }
  int _selectedIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white60,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(

        shape: const CircleBorder(),
        onPressed: _showExpenseInputDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,

        index: _selectedIndex,
        items: const [
          Icon(Icons.home),
          Icon(Icons.stacked_bar_chart),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex=index;
          });
        },
      ),
      body: Screens[_selectedIndex],
    );
  }
  void _showExpenseInputDialog() {
    showDialog(
      context: context,
      builder: (context) => ExpenseInputDialog(
        userId: widget.userId,
        expenseService: ExpenseService(),
      ),
    );
  }
}
