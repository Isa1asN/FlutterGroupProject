import 'package:flutter/material.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/screens/users/vocabulary/add_screen.dart';
import 'contents.dart';
import '../exercises/exercise.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: (3), vsync: this);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        color: kPrimaryLightColor,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool isScroll) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                elevation: 3,
                forceElevated: isScroll,
                backgroundColor: Colors.white,
                toolbarHeight: 40,
                collapsedHeight: 40,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    height: 40,
                    child: TabBar(
                      labelColor: kPrimaryColor,
                      controller: _tabController,
                      automaticIndicatorColorAdjustment: true,
                      unselectedLabelColor: kPrimaryUnselectedTab,
                      unselectedLabelStyle:
                          TextStyle(color: kPrimaryLightColor),
                      indicatorColor: kPrimaryColor,
                      labelStyle: TextStyle(color: kPrimaryColor),
                      indicatorWeight: 3.5,
                      indicatorPadding: const EdgeInsets.all(0),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: const EdgeInsets.only(right: 10, left: 10),
                      tabs: const [
                        Tab(
                          child: Text(
                            'Contents',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Exercise',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Vocabulary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              Content(),
              const Exercise(),
              const VocabScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
