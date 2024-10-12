import 'package:cloud_firestore/cloud_firestore.dart';

class Credit {
  String userId;
  double creditAmount;
  double monthlyIncome;

  Credit({
    required this.userId,
    required this.creditAmount,
    required this.monthlyIncome,
  });


  Credit.fromJson(Map<String, Object?> json)
      : this(
    userId: json['userId'] as String? ?? 'Unknown userId',
    creditAmount: json['creditAmount'] as double? ?? 0.0,
    monthlyIncome: json['monthlyIncome'] as double? ?? 0.0,
  );


  factory Credit.fromMap(Map<String, dynamic> data) {
    return Credit(
      userId: data['userId'] as String,
      creditAmount: data['creditAmount'] as double,
      monthlyIncome: data['monthlyIncome'] as double,
    );
  }

  // Create a new Credit object with optional updated fields
  Credit copyWith({
    String? userId,
    double? creditAmount,
    double? monthlyIncome,
  }) {
    return Credit(
      userId: userId ?? this.userId,
      creditAmount: creditAmount ?? this.creditAmount,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }

  // Convert Credit object to JSON (Firestore compatible)
  Map<String, Object> toJson() {
    return {
      'userId': userId,
      'creditAmount': creditAmount,
      'monthlyIncome': monthlyIncome,
    };
  }
}
