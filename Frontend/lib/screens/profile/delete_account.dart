import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:lastlearn/repository/repository.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import '../common/generic_dialogue.dart';
import '../../../repository/local_db.dart';

class DeleteAccountPop {
  final TextEditingController _wordController = TextEditingController();

  Widget deleteAccount(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        "Delete Account Confirmation",
        style: TextStyle(
          color: kPrimaryColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 200,
          width: 300,
          child: Column(
            children: [
              TextField(
                controller: _wordController,
                style: TextStyle(color: kPrimaryExerciseList, fontSize: 20),
                decoration: const InputDecoration(
                  hintText: "enter your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: kPrimaryOutlineBorder,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  String token = context.read<CustomBloc>().state.token!;
                  String userId = context.read<CustomBloc>().state.userId!;
                  context.read<ProfileBloc>().add(DeleteMyAccount(
                        content:
                            "Error occured while deleting your account. Try again, please!",
                        context: context,
                        userId: userId,
                        title: "Delete Account",
                        optionsBuilder: () => {"ok": true},
                        sword: showGenericDialog,
                        token: token,
                        password: _wordController.text,
                      ));
                  Navigator.pop(context);
                },
                child: Text(
                  "Confirm",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
