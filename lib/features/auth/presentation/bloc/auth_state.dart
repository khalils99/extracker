part of 'auth_bloc.dart';

abstract class AuthState {
  final bool passwordVisible;
  final bool confirmPasswordVisible;
  final bool termsAndConditionsAccepted;
  AuthState(
      {this.passwordVisible = false,
      this.confirmPasswordVisible = false,
      this.termsAndConditionsAccepted = false});
}

class AuthInitial extends AuthState {
  AuthInitial({super.passwordVisible, super.confirmPasswordVisible, super.termsAndConditionsAccepted});
}

class AuthLoading extends AuthState {
  AuthLoading({super.passwordVisible, super.confirmPasswordVisible, super.termsAndConditionsAccepted});
}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user,
      {super.passwordVisible, super.confirmPasswordVisible, super.termsAndConditionsAccepted});
}

class Unauthenticated extends AuthState {
  Unauthenticated({super.passwordVisible, super.confirmPasswordVisible, super.termsAndConditionsAccepted});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message,
      {super.passwordVisible, super.confirmPasswordVisible, super.termsAndConditionsAccepted});
}
