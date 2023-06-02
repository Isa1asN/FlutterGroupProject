import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/repository/local_db.dart';

import '../../screens/common/generic_dialogue.dart';

class ProfileBloc extends Bloc<ProfileAction, ProfileState> {
  DataFetch dataFetch;
  DBHelper dbHelper = DBHelper();
  ProfileBloc({required this.dataFetch}) : super(ProfileEmptyState()) {
    on<LoadUser>((event, emit) async {
      User? user = await dataFetch.loadUser(event.token, event.userId);
      print("loaded user $user");
      if (user != null) {
        emit(UserLoadedState(user: user));
      } else {
        // ignore: use_build_context_synchronously
        event.sword(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      }
    });
    on<ChangeEmail>((event, emit) async {
      bool response =
          await dataFetch.changeEmail(event.token, event.userId, event.email);
      if (response) {
        // ignore: use_build_context_synchronously
        event.sword(
          content: "Email has been succesfully changed",
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: "Email Change",
        );
        emit(ChangeEmailState());
      } else {
        // ignore: use_build_context_synchronously
        event.sword(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      }
    });
    on<LogoutEvent>((event, emit) async {
      print("im heeeeeeeeeeerrrrrreeeeeeeeeee");
      await dbHelper.logout();
      print("tologoutooooooooooooooo");
      emit(LogedoutState());
      print("emited state-----------------------------");
    });
    on<RestoreProfile>((event, emit) {
      emit(ProfileEmptyState());
    });
    on<DeleteMyAccount>((event, emit) async {
      bool response = await dataFetch.deleteMyAccount(
        event.token,
        event.password,
        event.userId,
      );
      if (response) {
        emit(AccountDeletedState());
      } else {
        // ignore: use_build_context_synchronously
        event.sword(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      }
    });
  }
}

abstract class ProfileAction {}

abstract class ProfileState {}

class ProfileEmptyState extends ProfileState {}

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef UserPro = Future<dynamic> Function({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
});

class LoadUser extends ProfileAction {
  String token;
  String userId;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  DialogOptionBuilder optionsBuilder;
  LoadUser({
    required this.token,
    required this.userId,
    required this.content,
    required this.context,
    required this.optionsBuilder,
    required this.sword,
    required this.title,
  });
}

class ChangeEmail extends ProfileAction {
  String email;
  String token;
  String userId;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  DialogOptionBuilder optionsBuilder;
  ChangeEmail({
    required this.email,
    required this.content,
    required this.context,
    required this.optionsBuilder,
    required this.sword,
    required this.title,
    required this.token,
    required this.userId,
  });
}

class UserLoadedState extends ProfileState {
  User user;
  UserLoadedState({required this.user});
}

class ChangeEmailState extends ProfileState {}

class LogoutEvent extends ProfileAction {}

class LogedoutState extends ProfileState {}

class RestoreProfile extends ProfileAction {}

class DeleteMyAccount extends ProfileAction {
  String token;
  String userId;
  UserPro sword;
  BuildContext context;
  String password;
  String content;
  String title;
  DialogOptionBuilder optionsBuilder;
  DeleteMyAccount({
    required this.content,
    required this.title,
    required this.userId,
    required this.context,
    required this.optionsBuilder,
    required this.sword,
    required this.password,
    required this.token,
  });
}

class AccountDeletedState extends ProfileState {}
