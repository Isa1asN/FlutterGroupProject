// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../commons/add_screen.dart';
// import 'Signup/signup_screen.dart';
// import 'components/login_screen.dart';
// import 'welcome/welcome.dart';
// import 'home.dart';

// final router = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//       path: '/',
//       pageBuilder: (context, state) => const MaterialPage(child: Welcome()),
//     ),
//     GoRoute(
//       path: '/more',
//       pageBuilder: (context, state) => MaterialPage<void>(
//         key: state.pageKey,
//         child: const VocabScreen(),
//       ),
//     ),
//     GoRoute(
//       path: '/SignIn',
//       pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
//     ),
//     GoRoute(
//       path: '/SignUp',
//       pageBuilder: (context, state) =>
//           const MaterialPage(child: SignUpScreen()),
//     ),
//     GoRoute(
//       path: '/home',
//       pageBuilder: (context, state) => const MaterialPage(child: MyHomePage()),
//     ),
//   ],
// );
