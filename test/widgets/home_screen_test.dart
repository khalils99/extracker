import 'package:bloc_test/bloc_test.dart';
import 'package:expense_management/features/expenses/domain/models/expense_model.dart';
import 'package:expense_management/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:expense_management/features/home/presentation/bloc/home_bloc.dart';
import 'package:expense_management/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

void main() {
  late HomeBloc homeBloc;

  setUp(() {
    homeBloc = MockHomeBloc();
  });

  tearDown(() {
    homeBloc.close();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen displays welcome message',
      (WidgetTester tester) async {
    when(() => homeBloc.state).thenReturn(HomeInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('HomeScreen displays total expense', (WidgetTester tester) async {
    when(() => homeBloc.state).thenReturn(HomeLoaded(
      currency: 'USD',
      data: {'total': 1000.0, 'graph': []},
      expenses: [],
    ));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('USD 1000.00'), findsOneWidget);
  });

  testWidgets('HomeScreen displays recent transactions',
      (WidgetTester tester) async {
    when(() => homeBloc.state).thenReturn(HomeLoaded(
      currency: 'USD',
      data: {'total': 1000.0, 'graph': []},
      expenses: [
        ExpenseModel(
            id: '1',
            title: 'Groceries',
            amount: 50.0,
            currency: 'USD',
            date: DateTime.now(),
            category: 'Food',
            createdAt: DateTime.now(),
            status: 'active'),
      ],
    ));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Groceries'), findsOneWidget);
  });

  testWidgets('HomeScreen navigates to add expense screen on button press',
      (WidgetTester tester) async {
    when(() => homeBloc.state).thenReturn(HomeInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    expect(find.byType(AddExpenseScreen), findsOneWidget);
  });

  testWidgets('HomeScreen logs out user on logout button press',
      (WidgetTester tester) async {
    when(() => homeBloc.state).thenReturn(HomeInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    verify(() => homeBloc.add(LogoutEvent())).called(1);
  });
}
