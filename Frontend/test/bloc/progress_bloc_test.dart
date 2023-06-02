import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';
import 'package:mockito/mockito.dart';
import 'mock_provider.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';

class MockContext extends Mock implements BuildContext {}

void main() {
  late ProgressBloc progressBloc;
  late DataFetch dataProvider;

  group("Testing Progress Bloc", () {
    setUp(() {
      dataProvider = MockDataProvider();
      progressBloc = ProgressBloc(dataProvider);
    });

    blocTest(
      'emits [null] when nothing is added',
      build: () => progressBloc,
      verify: (_) => progressBloc.state == null,
    );

    blocTest(
      'emits [Initial State Progress] when data is added',
      build: () => progressBloc,
      act: (bloc) => bloc.add(MakeProgress(
        progress: [0, 0, 0, 0, 0],
        userId: "some random id",
      )),
      verify: (bloc) =>
          progressBloc.state == InitialProgress(progress: [0, 0, 0, 0, 0]),
    );
    // });

    // test("Load User Action Added", () async {
    blocTest(
      'emits [Initial State Progress] when data is added with learner role',
      build: () => progressBloc,
      act: (bloc) => bloc.add(LoadProgressAction(
        role: "learner",
        userId: "some_user_id",
        token: "some random token",
      )),
      verify: (_) =>
          progressBloc.state == InitialProgress(progress: [0, 0, 0, 0, 0]),
    );

    User user = User.fromJson({
      "_id": "some id",
      "email": "some email",
      "firstName": "some first name",
      "lastName": "some last name",
      "password": "some password",
      "role": "learner"
    });
    List<User> users = [user];
    blocTest('emits [Admin Page State] when data is added admin role',
        build: () => progressBloc,
        act: (bloc) => bloc.add(LoadProgressAction(
              role: "admin",
              userId: "some_user_id",
              token: "some_random_token",
            )),
        verify: (_) => progressBloc.state == AdminPageState(users: users));

    blocTest('emits [Role Changed State] when data is added learner role',
        build: () => progressBloc,
        act: (bloc) => bloc.add(PromoteUserAction(
            content: "",
            context: MockContext(),
            title: "",
            optionsBuilder: () => {"ok": true},
            suser: showGenericDialog,
            token: "some_random_token",
            user: user)),
        verify: (_) => progressBloc.state == RoleChangedState());
    User usera = User.fromJson({
      "_id": "some id",
      "email": "some email",
      "firstName": "some first name",
      "lastName": "some last name",
      "password": "some password",
      "role": "admin"
    });
    blocTest('emits [Role Changed State] when data is added admin role',
        build: () => progressBloc,
        act: (bloc) => bloc.add(PromoteUserAction(
            content: "",
            context: MockContext(),
            title: "",
            optionsBuilder: () => {"ok": true},
            suser: showGenericDialog,
            token: "some_random_token",
            user: usera)),
        verify: (_) => progressBloc.state == RoleChangedState());
  });
}
