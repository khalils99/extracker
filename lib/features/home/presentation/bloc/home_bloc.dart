import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_management/features/auth/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

import '../../../expenses/data/repositories/expense_repo.dart';
import '../../../expenses/domain/models/expense_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _userRepo = UserRepo();
  final _expenseRepo = ExpenseRepository();

  HomeBloc() : super(HomeInitial()) {
    on<LogoutEvent>((event, emit) async {
      await _userRepo.deleteUser();
      emit(LoggedOutUser());
    });
    on<FetchAllData>(_fetchData);
    on<ChangeCurrency>(_changeCurrency);
    on<DeleteExpense>(_deleteExpense);
    on<DownloadPdfEvent>(_downloadPdf);
    on<DownloadExcelEvent>(_downloadExcel);
  }

  _deleteExpense(event, emit) async {
    try {
      await _expenseRepo.deleteExpense(event.id);
      final data = await _getData();
      emit(HomeLoaded(
        expenses: data["expenses"],
        data: {
          "total": data["data"]?["total"],
        },
        currency: state is HomeLoaded ? (state as HomeLoaded).currency : "AED",
      ));
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _changeCurrency(event, emit) async {
    try {
      final data = await _getData(currency: event.currency);
      emit(HomeLoaded(
        expenses: data["expenses"],
        data: {
          ...(state as HomeLoaded).data,
          "total": data["data"]?["total"],
        },
        currency: event.currency,
      ));
    } catch (e) {
      rethrow;
    }
  }

  _getData({String currency = "AED"}) async {
    try {
      final expenses = _expenseRepo.getExpenses();
      final total = _expenseRepo.calculateTotal(expenses, currency);
      final graph = await getCategoryWiseData();
      return {
        "data": {
          "total": total,
          "graph": graph,
        },
        "expenses": expenses,
      };
    } catch (e) {
      rethrow;
    }
  }

  getCategoryWiseData() {
    final expenses = _expenseRepo.getExpenses();
    final categories = _expenseRepo.expenseCategories;
    final data = categories.map((category) {
      final total = _expenseRepo.calculateTotal(
          expenses.where((e) => e.category == category['name']).toList(),
          state is HomeLoaded ? (state as HomeLoaded).currency : "AED");
      return {
        "name": category["name"],
        "total": total,
      };
    }).toList();
    return data;
  }

  FutureOr<void> _fetchData(event, emit) async {
    emit(HomeLoading());
    try {
      final data = await _getData();
      emit(HomeLoaded(
          expenses: data["expenses"],
          data: data['data'],
          currency:
              state is HomeLoaded ? (state as HomeLoaded).currency : "AED"));
    } catch (e) {
      emit(HomeError());
    }
  }

  _downloadPdf(event, emit) async {
    try {
      await _expenseRepo.generateExpensePdf();
    } catch (e) {
      rethrow;
    }
  }

  _downloadExcel(event, emit) async {
    try {
      await _expenseRepo.generateAndSaveExpenseExcel();
    } catch (e) {
      rethrow;
    }
  }
}
