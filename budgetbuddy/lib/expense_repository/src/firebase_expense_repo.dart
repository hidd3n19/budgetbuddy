import 'dart:developer';

import 'package:budgetbuddy/expense_repository/expense_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection = FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Future<void> createCategory(Category category) async {
    try {
      User? user = await getCurrentUser();
      if (user != null) {
        await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      User? user = await getCurrentUser();
      if (user != null) {
        return await categoryCollection
          .get()
          .then((value) => value.docs.map((e) =>
            Category.fromEntity(CategoryEntity.fromDocument(e.data()))
          ).toList());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      User? user = await getCurrentUser();
      if (user != null) {
        await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      User? user = await getCurrentUser();
      if (user != null) {
        return await expenseCollection
          .orderBy('date', descending: true) // Order by date in descending order
          .orderBy('expenseId', descending: true) // Order by expenseId in descending order
          .get()
          .then((value) => value.docs.map((e) =>
            Expense.fromEntity(ExpenseEntity.fromDocument(e.data()))
          ).toList());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}