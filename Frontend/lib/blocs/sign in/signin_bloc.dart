
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';

class CustomStateEmpty extends CustomState {
  @override
  String? get token => null;

  @override
  String? get role => null;

  @override
  String? get userId => null;
}

class LoadingState extends CustomState {
  @override
  String? get token => null;

  @override
  String? get role => null;

  @override
  String? get userId => null;
}

class CustomBloc extends Bloc<CustomAction, CustomState> {
  CustomBloc({required DataFetch dataProvider}) : super(CustomStateEmpty()) {
    on<LoginAction>((event, emit) async {
      print(event.email);
      print(event.password);
      Map<String, dynamic> response =
          await dataProvider.login(event.email, event.password);
      if (response["success"]) {
        if (response["role"] as String == "admin") {
          emit(
            NavigateState(
              role: response["role"],
              token: response["token"],
              userId: response["userId"],
            ),
          );
        } else if (response["role"] == "moderator" ||
            response["role"] == "learner") {
          emit(
            LoginState(
              token: response["token"],
              role: response["role"],
              userId: response["userId"],
            ),
          );
        }
      } else {
        emit(ErrorState("Error occured while signing"));
      }
    });
    on<LoadUserAction>((event, emit) async {
      Map<String, dynamic> response =
          await dataProvider.loadCourseProgress(event.token, event.userId);
      print(response["progress"]);
      emit(UserProgressState(
        theProgress: response["progress"].cast<int>(),
        token: event.token,
        role: event.role,
        userId: "",
      ));
    });
    on<RestoreState>((event, emit) {
      emit(CustomStateEmpty());
    });
  }
}

abstract class CustomState {
  const CustomState();
  String? get token;
  String? get role;
  String? get userId;

  set token(String? newToken) => token = newToken;
}

abstract class CustomAction {
  const CustomAction();
}

class LoginAction extends CustomAction {
  String email;
  String password;
  LoginAction(this.email, this.password);
}

class LoginState extends CustomState {
  @override
  String? token;

  @override
  String userId;

  @override
  String role;
  LoginState({
    required this.token,
    required this.role,
    required this.userId,
  });

  @override
  operator ==(Object other) {
    if (other is LoginState) {
      return token == other.token &&
          role == other.role &&
          userId == other.userId;
    }
    return false;
  }

  @override
  int get hashCode => userId.hashCode ^ role.hashCode ^ token.hashCode;
}

class LoadUserAction extends CustomAction {
  String token;
  String role;
  String userId;
  LoadUserAction({
    required this.token,
    required this.role,
    required this.userId,
  });
}

class UserProgressState extends CustomState {
  List<int> theProgress;
  @override
  String? token;
  @override
  String userId;
  @override
  String role;
  UserProgressState({
    required this.theProgress,
    required this.token,
    required this.role,
    required this.userId,
  });
}

class ErrorState extends CustomState {
  String message;
  ErrorState(this.message);

  @override
  String? get token => null;

  @override
  String? get role => null;

  @override
  String? get userId => null;
}

class NavigateState extends CustomState {
  @override
  String role;
  @override
  String? token;

  @override
  String userId;
  NavigateState({
    required this.role,
    required this.token,
    required this.userId,
  });
}

class RestoreState extends CustomAction {}
