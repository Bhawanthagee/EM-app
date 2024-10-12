import 'package:app01/model/Credit.dart';
import 'package:app01/model/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/totalExpense.dart';

const String EXPENSE_COLLECTION_REF = "expenses";
const String TOTAL_EXPENSE_COLLECTION_REF = "totalExpenses";
const String CREDIT_COLLECTION_REF = "credit";

class ExpenseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Expenses> _expenseRef;
  late final CollectionReference<TotalExpense> _totalExpenseRef;
  late final CollectionReference<Credit> _creditRef;

  ExpenseService() {
    _expenseRef = _firestore
        .collection(EXPENSE_COLLECTION_REF)
        .withConverter<Expenses>(
          fromFirestore: (snapshot, _) => Expenses.fromJson(snapshot.data()!),
          toFirestore: (expense, _) => expense.toJson(),
        );
    _totalExpenseRef = _firestore
        .collection(TOTAL_EXPENSE_COLLECTION_REF)
        .withConverter<TotalExpense>(
          fromFirestore: (snapshot, _) =>
              TotalExpense.fromJson(snapshot.data()!),
          toFirestore: (totalExpense, _) => totalExpense.toJson(),
        );
  }

  Stream<QuerySnapshot> getExpenses(String userId) {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> addExpense(Expenses expense) async {
    await _expenseRef.add(expense);
  }

  Future<void> updateExpense(String userId, Expenses expense) async {
    await _expenseRef.doc(userId).update(expense.toJson());
  }

  Future<void> updateTotalExpense(
      String userId, TotalExpense expenseTtl) async {
    await _expenseRef.doc(userId).update(expenseTtl.toJson());
  }

  Future<void> deleteExpense(String userId) async {
    await _expenseRef.doc(userId).delete();
  }

  //credit related functions

  Future<void> addCredits(Credit credit) async {
    await _creditRef.add(credit);
  }

  Future<double?> getCreditAmount(String userId) async {
    QuerySnapshot<Credit> snapshot =
        await _creditRef.where('userId', isEqualTo: userId).limit(1).get();

    if (snapshot.docs.isNotEmpty) {

      return snapshot.docs.first.data().creditAmount;
    } else {
      return null;
    }
  }

  Stream<double> getTotalExpenses(String userId) {
    return _totalExpenseRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      double totalExpense = 0;
      for (var doc in querySnapshot.docs) {
        totalExpense +=
            (doc.data().amount ?? 0.0);
      }
      return totalExpense;
    });
  }

  Future<void> updateAmount(String userId, double newAmount) async {
    CollectionReference expenses =
        FirebaseFirestore.instance.collection('totalExpenses');

    QuerySnapshot querySnapshot =
        await expenses.where('userId', isEqualTo: userId).get();

    if (querySnapshot.docs.isEmpty) {
      await expenses.add({
        'userId': userId,
        'amount': newAmount,
        'createdOn': Timestamp.now(),
      });
      print(
          'Created a new document for userId: $userId with amount: $newAmount');
    } else {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String documentId = doc.id;
        double currentAmount = doc['amount'];

        double updatedAmount = currentAmount + newAmount;

        await expenses.doc(documentId).update({
          'amount': updatedAmount,
        });
        print(
            'Added $newAmount to document with ID: $documentId. New amount: $updatedAmount');
      }
    }
  }
}
