import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/screens/auth_screen/components/forgotpass.dart';

import '../../admin/bottom_navigation.dart';
import '../../common/generic_dialogue.dart';
import '../../users/home.dart';
import '../../../blocs/progress/progress_bloc.dart';
import '../../../blocs/sign in/signin_bloc.dart';
import '../already_have_an_account_acheck.dart';
import '../../common/constants.dart';
import '../Signup/signup_screen.dart';
import 'package:bloc/bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValidated = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LoginWidget(context);
  }

  SingleChildScrollView LoginWidget(BuildContext context) {
    final router = GoRouter.of(context);
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        autovalidateMode: _isFormValidated
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              validator: _validateEmail,
              onSaved: (email) {},
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.red[200]),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(149, 238, 4, 4))),
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: defaultPadding,
                bottom: 0,
              ),
              child: TextFormField(
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                obscureText: _obscureText,
                cursorColor: kPrimaryColor,
                validator: _validatePassword,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red[200]),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(149, 238, 4, 4))),
                  hintText: "Your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    color: kPrimaryOutlineBorder,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 0),
              child: TextButton(
                onPressed: () {
                  router.push("/forgotpass");
                },
                child: Text(
                  "forgot password",
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Hero(
              tag: "login_btn",
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isFormValidated = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    print("try login");
                    // Form is valid, do something
                    //GoRouter.of(context).pushReplacement('/home');
                    context.read<CustomBloc>().add(LoginAction(
                          _emailController.text,
                          _passwordController.text,
                        ));
                    // Center(child: CircularProgressIndicator());
                  }
                },
                child: Text("Log in".toUpperCase()),
              ),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              press: () {
                router.push("/SignUp");
              },
            ),
          ],
        ),
      ),
    );
  }
}
