import 'package:app01/model/expenses.dart';
import 'package:app01/service/database_service.dart';
import 'package:app01/service/expenseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
  import '../ui components/expense_list_view.dart';

class Homepage01 extends StatefulWidget {
  final String userId;

  const Homepage01({super.key, required this.userId});

  @override
  State<Homepage01> createState() => _Homepage01State();
}

class _Homepage01State extends State<Homepage01> {
   final ExpenseService _expenseService = ExpenseService();
  final TextEditingController _typeTextEditingController = TextEditingController();
  final TextEditingController _commentTextEditingController = TextEditingController();
  final _priceEditingController = TextEditingController();

  bool _isLoading = false;
  bool _isTypeValid = true;
  bool _isPriceValid = true;
  bool _formSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
     await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  Future _displayTextInputDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add an Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _typeTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Type..",
                      errorText: !_isTypeValid && _formSubmitted ? "Type is required" : null,
                    ),
                  ),
                  TextField(
                    controller: _priceEditingController,
                    decoration: InputDecoration(
                      hintText: "Price..",
                      errorText: !_isPriceValid && _formSubmitted ? "Enter a valid price" : null,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _commentTextEditingController,
                    decoration: const InputDecoration(hintText: "Comment.."),
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  child: const Text("Ok"),
                  onPressed: () async {
                     setState(() {
                      _formSubmitted = true;
                      _isTypeValid = _validateType(_typeTextEditingController.text);
                      _isPriceValid = _validatePrice(_priceEditingController.text);
                    });

                    if (_validateForm()) {
                      setState(() {
                        _isLoading = true;
                      });

                      Expenses expenses = Expenses(
                        userId: widget.userId,
                        createdOn: Timestamp.now(),
                        updatedOn: Timestamp.now(),
                        isUpdated: false,
                        expenseType: _typeTextEditingController.text,
                        comment: _commentTextEditingController.text,
                        amount: double.parse(_priceEditingController.text),
                      );

                      try {
                        await _expenseService.addExpense(expenses);
                      } catch (e) {

                        print('Error: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                        _typeTextEditingController.clear();
                        _commentTextEditingController.clear();
                        _priceEditingController.clear();
                      }
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  bool _validateType(String type) {
    return type.isNotEmpty;
  }

  bool _validatePrice(String price) {
    if (price.isEmpty) return false;
    final double? value = double.tryParse(price);
    return value != null && value > 0;
  }

  bool _validateForm() {
    return _isTypeValid && _isPriceValid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Scaffold(
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                elevation: 3,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.graph_square), label: "Stat")
                ],
              ),
            ),
            body: _buildUI(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: _displayTextInputDialog,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF5F6D),
                        Color(0xfffffc371),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 0.9],
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                )
            ),
          ),
        )
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          ExpenseListView(
            userId: widget.userId,
            expenseService: _expenseService,
          ),
        ],
      ),
    );
  }
}
