import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:lastlearn/blocs/sign in/signin_bloc.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/screens/exercises/exercise.dart';
import 'package:lastlearn/screens/users/contents.dart';
import 'package:lastlearn/screens/users/home.dart';
import 'package:lastlearn/screens/users/vocabulary/add_screen.dart';
import '../bloc/mock_provider.dart';

void main() {
  late MockDataProvider dataProvider;
  late CustomBloc loginBloc;
  setUp(() {
    dataProvider = MockDataProvider();
    loginBloc = CustomBloc(dataProvider: dataProvider);
  });
  testWidgets('Test HomePage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(providers: [
          BlocProvider<ProgressBloc>(
            create: (context) => ProgressBloc(dataProvider),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(dataFetch: dataProvider),
          ),
          BlocProvider<VocabularyBloc>(
            create: (context) => VocabularyBloc(dataProvider),
          ),
          BlocProvider<CustomBloc>(
            create: (context) => loginBloc,
          ),
        ], child: HomePage()),
      ),
    );

    loginBloc.emit(LoginState(role: "learner", token: "", userId: ""));
    expect(find.byType(Content), findsOneWidget);
    expect(find.byType(Exercise), findsNothing);
    expect(find.byType(VocabScreen), findsNothing);

    await tester.tap(find.text('Exercise'));
    await tester.pumpAndSettle();

    expect(find.byType(Content), findsNothing);
    expect(find.byType(Exercise), findsOneWidget);
    expect(find.byType(VocabScreen), findsNothing);

    await tester.tap(find.text('Vocabulary'));
    await tester.pumpAndSettle();

    expect(find.byType(Content), findsNothing);
    expect(find.byType(Exercise), findsNothing);
    expect(find.byType(VocabScreen), findsOneWidget);
  });
}
