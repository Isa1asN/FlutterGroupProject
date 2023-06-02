import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';

class MockDataProvider extends Mock implements DataFetch {
  // @override
  // Future<Map<String, dynamic>> login(String email, String password) async {
  //   return {
  //     'success': true,
  //     'userId': "some_random_id",
  //     'role': 'learner',
  //     "token": "some_random_token",
  //   };
  // }

  @override
  Future<Map<String, dynamic>> loadCourseProgress(
      String token, String userId) async {
    return {
      "progress": [0, 0, 0, 0, 0],
    };
  }
}

void main() {
  late CustomBloc customInBloc;
  late DataFetch dataProvider;

  group("Testing Custom Bloc", () {
    setUp(() {
      dataProvider = MockDataProvider();
      customInBloc = CustomBloc(dataProvider: dataProvider);
    });

    blocTest(
      'emits [CustomStateEmpty] when nothing is added',
      build: () => customInBloc,
      verify: (_) => customInBloc.state == CustomStateEmpty(),
    );

    test("Learner Logged in", () async {
      when(dataProvider.login("email@example.com", "password"))
          .thenAnswer((_) async => {
                'success': true,
                'userId': "some_random_id",
                'role': 'learner',
                "token": "some_random_token",
              });
      blocTest(
        'emits [LoginState] when data is added',
        build: () => customInBloc,
        act: (bloc) => bloc.add(LoginAction(
          "email@example.com",
          "password",
        )),
        verify: (_) =>
            customInBloc.state ==
            LoginState(
                role: "learner",
                token: "some_random_token",
                userId: "some_random_id"),
      );
    });

    // test("Load User Action Added", () async {
    //   blocTest(
    //     'emits [User Progress State] when data is added',
    //     build: () => customInBloc,
    //     act: (bloc) => bloc.add(LoadUserAction(
    //         token: "some_random_token",
    //         role: "learner",
    //         userId: "some_random_id")),
    //     verify: (_) =>
    //         customInBloc.state ==
    //         UserProgressState(
    //             theProgress: [0, 0, 0, 0, 0],
    //             token: "somer_random_token",
    //             role: "learner",
    //             userId: "some_random_id"),
    //   );
    // });
  });
}
