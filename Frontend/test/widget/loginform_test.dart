import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/blocs/profile/reset_bloc.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import 'package:lastlearn/screens/auth_screen/already_have_an_account_acheck.dart';
import 'package:lastlearn/screens/auth_screen/login/login_form.dart';
import '../bloc/mock_provider.dart';

void main() {
  late MockDataProvider dataProvider;

  setUp(() {
    dataProvider = MockDataProvider();
  });
  testWidgets('Test LoginForm', (WidgetTester tester) async {
    final signInBloc = CustomBloc(dataProvider: dataProvider);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CustomBloc>(
              create: (context) => CustomBloc(dataProvider: dataProvider),
            ),
            BlocProvider<LogicHandlerBloc>(
              create: (context) => LogicHandlerBloc(dataProvider),
            ),
          ],
          child: const LoginForm(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    await tester.tap(find.text('Log in'.toUpperCase()));
    await tester.pumpAndSettle();

    signInBloc.emit(LoginState(
      userId: "some user id",
      role: 'learner',
      token: "some_random_token",
    ));

    expect(
        signInBloc.state,
        LoginState(
          userId: "some user id",
          role: 'learner',
          token: "some_random_token",
        ));

    expect(find.text('forgot password'), findsOneWidget);

    expect(find.byType(AlreadyHaveAnAccountCheck), findsOneWidget);
  });
}
