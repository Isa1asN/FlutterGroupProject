import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'mock_provider.dart';
import 'package:lastlearn/blocs/profile/reset_bloc.dart';

void main() {
  late LogicHandlerBloc logicBloc;
  late DataFetch dataProvider;

  group("Testing Custom Bloc", () {
    setUp(() {
      dataProvider = MockDataProvider();
      logicBloc = LogicHandlerBloc(dataProvider);
    });

    blocTest(
      'emits [CustomStateEmpty] when nothing is added',
      build: () => logicBloc,
      verify: (_) => logicBloc.state == LogicHandlerEmpty(),
    );

    blocTest(
      'emits [LoginState] when data is added',
      build: () => logicBloc,
      act: (bloc) => bloc.add(SendCode(
        email: "email@example.com",
      )),
      verify: (_) => logicBloc.state == CodeSentState(),
    );
    // });

    // test("Load User Action Added", () async {
    blocTest(
      'emits [User Progress State] when data is added',
      build: () => logicBloc,
      act: (bloc) => bloc.add(ForgotPassword(
          code: 4598545, email: "email@example.com", password: "password")),
      verify: (_) => logicBloc.state == PasswordChanged(),
    );
  });
  // });
}
