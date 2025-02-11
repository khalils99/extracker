import 'dart:async';

import 'package:expense_management/helpers/ui_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepo _userRepo = UserRepo();

  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>(_signIn);
    on<SignOutEvent>((event, emit) async {
      await _auth.signOut();
      emit(Unauthenticated());
    });
    on<TogglePasswordVisibilityEvent>((event, emit) {
      emit(AuthInitial(
          passwordVisible: !state.passwordVisible,
          confirmPasswordVisible: state.confirmPasswordVisible,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted));
    });
    on<ToggleConfirmPasswordVisibilityEvent>((event, emit) {
      emit(AuthInitial(
          confirmPasswordVisible: !state.confirmPasswordVisible,
          passwordVisible: state.passwordVisible,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted));
    });
    on<ToggleTermsAndConditionsEvent>((event, emit) {
      emit(AuthInitial(
          confirmPasswordVisible: state.confirmPasswordVisible,
          passwordVisible: state.passwordVisible,
          termsAndConditionsAccepted: !state.termsAndConditionsAccepted));
    });
    on<SignUpEvent>(_signUp);
  }

  FutureOr<void> _signUp(event, emit) async {
    try {
      emit(AuthLoading(
          passwordVisible: state.passwordVisible,
          confirmPasswordVisible: state.confirmPasswordVisible,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted));
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = UserModel(
        id: userCredential.user!.uid,
        email: event.email,
        password: event.password,
        token: userCredential.user?.refreshToken,
      );
      await _userRepo.saveUser(user);
      emit(Authenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError(e is FirebaseAuthException
          ? e.message.toString()
          : e.errorFromException));
    }
  }

  _signIn(event, emit) async {
    try {
      emit(AuthLoading(
          passwordVisible: state.passwordVisible,
          confirmPasswordVisible: state.confirmPasswordVisible,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted));
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = UserModel(
        id: userCredential.user?.uid,
        email: event.email,
        password: event.password,
        token: userCredential.user?.refreshToken,
      );
      await _userRepo.saveUser(user);
      emit(Authenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError(e is FirebaseAuthException
          ? e.message.toString()
          : e.errorFromException));
      rethrow;
    }
  }
}
