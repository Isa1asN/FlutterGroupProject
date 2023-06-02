import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastlearn/blocs/sign in/signin_bloc.dart';
import 'package:lastlearn/screens/auth_screen/login/login_screen.dart';
import 'package:lastlearn/screens/auth_screen/login/login_screen_top_image.dart';
import '../bloc/mock_provider.dart';
import 'package:lastlearn/screens/auth_screen/login/login_form.dart';

void main() {
  group("LoginScreen", () {
    late CustomBloc loginBloc;
    late MockDataProvider dataProvider;

    setUp(() {
      dataProvider = MockDataProvider();
      loginBloc = CustomBloc(dataProvider: dataProvider);
    });

    tearDown(() {
      loginBloc.close();
    });

    testWidgets("renders LoginPage when LoginEmpty state is received",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: loginBloc,
              child: const LoginScreen(),
            ),
          ),
        ),
      );

      loginBloc.emit(CustomStateEmpty());

      await tester.pump();

      expect(find.byType(LoginScreenTopImage), findsOneWidget);
      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets("renders HomePage when SuccessState is received",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: loginBloc,
                ),
                BlocProvider<CustomBloc>(
                  create: (context) => CustomBloc(dataProvider: dataProvider),
                )
              ],
              child: const LoginScreen(),
            ),
          ),
        ),
      );

      loginBloc.emit(LoginState(token: "", role: "learner", userId: ""));

      await tester.pump();
      // print(find.byType(LoginScreen).toString());

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets("renders LoginPage when LoginFailure state is received",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: loginBloc,
              child: const LoginScreen(),
            ),
          ),
        ),
      );

      loginBloc.emit(ErrorState("Error occured while signing"));

      await tester.pump();

      expect(find.byType(LoginScreenTopImage), findsOneWidget);
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
