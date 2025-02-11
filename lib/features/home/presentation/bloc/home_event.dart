part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LogoutEvent extends HomeEvent {}

final class FetchAllData extends HomeEvent {}

final class ChangeCurrency extends HomeEvent {
  final String currency;

  ChangeCurrency(this.currency);
}

final class DeleteExpense extends HomeEvent {
  final String id;

  DeleteExpense(this.id);
}

final class DownloadPdfEvent extends HomeEvent {}

final class DownloadExcelEvent extends HomeEvent {}
