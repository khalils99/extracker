import 'package:expense_management/features/home/presentation/bloc/home_bloc.dart';
import 'package:expense_management/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:expense_management/firebase_options.dart';
import 'package:expense_management/helpers/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('expenses');
  await Hive.openBox('user_data');
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Sizer(builder: (context, orientation, device) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
            BlocProvider(create: (_) => SplashBloc()..add(CheckAuth())),
            BlocProvider(create: (_) => AuthBloc()),
            BlocProvider(create: (_) => HomeBloc()..add(FetchAllData())),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return AnimatedTheme(
                data: state.dark ? AppTheme.darkTheme : AppTheme.lightTheme,
                duration: const Duration(milliseconds: 500),
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: state.dark ? ThemeMode.dark : ThemeMode.light,
                  routerConfig: AppRouter.router,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
