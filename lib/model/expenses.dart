import 'package:cloud_firestore/cloud_firestore.dart';


class Expenses {
  String userId;
  Timestamp createdOn;
  Timestamp updatedOn;
  bool isUpdated;
  String expenseType;
  String comment;
  double amount;

  Expenses({
    required this.userId,
    required this.createdOn,
    required this.updatedOn,
    required this.isUpdated,
    required this.expenseType,
    required this.comment,
    required this.amount,
  });

  Expenses.fromJson(Map<String, Object?> json)
      : this(
    userId: json['userId'] as String? ?? 'Unknown userId',
    createdOn: json['createdOn'] as Timestamp? ?? Timestamp.now(),
    updatedOn: json['updatedOn'] as Timestamp? ?? Timestamp.now(),
    isUpdated: json['isUpdated'] as bool? ?? false,
    expenseType: json['expenseType'] as String? ?? 'default expense Type',
    comment: json['comment'] as String? ?? 'default comment',
    amount: json['amount'] as double? ?? 1000
  );
  // Create an Expenses object from a Firestore document (Map)
  factory Expenses.fromMap(Map<String, dynamic> data) {
    return Expenses(
      userId: data['userId'],
      createdOn: data['createdOn'],
      updatedOn: data['updatedOn'],
      isUpdated: data['isUpdated'],
      expenseType: data['expenseType'],
      comment: data['comment'],
      amount: data['amount'],
    );
  }

  Expenses copyWith({
    String? userId,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    bool? isUpdated,
    String? expenseType,
    String? comment,
    double? amount,

  }) {
    return Expenses(
      userId: userId ?? this.userId,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      isUpdated: isUpdated ?? this.isUpdated,
      expenseType: expenseType ?? this.expenseType,
      comment: comment ?? this.comment,
      amount: amount ?? this.amount,
     );
  }

  Map<String, Object> toJson() {
    return {
      'userId': userId,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'isUpdated': isUpdated,
      'expenseType': expenseType,
      'comment': comment,
      'amount': amount,
     };
  }
}
