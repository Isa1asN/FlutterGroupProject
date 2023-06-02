import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  String email;
  ChangeEmailPage({super.key, required this.email});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String token = context.read<CustomBloc>().state.token!;
    String userId = context.read<CustomBloc>().state.userId!;
    _emailController.text = widget.email;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Email"),
      ),
      body: Container(
        alignment: Alignment.center,
        color: kPrimaryLightColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: kPrimaryFillInputField,
                  hintText: widget.email,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: kPrimaryOutlineBorder,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text(
                  "Change Email",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  context.read<ProfileBloc>().add(ChangeEmail(
                        email: _emailController.text,
                        content: "Error occured while changing email",
                        context: context,
                        optionsBuilder: () => {"ok": true},
                        sword: showGenericDialog,
                        title: "Email Chnage Error",
                        token: token,
                        userId: userId,
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
