import 'package:expense_management/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AddExpense widget has a title and buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddExpenseScreen()));
    expect(find.text('Add Expense'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('AddExpense widget shows error on empty input',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddExpenseScreen()));
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Please enter a valid amount'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('AddExpenseScreen widget submits data correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddExpenseScreen()));
    await tester.enterText(find.byKey(Key('amountField')), '100');
    await tester.enterText(find.byKey(Key('descriptionField')), 'Groceries');
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Expense added successfully'), findsOneWidget);
  });
}
