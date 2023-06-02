import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lastlearn/blocs/word_moderator/Moder_word_bloc.dart';
import 'package:lastlearn/screens/auth_screen/Signup/signup_screen.dart';
import 'package:lastlearn/screens/auth_screen/components/forgotpass.dart';
import 'package:lastlearn/screens/auth_screen/login/login_screen.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';
import 'package:lastlearn/blocs/profile/reset_bloc.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';
import 'package:lastlearn/screens/exercises/exercise.dart';
import 'package:lastlearn/screens/users/home.dart';
import 'package:lastlearn/screens/profile/profile.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/blocs/signup/signup_bloc.dart';
import 'package:lastlearn/blocs/admin_word/word_bloc.dart';
import 'package:lastlearn/screens/users/wordofzd.dart';

import 'screens/auth_screen/Welcome/welcome.dart';
import 'screens/common/constants.dart';
import 'blocs/bloc_welcome/welcome_blocs.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => WelcomeBloc(),
    ),
    BlocProvider(create: (context) => SignupBloc(DataFetch())),
    BlocProvider(create: (context) => CustomBloc(dataProvider: DataFetch())),
    BlocProvider(create: (context) => ProgressBloc(DataFetch())),
    BlocProvider(create: (context) => VocabularyBloc(DataFetch())),
    BlocProvider(create: (context) => WordOfZDBloc(DataFetch())),
    BlocProvider(create: (context) => ModeratorWordBloc(DataFetch())),
    BlocProvider(create: (context) => LogicHandlerBloc(DataFetch())),
    BlocProvider(create: (context) => ProfileBloc(dataFetch: DataFetch())),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(
    routes: [
      // home route
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Material(child: Welcome()),
        ),
      ),
      GoRoute(
        path: '/SignUp',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Material(child: SignUpScreen()),
        ),
      ),
      // settings route

      GoRoute(
        path: '/SignIn',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Material(child: LoginScreen()),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Material(child: HomePage()),
        ),
      ),
      GoRoute(
        path: '/exercises',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Exercise(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: ProfilePage(),
        ),
      ),
      GoRoute(
        path: '/wotd',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: TodaysWordPage(),
        ),
      ),
      GoRoute(
        path: '/forgotpass',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: ForgotPasswordPage(),
        ),
      ),
    ],
    // handle unknown routes
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('404 Not found: ${state.error}'),
        ),
      ),
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          title: 'My App',
          theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: kPrimaryColor,
                  shape: const StadiumBorder(),
                  maximumSize: const Size(double.infinity, 56),
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: kPrimaryLightColor,
                iconColor: kPrimaryColor,
                prefixIconColor: kPrimaryColor,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
              ))),
    );
  }
}





















// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
