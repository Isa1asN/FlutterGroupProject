import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';
import 'package:mockito/mockito.dart';
import 'mock_provider.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';

class MockContext extends Mock implements BuildContext {}

void main() {
  late ProfileBloc profileBloc;
  late DataFetch dataProvider;

  group("Testing Custom Bloc", () {
    setUp(() {
      dataProvider = MockDataProvider();
      profileBloc = ProfileBloc(dataFetch: dataProvider);
    });

    blocTest(
      'emits [CustomStateEmpty] when nothing is added',
      build: () => profileBloc,
      verify: (_) => profileBloc.state == ProfileEmptyState(),
    );

    User user = User.fromJson({
      "_id": "some id",
      "email": "some email",
      "firstName": "some first name",
      "lastName": "some last name",
      "password": "some password",
      "role": "learner"
    });
    blocTest(
      'emits [UserLoadedState] when data is added',
      build: () => profileBloc,
      act: (bloc) => bloc.add(
        LoadUser(
            token: "",
            userId: "",
            content: "",
            context: MockContext(),
            optionsBuilder: () => {"ok": true},
            sword: showGenericDialog,
            title: ""),
      ),
      verify: (_) => profileBloc.state == UserLoadedState(user: user),
    );
    // });

    // );
  });
  // });
}
