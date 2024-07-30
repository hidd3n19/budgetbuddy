// expense_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:budgetbuddy/expense_repository/expense_repository.dart';
import 'package:equatable/equatable.dart';

// State
class ExpenseState extends Equatable {
  final List<Expense> expenses;

  const ExpenseState({this.expenses = const []});

  @override
  List<Object?> get props => [expenses];
}

// Event
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

// Bloc
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(const ExpenseState()) {
    on<AddExpense>((event, emit) {
      emit(ExpenseState(expenses: List.from(state.expenses)..add(event.expense)));
    });
  }
}
