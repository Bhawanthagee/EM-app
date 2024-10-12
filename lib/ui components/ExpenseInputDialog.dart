import 'package:app01/model/totalExpense.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/expenses.dart';
import '../service/expenseService.dart';

class ExpenseInputDialog extends StatefulWidget {
  final String userId;
  final ExpenseService expenseService;

  const ExpenseInputDialog({
    Key? key,
    required this.userId,
    required this.expenseService,
  }) : super(key: key);

  @override
  _ExpenseInputDialogState createState() => _ExpenseInputDialogState();
}

class _ExpenseInputDialogState extends State<ExpenseInputDialog> {
  final TextEditingController _typeTextEditingController = TextEditingController();
  final TextEditingController _commentTextEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();

  bool _isLoading = false;
  bool _isTypeValid = true;
  bool _isPriceValid = true;
  bool _formSubmitted = false;

  Future<void> _submitExpense() async {
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
      TotalExpense totalExpense = TotalExpense(
          userId: widget.userId, 
          createdOn:Timestamp.now(),
          amount: double.parse(_priceEditingController.text)
      );

      try {
        await widget.expenseService.addExpense(expenses);
        // await widget.expenseService.addOrUpdateTotalExpense(totalExpense);
        await widget.expenseService.updateAmount(widget.userId, totalExpense.amount);
        
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        _clearInputs();
      }
    }
  }

  void _clearInputs() {
    _typeTextEditingController.clear();
    _commentTextEditingController.clear();
    _priceEditingController.clear();
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
          onPressed: _submitExpense,
        )
      ],
    );
  }
}
