import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/screens/auth_screen/login/login_screen.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';

import '../../../blocs/profile/reset_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool first = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogicHandlerBloc, LogicHandlerState>(
        listener: (context, state) {
      if (state is CodeSentState) {
        setState(() {
          first = false;
        });
        showGenericDialog(
            context: context,
            title: "Code Sent",
            content: "Code sent to your email, check your email",
            optionsBuilder: () => {"ok": true});
      }

      if (state is LErrorState) {
        showGenericDialog(
            context: context,
            title: "Error occured",
            content: "Error occured try again, please",
            optionsBuilder: () => {"ok": true});
      }

      if (state is PasswordChanged) {
        showGenericDialog(
          context: context,
          title: "Successfully Resetted",
          content:
              "You have successfuly resetted your password, go to login page",
          optionsBuilder: () => {"ok": true},
        );
      }
    }, builder: (context, state) {
      if (state is LogicHandlerEmpty) {
        return ResetPage(context);
      } else if (state is CodeSentState) {
        return ResetPage(context);
      } else if (state is PasswordChanged) {
        // GoRouter.of(context).pushReplacement('/SignIn');
        return const LoginScreen();
      } else {
        return Container();
      }
    });
  }

  Scaffold ResetPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              first ? 'Enter your email address ' : "Enter the code",
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 30.0),
            first
                ? TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  )
                : TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'your code here',
                      border: OutlineInputBorder(),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            first
                ? SizedBox()
                : TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'password',
                      border: OutlineInputBorder(),
                    ),
                  ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                if (first) {
                  context
                      .read<LogicHandlerBloc>()
                      .add(SendCode(email: _emailController.text));
                } else {
                  context.read<LogicHandlerBloc>().add(ForgotPassword(
                        email: _emailController.text,
                        code: int.parse(_codeController.text),
                        password: _passwordController.text,
                      ));
                }
              },
              child: Text(first ? 'Send Code' : "Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
