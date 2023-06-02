import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastlearn/blocs/signup/signup_bloc.dart';
import 'package:lastlearn/screens/auth_screen/Signup/components/signup_form.dart';
import '../bloc/mock_provider.dart';

void main() {
  late SignupBloc signupBloc;
  late MockDataProvider dataProvider;

  setUp(() {
    dataProvider = MockDataProvider();
    signupBloc = SignupBloc(dataProvider);
  });

  testWidgets('Renders form fields and submits form',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<SignupBloc>.value(
        value: signupBloc,
        child: const SignUpForm(),
      ),
    ));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Last Name'), 'Doe');

    await tester.enterText(
        find.widgetWithText(TextFormField, 'First Name'), 'John');

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Your email'), 'test@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Your password'), 'password123');

    await tester
        .tap(find.widgetWithText(ElevatedButton, 'Sign Up'.toUpperCase()));
    await tester.pumpAndSettle();
    signupBloc.stream.listen((state) {
      expect(signupBloc.state, isA<SuccessState>());
    });
  });
}
