import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';

import '../../screens/common/generic_dialogue.dart';
import '../../models/vocabulary.dart';

class LogicHandlerBloc extends Bloc<LogicHandlerAction, LogicHandlerState> {
  DataFetch dataProvider;
  LogicHandlerBloc(this.dataProvider) : super(LogicHandlerEmpty()) {
    on<SendCode>((event, emit) async {
      print(event.email);
      bool response = await dataProvider.receive_code(event.email);

      if (response) {
        emit(CodeSentState());
      } else {
        emit(LErrorState());
      }
    });
    on<ForgotPassword>((event, emit) async {
      bool response = await dataProvider.resetPassword(
        event.email,
        event.code,
        event.password,
      );
      if (response) {
        emit(PasswordChanged());
      } else {
        emit(LErrorState());
      }
    });
  }
}

abstract class LogicHandlerState {}

class LogicHandlerEmpty extends LogicHandlerState {}

abstract class LogicHandlerAction {}

class ForgotPassword extends LogicHandlerAction {
  String email;
  String password;
  int code;
  ForgotPassword({
    required this.code,
    required this.email,
    required this.password,
  });
}

class SendCode extends LogicHandlerAction {
  String email;
  SendCode({required this.email});
}

class PasswordChanged extends LogicHandlerState {}

class CodeSentState extends LogicHandlerState {}

class LErrorState extends LogicHandlerState {}
