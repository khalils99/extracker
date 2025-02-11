part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ExpenseModel> expenses;
  final Map data;
  final String currency;

  HomeLoaded({
    required this.expenses,
    required this.data,
    this.currency = "AED",
  });
}

final class HomeError extends HomeState {}

final class LoggedOutUser extends HomeState {}
