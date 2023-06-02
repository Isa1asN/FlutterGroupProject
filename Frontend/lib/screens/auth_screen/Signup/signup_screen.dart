import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/blocs/signup/signup_bloc.dart';
import '../../common/generic_dialogue.dart';
import '../background.dart';
import '../login/login_screen.dart';
import '../../common/constants.dart';
import '../responsive.dart';
import 'components/sign_up_top_image.dart';
import 'components/signup_form.dart';
import 'components/socal_sign_up.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(listener: (context, state) {
      if (state is SErrorState) {
        showGenericDialog(
          context: context,
          title: "Login Error",
          content: "check ur account or password",
          optionsBuilder: () => {"ok": true},
        );
      }
    }, builder: (context, state) {
      if (state is SignupEmpty) {
        return SignupWidget();
      } else if (state is SuccessState) {
        return const LoginScreen();
      } else if (state is SErrorState) {
        return SignupWidget();
      } else {
        return Container(
          child: Text("got here"),
        );
      }
    });
  }

  Background SignupWidget() {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSignupScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: SignUpForm(),
                    ),
                    SizedBox(height: defaultPadding / 2),
                    // SocalSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
