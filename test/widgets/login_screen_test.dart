import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_management/features/auth/presentation/screens/login_screen.dart';
import 'package:expense_management/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

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
        create: (_) => mockAuthBloc,
        child: LoginScreen(),
      ),
    );
  }

  testWidgets('renders LoginScreen', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(Unauthenticated());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('login'), findsOneWidget);
    expect(find.text('please_sign_in_to_your_account'), findsOneWidget);
  });

  testWidgets('shows error message when AuthError state is emitted', (WidgetTester tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthError('Invalid credentials')]),
      initialState: Unauthenticated(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('navigates to home when Authenticated state is emitted', (WidgetTester tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([Authenticated()]),
      initialState: Unauthenticated(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('calls SignInEvent when login button is pressed', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(Unauthenticated());

    await tester.pumpWidget(createWidgetUnderTest());

    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    final loginButton = find.text('login');

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password');
    await tester.tap(loginButton);

    verify(() => mockAuthBloc.add(SignInEvent('test@example.com', 'password'))).called(1);
  });
}