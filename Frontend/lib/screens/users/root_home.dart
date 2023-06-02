import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/screens/admin/word_of_zday.dart';
import 'package:lastlearn/screens/users/vocabulary/add_screen.dart';
import 'package:lastlearn/screens/exercises/exercise.dart';
import 'package:lastlearn/screens/users/home.dart';
import 'package:lastlearn/screens/profile/profile.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import 'package:lastlearn/screens/users/wordofzd.dart';

import '../common/constants.dart';

class RootHomepage extends StatefulWidget {
  const RootHomepage({super.key});

  @override
  State<RootHomepage> createState() => _RootHomepageState();
}

class _RootHomepageState extends State<RootHomepage> {
  final List<Widget> _pages = [HomePage(), ProfilePage(), TodaysWordPage()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kPrimarySelectedBottobTab,
        unselectedItemColor: kPrimaryUnselectedBottomTab,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wordpress),
            label: 'WOTD',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          // switch (index) {
          //   case 0:
          //     router.push('/home');
          //     break;

          //   case 1:
          //     router.push('/profile');
          //     break;
          //   case 2:
          //     router.push('/wotd');
          //     break;
          // }
        },
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
