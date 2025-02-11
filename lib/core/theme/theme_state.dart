part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {
  final bool dark;

  const ThemeState({this.dark = true});
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial({super.dark});
}
