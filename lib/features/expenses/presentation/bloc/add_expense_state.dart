part of 'add_expense_bloc.dart';

@immutable
sealed class AddExpenseState {
  final String? title;
  final double? amount;
  final String? category;
  final DateTime? date;
  final String? currency;

  const AddExpenseState(
      {this.title, this.amount, this.category, this.date, this.currency});

  AddExpenseState merge(AddExpenseState other);
}

class AddExpenseInitial extends AddExpenseState {
  const AddExpenseInitial(
      {super.title, super.amount, super.category, super.date, super.currency});

  @override
  AddExpenseInitial merge(AddExpenseState other) {
    return AddExpenseInitial(
        title: title ?? other.title,
        amount: amount ?? other.amount,
        category: category ?? other.category,
        date: date ?? other.date,
        currency: currency ?? other.currency);
  }
}

class AddExpenseLoading extends AddExpenseState {
  const AddExpenseLoading(
      {super.title, super.amount, super.category, super.date, super.currency});

  @override
  AddExpenseLoading merge(AddExpenseState other) {
    return AddExpenseLoading(
        title: title ?? other.title,
        amount: amount ?? other.amount,
        category: category ?? other.category,
        date: date ?? other.date,
        currency: currency ?? other.currency);
  }
}

class AddExpenseSuccess extends AddExpenseState {
  const AddExpenseSuccess(
      {super.title, super.amount, super.category, super.date, super.currency});

  @override
  AddExpenseSuccess merge(AddExpenseState other) {
    return AddExpenseSuccess(
        title: title ?? other.title,
        amount: amount ?? other.amount,
        category: category ?? other.category,
        date: date ?? other.date,
        currency: currency ?? other.currency);
  }
}

class AddExpenseFailure extends AddExpenseState {
  final String message;

  const AddExpenseFailure(
      {super.title,
      super.amount,
      super.category,
      super.date,
      super.currency,
      required this.message});

  @override
  AddExpenseFailure merge(AddExpenseState other) {
    return AddExpenseFailure(
        title: title ?? other.title,
        amount: amount ?? other.amount,
        category: category ?? other.category,
        date: date ?? other.date,
        currency: currency ?? other.currency,
        message: message);
  }
}
