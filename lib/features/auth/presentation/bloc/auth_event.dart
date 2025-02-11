part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email, password;

  SignInEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}

class TogglePasswordVisibilityEvent extends AuthEvent {}

class ToggleConfirmPasswordVisibilityEvent extends AuthEvent {}

class ToggleTermsAndConditionsEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email, password, confirmPassword;

  SignUpEvent(
      {required this.email,
      required this.password,
      required this.confirmPassword});
}
