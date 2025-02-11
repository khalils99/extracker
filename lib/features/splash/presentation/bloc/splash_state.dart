part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class NavigateToAuth extends SplashState {}

final class NavigateToHome extends SplashState {}