import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'mock_provider.dart';
import 'package:lastlearn/blocs/signup/signup_bloc.dart';

void main() {
  late SignupBloc signBloc;
  late DataFetch dataProvider;

  group("Testing Custom Bloc", () {
    setUp(() {
      dataProvider = MockDataProvider();
      signBloc = SignupBloc(dataProvider);
    });

    blocTest(
      'emits [SignupEmpty] when nothing is added',
      build: () => signBloc,
      verify: (_) => signBloc.state == SignupEmpty(),
    );

    blocTest(
      'emits [SuccessState] when data is added',
      build: () => signBloc,
      act: (bloc) => bloc.add(SignupRequest(
        email: "email@example.com",
        password: "password",
        fName: "some name",
        lName: "some name",
      )),
      verify: (_) => signBloc.state == SuccessState(),
    );
    // });
  });
}
