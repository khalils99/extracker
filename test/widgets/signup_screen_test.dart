import 'package:bloc_test/bloc_test.dart';
import 'package:expense_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_management/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthState extends Fake implements AuthState {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: SignupView(),
      ),
    );
  }

  testWidgets('SignupView has a title and form fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('create_an_account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
  });

  testWidgets('SignupView shows error message on AuthError state',
      (WidgetTester tester) async {
    whenListen(mockAuthBloc, Stream.fromIterable([AuthError('Error')]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('SignupView navigates to home on Authenticated state',
      (WidgetTester tester) async {
    whenListen(mockAuthBloc, Stream.fromIterable([Authenticated()]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(SignupView), findsNothing);
  });

  testWidgets('SignupView shows loading indicator when AuthLoading state',
      (WidgetTester tester) async {
    whenListen(mockAuthBloc, Stream.fromIterable([AuthLoading()]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SignupView calls SignUpEvent on form submit',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byKey(Key('email')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password')), 'password');
    await tester.enterText(find.byKey(Key('confirm_password')), 'password');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => mockAuthBloc.add(SignUpEvent(
          email: 'test@example.com',
          password: 'password',
          confirmPassword: 'password',
        ))).called(1);
  });
}
