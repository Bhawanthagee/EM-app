import 'package:flutter/material.dart';

class ManageExpenses extends StatelessWidget {
  final String userId;

  const ManageExpenses({
    super.key,
    required this.userId, // Accept userId
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add credits"),
      content: const TextField(
        decoration: InputDecoration(
          hintText: "Add/Remove credit",
        ),
        keyboardType: TextInputType.number,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Add"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("remove"),
        ),
      ],
    );
  }
}
