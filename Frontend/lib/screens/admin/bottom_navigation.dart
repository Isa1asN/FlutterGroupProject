import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/admin/users_list.dart';
import 'package:lastlearn/screens/admin/word_of_zday.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:lastlearn/screens/profile/profile.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';

import '../../models/user.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = "/actual-home";

  BottomBar({
    super.key,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<User> users = [];
  late List<WordofDay> words;

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProgressBloc, ProgressState?>(
        listener: (context, state) {
      if (state is RoleChangedState) {}
    }, builder: (context, state) {
      return Scaffold(
        body: [
          UserList(),
          ProfilePage(),
          WordOfTheDay(),
        ][_page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          selectedItemColor: kPrimarySelectedBottobTab,
          unselectedItemColor: kPrimaryUnselectedBottomTab,
          backgroundColor: Colors.white,
          iconSize: 28,
          onTap: updatePage,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: _page == 0
                      ? kPrimarySelectedBottobTab
                      : Colors.transparent,
                  width: bottomBarBorderWidth,
                ))),
                child: const Icon(Icons.supervisor_account_rounded),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
                icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: _page == 1
                        ? kPrimarySelectedBottobTab
                        : Colors.transparent,
                    width: bottomBarBorderWidth,
                  ))),
                  child: const Icon(Icons.person),
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: _page == 2
                        ? kPrimarySelectedBottobTab
                        : Colors.transparent,
                    width: bottomBarBorderWidth,
                  ))),
                  child: const Icon(Icons.wordpress),
                ),
                label: ""),
          ],
        ),
      );
    });
  }
}
