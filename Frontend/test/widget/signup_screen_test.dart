import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import 'package:lastlearn/blocs/signup/signup_bloc.dart';
import 'package:lastlearn/screens/auth_screen/Signup/components/sign_up_top_image.dart';
import 'package:lastlearn/screens/auth_screen/Signup/components/signup_form.dart';
import 'package:lastlearn/screens/auth_screen/Signup/signup_screen.dart';
import '../bloc/mock_provider.dart';
import 'package:lastlearn/screens/auth_screen/login/login_screen.dart';

void main() {
  group('SignUpScreen', () {
    late SignupBloc signupBloc;
    late MockDataProvider dataProvider;

    setUp(() {
      dataProvider = MockDataProvider();
      signupBloc =
          SignupBloc(dataProvider); //I will give data provider to it later
    });

    tearDown(() {
      signupBloc.close();
    });

    testWidgets('renders SignupPage when SignupEmpty state is received',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: signupBloc,
              child: const SignUpScreen(),
            ),
          ),
        ),
      );

      signupBloc.emit(SignupEmpty());

      await tester.pump();

      expect(find.byType(SignUpScreenTopImage), findsOneWidget);
      expect(find.byType(SignUpForm), findsOneWidget);
    });

    testWidgets('renders LoginScreen when SuccessState is received',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: signupBloc,
                ),
                BlocProvider<CustomBloc>(
                  create: (context) => CustomBloc(dataProvider: dataProvider),
                )
              ],
              child: const SignUpScreen(),
            ),
          ),
        ),
      );

      signupBloc.emit(SuccessState());

      await tester.pump();

      expect(find.byType(SignUpForm), findsNothing);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('renders SignupWidget when SErrorState is received',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: signupBloc,
              child: const SignUpScreen(),
            ),
          ),
        ),
      );

      signupBloc.emit(SErrorState("unsuccessful signup"));

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}
