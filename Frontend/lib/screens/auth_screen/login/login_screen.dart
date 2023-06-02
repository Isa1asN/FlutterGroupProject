import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/auth_screen/responsive.dart';
import 'package:lastlearn/screens/users/root_home.dart';

import '../../admin/bottom_navigation.dart';
import '../../common/generic_dialogue.dart';
import '../../users/home.dart';
import '../../../blocs/progress/progress_bloc.dart';
import '../../../blocs/sign in/signin_bloc.dart';
import '../background.dart';
import 'login_screen_top_image.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomBloc, CustomState>(listener: (context, state) {
      if (state is LoginState) {
        context.read<ProgressBloc>().add(
              LoadProgressAction(
                token: state.token!,
                role: state.role,
                userId: state.userId,
              ),
            );
      } else if (state is NavigateState) {
        context.read<ProgressBloc>().add(
              LoadProgressAction(
                token: state.token!,
                role: state.role,
                userId: state.userId,
              ),
            );
      }
      // else if(state is UserProgressState){
      //   context.read<CustomBloc>().add()
      // }
      else if (state is ErrorState) {
        showGenericDialog(
          context: context,
          title: "Login Error",
          content: "check ur account or password",
          optionsBuilder: () => {"ok": true},
        );
      }
    }, builder: (context, state) {
      if (state is CustomStateEmpty) {
        return LoginWidget();
      } else if (state is NavigateState) {
        return BlocConsumer<ProgressBloc, ProgressState?>(
          listener: (context, state) {
            if (state is PErrorState) {
              showGenericDialog(
                context: context,
                title: state.message,
                content: state.content,
                optionsBuilder: () => {"ok": true},
              );
            }
          },
          builder: (context, state) {
            if (state is AdminPageState) {
              return BottomBar();
              // return const Text("Admin page");
            } else {
              return Container();
            }
          },
        );
      } else if (state is ErrorState) {
        return LoginWidget();
      } else if (state is LoginState) {
        print("it returned the LoginState and RootHome");
        return RootHomepage();
      } else {
        print("fghjkldjfsdoi-----------------------gjrtgiojrgj");
        return LoginWidget();
      }
    });
  }

  Background LoginWidget() {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
