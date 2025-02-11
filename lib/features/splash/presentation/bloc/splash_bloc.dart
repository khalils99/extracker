import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:expense_management/features/auth/data/repositories/auth_repository.dart';
import 'package:expense_management/helpers/ui_helpers.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final _usersRepo = UserRepo();
  SplashBloc() : super(SplashInitial()) {
    on<CheckAuth>(_init);
  }
  Future<void> _init(event, emit) async {
    try {
      final user = await _usersRepo.getUserModel();
      if (user == null) {
        emit(NavigateToAuth());
      } else {
        emit(NavigateToHome());
      }
    } catch (e) {
      print(e.errorFromException);
      emit(NavigateToAuth());
    }
  }
}
