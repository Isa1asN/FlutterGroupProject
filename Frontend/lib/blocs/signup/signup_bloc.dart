import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';

class SignupBloc extends Bloc<SignupAction, SignupState> {
  SignupBloc(DataFetch dataProvider) : super(SignupEmpty()) {
    on<SignupRequest>((event, emit) async {
      // emit(LoadingState());
      print(event.email);
      Map<String, dynamic> response = await dataProvider.signup(
        event.email,
        event.password,
        event.fName,
        event.lName,
      );
      print(response["success"]);
      if (response["success"]) {
        emit(SuccessState());
      } else {
        emit(SErrorState("Error occured while signing"));
      }
    });
  }
}

class SignupEmpty extends SignupState {}

abstract class SignupAction {
  SignupAction();
}

abstract class SignupState {
  SignupState();
}

class SignupRequest extends SignupAction {
  String email;
  String fName;
  String lName;
  String password;
  SignupRequest({
    required this.email,
    required this.fName,
    required this.lName,
    required this.password,
  });
}

class LoadingState extends SignupState {}

class SuccessState extends SignupState {}

class SErrorState extends SignupState {
  String message;
  SErrorState(this.message);
}
