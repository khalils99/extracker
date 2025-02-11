part of 'add_expense_bloc.dart';

@immutable
sealed class AddExpenseEvent {}

final class PickDateEvent extends AddExpenseEvent {
  final BuildContext context;
  final DateTime? selectedDate;

  PickDateEvent({required this.context, this.selectedDate});
}

final class InitAddExpense extends AddExpenseEvent {}

final class PickCategory extends AddExpenseEvent {
  final String category;

  PickCategory(this.category);
}

final class PickCurrency extends AddExpenseEvent {
  final String currency;

  PickCurrency(this.currency);
}

final class AddExpense extends AddExpenseEvent {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String currency;

  AddExpense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.currency,
  });
}
