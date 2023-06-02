import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/screens/profile/profile.dart';
import 'package:lastlearn/screens/users/home.dart';
import 'package:lastlearn/screens/users/root_home.dart';
import 'package:lastlearn/screens/users/wordofzd.dart';
import '../bloc/mock_provider.dart';
import 'package:lastlearn/blocs/sign in/signin_bloc.dart';

void main() {
  late MockDataProvider dataProvider;
  late CustomBloc loginBloc;
  setUp(() {
    dataProvider = MockDataProvider();
    loginBloc = CustomBloc(dataProvider: dataProvider);
  });
  testWidgets('Test RootHomepage', (WidgetTester tester) async {
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
        ], child: const RootHomepage()),
      ),
    );
    loginBloc.emit(LoginState(role: "learner", token: "", userId: ""));
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(ProfilePage), findsNothing);
    expect(find.byType(TodaysWordPage), findsNothing);

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(TodaysWordPage), findsNothing);

    await tester.tap(find.byIcon(Icons.wordpress));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(ProfilePage), findsNothing);
    expect(find.byType(TodaysWordPage), findsOneWidget);
  });
}
