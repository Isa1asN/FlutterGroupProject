import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lastlearn/screens/admin/users_list.dart';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:path/path.dart';
import '../../dataprovider/data_provider.dart';

class ProgressBloc extends Bloc<ProgressAction, ProgressState> {
  ProgressBloc(DataFetch dataProvider) : super(EmptyState()) {
    on<MakeProgress>((event, emit) async {
      Map<String, dynamic> response =
          await dataProvider.updateCourseProgress(event.progress, event.userId);

      print(response["error"]);
      emit(InitialProgress(progress: response["progress"].cast<int>()));
    });
    on<LoadProgressAction>((event, emit) async {
      if (event.role == "admin") {
        Map<String, dynamic> response =
            await dataProvider.loadUsesrs(event.token);
        print(response["users"]);
        List<User> users = response["users"];

        emit(AdminPageState(
          users: users,
        ));
      } else {
        Map<String, dynamic> response =
            await dataProvider.loadCourseProgress(event.token, event.userId);
        print("----------------------------${response["progress"]}");
        emit(InitialProgress(
          progress: response["progress"].cast<int>(),
        ));
      }
    });

    on<PromoteUserAction>((event, emit) async {
      bool response;
      print(event.user.id);
      if (event.user.role == "learner") {
        response = await dataProvider.promoteUser(
          event.user,
          event.token,
        );
      } else {
        response = await dataProvider.demoteUser(
          event.user,
          event.token,
        );
      }
      if (!response) {
        // ignore: use_build_context_synchronously
        event.suser(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      } else {
        emit(RoleChangedState());
      }
    });
  }
}

class EmptyState extends ProgressState {
  @override
  List<int>? get value => null;
}

class InitialProgress extends ProgressState {
  List<int> progress;
  InitialProgress({required this.progress});

  @override
  List<int> get value => progress;
}

abstract class ProgressAction {}

abstract class ProgressState {
  List<int>? get value;
}

class PErrorState extends ProgressState {
  String message;
  String content;
  PErrorState(
    this.message,
    this.content,
  );

  @override
  List<int>? get value => null;
}

class MakeProgress extends ProgressAction {
  List<dynamic> progress;
  String userId;
  MakeProgress({
    required this.progress,
    required this.userId,
  });
}

class LoadProgressAction extends ProgressAction {
  String token;
  String role;
  String userId;
  LoadProgressAction({
    required this.token,
    required this.role,
    required this.userId,
  });
}

class AdminPageState extends ProgressState {
  List<User> users;
  AdminPageState({
    required this.users,
  });

  @override
  List<int>? get value => null;
}

class PromoteUserState extends ProgressState {
  @override
  List<int>? get value => null;
}

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef UserPro = Future<dynamic> Function({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
});

class PromoteUserAction extends ProgressAction {
  String token;
  User user;
  UserPro suser;
  BuildContext context;
  String title;
  String content;
  DialogOptionBuilder optionsBuilder;
  PromoteUserAction({
    required this.content,
    required this.context,
    required this.title,
    required this.optionsBuilder,
    required this.suser,
    required this.token,
    required this.user,
  });
}

class RoleChangedState extends ProgressState {
  @override
  List<int>? get value => null;

  RoleChangedState();
}
