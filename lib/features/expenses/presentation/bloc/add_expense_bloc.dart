import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/expense_repo.dart';
import '../../domain/models/expense_model.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final dateController = TextEditingController();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _expenseRepo = ExpenseRepository();
  final formKey = GlobalKey<FormState>();
  final String? _id;

  AddExpenseBloc(this._id) : super(AddExpenseInitial()) {
    on<InitAddExpense>(_init);
    on<PickDateEvent>(_pickDate);
    on<PickCategory>(_pickCategory);
    on<PickCurrency>(_pickCurrency);
    on<AddExpense>(_addExpense);
  }

  FutureOr<void> _init(event, emit) {
    print(_id);
    if (_id != null) {
      final expense =
          _expenseRepo.getExpenses().firstWhere((element) => element.id == _id);
      titleController.text = expense.title;
      amountController.text = expense.amount.toString();
      dateController.text = DateFormat("MMM dd, yyyy").format(expense.date);
      emit(AddExpenseInitial(
        title: expense.title,
        amount: expense.amount,
        date: expense.date,
        currency: expense.currency,
        category: expense.category,
      ));
    } else {
      emit(AddExpenseInitial(
          currency: "AED",
          category: ExpenseRepository().expenseCategories.first['name']));
    }
  }

  FutureOr<void> _pickCurrency(event, emit) {
    Map selected = _expenseRepo.currencies.firstWhere(
      (element) => element['id'].toString() == event.currency.toString(),
      orElse: () => _expenseRepo.expenseCategories.first,
    );
    emit(AddExpenseInitial(currency: selected['name']).merge(state));
  }

  _pickCategory(event, emit) {
    emit(AddExpenseInitial(
      category: _expenseRepo.expenseCategories.firstWhere(
        (element) => element['id'] == event.category,
        orElse: () => _expenseRepo.expenseCategories.first,
      )['name'],
    ).merge(state));
  }

  FutureOr<void> _pickDate(event, emit) async {
    final value = await showDatePicker(
        context: event.context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: event.selectedDate ?? DateTime.now());
    if (value != null) {
      dateController.text = DateFormat("MMM dd, yyyy").format(value);
      emit(AddExpenseInitial(
        date: value,
      ).merge(state));
    }
  }

  _addExpense(AddExpense event, Emitter<AddExpenseState> emit) async {
    emit(AddExpenseLoading().merge(state));
    try {
      await _expenseRepo.addExpense(ExpenseModel(
        id: _id ?? DateTime.now().toString(),
        title: event.title,
        amount: event.amount,
        status: "active",
        createdAt: DateTime.now(),
        category: event.category,
        date: event.date,
        currency: event.currency,
      ));
      emit(AddExpenseSuccess().merge(state));
    } catch (e) {
      emit(AddExpenseFailure(message: e.toString()).merge(state));
    }
  }
}
