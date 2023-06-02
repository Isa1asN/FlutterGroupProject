import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../blocs/bloc_welcome/welcome_events.dart';
import '../../../blocs/bloc_welcome/welcome_states.dart';
import '../../common/constants.dart';
import '../../../blocs/bloc_welcome/welcome_blocs.dart';
// import 'bloc/welcome_events.dart';
// import 'bloc/welcome_events.dart';
// import 'bloc/welcome_blocs.dart';
// import 'bloc/welcome_states.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 35),
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      state.page = index;
                      BlocProvider.of<WelcomeBloc>(context).add(WelcomeEvent());
                    },
                    children: [
                      _page(
                          1,
                          context,
                          "next",
                          "Welcome!",
                          "Welcome to our Afan Oromo language learning app.",
                          "assets/images/welcome.jpg"),
                      _page(
                          2,
                          context,
                          "next",
                          "Communicate with anyone",
                          "Never let a language be an abstacle to you to communicate with others.",
                          "assets/images/ppl.png"),
                      _page(
                          3,
                          context,
                          "Get started",
                          "Anywhere, anytime",
                          " The time is at your discretion so study whenever you want.",
                          "assets/images/pic1.jpg"),
                    ],
                  ),
                  Positioned(
                      bottom: 35,
                      child: DotsIndicator(
                        position: state.page.toInt(),
                        dotsCount: 3,
                        mainAxisAlignment: MainAxisAlignment.center,
                        decorator: DotsDecorator(
                            activeColor: kPrimaryColor,
                            size: Size.square(8),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            activeSize: Size(18, 8)),
                      )),
                ],
              )),
        );
      },
    );
  }

  Widget _page(int index, BuildContext context, String buttonName, String title,
      String subtitle, String imgPath) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: imgPath == 'assets/images/ppl.png' ? 40 : 0,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: imgPath == 'assets/images/ppl.png' ? 210 : 350,
            child: Image.asset(
              imgPath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: imgPath == 'assets/images/ppl.png' ? 120 : 60,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                if (index < 3) {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.decelerate,
                  );
                } else {
                  GoRouter.of(context).pushReplacement('/SignIn');
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: imgPath == 'assets/images/ppl.png' ? 160 : 120,
                  left: 25,
                  right: 25,
                ),
                width: 325,
                height: 50,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Center(
                    child: Text(
                  buttonName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )),
              )),
          const SizedBox(height: 100), // add some space at the bottom
        ],
      ),
    );
  }
}
