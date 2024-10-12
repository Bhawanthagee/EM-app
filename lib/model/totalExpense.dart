import 'package:cloud_firestore/cloud_firestore.dart';


class TotalExpense {
  String userId;
  Timestamp createdOn;
  double amount=0.0;

  TotalExpense({
    required this.userId,
    required this.createdOn,
    required this.amount,
  });

  TotalExpense.fromJson(Map<String, Object?> json)
      : this(
      userId: json['userId'] as String? ?? 'Unknown userId',
      createdOn: json['createdOn'] as Timestamp? ?? Timestamp.now(),
      amount: json['amount'] as double? ?? 1000
  );
  factory TotalExpense.fromMap(Map<String, dynamic> data) {
    return TotalExpense(
      userId: data['userId'],
      createdOn: data['createdOn'],
      amount: data['amount'],
    );
  }

  TotalExpense copyWith({
    String? userId,
    Timestamp? createdOn,
    double? amount,

  }) {
    return TotalExpense(
      userId: userId ?? this.userId,
      createdOn: createdOn ?? this.createdOn,

      amount: amount ?? this.amount,
    );
  }

  Map<String, Object> toJson() {
    return {
      'userId': userId,
      'createdOn': createdOn,
      'amount': amount,
    };
  }
}
