import 'package:expense_management/features/auth/presentation/screens/signup_screen.dart';
import 'package:expense_management/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:expense_management/features/expenses/presentation/screens/all_expense_view.dart';
import 'package:expense_management/features/home/presentation/screens/home_screen.dart';
import 'package:expense_management/features/splash/presentation/screens/splash_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashView()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignupView()),
      GoRoute(path: '/expenses', builder: (context, state) => AllExpenseView()),
      GoRoute(
          path: '/add-expense',
          builder: (context, state) => AddExpenseScreen(
                id: state.uri.queryParameters['id'],
              )),
    ],
  );
}
