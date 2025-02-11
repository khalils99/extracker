import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial(dark: false)) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);
    add(LoadTheme());
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newTheme = !state.dark;
    emit(ThemeInitial(dark: newTheme));
    _saveTheme(newTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    await Hive.openBox('settings');
    final box = Hive.box('settings');
    final isDarkMode = box.get('isDarkMode', defaultValue: false);
    emit(ThemeInitial(dark: isDarkMode));
  }

  void _saveTheme(bool isDarkMode) {
    final box = Hive.box('settings');
    box.put('isDarkMode', isDarkMode);
  }
}
