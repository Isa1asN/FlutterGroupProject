import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import 'package:lastlearn/screens/users/sentence_translate.dart';
import '../common/constants.dart';
import '../../letters/capital.dart';
import '../../letters/dachaa.dart';
import '../../letters/small.dart';
import 'course.dart';

class Content extends StatefulWidget {
  Content({
    Key? key,
  }) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  List _content = [];
  final List _theWholeContent = [];
  final List<List<Widget>> eachCourse = const [
    [CapitalLetters(), SmallLetters(), Dachaa()],
    [SmallLetters(), Dachaa()],
    [
      TranslationPage(
        originalTexts: ['Here', 'Human', 'here', 'there', "Coffee", "Year"],
        translatedTexts: ['As.', 'Nama', 'Mana', 'Gama', "Buna", "Bara"],
      ),
      TranslationPage(
        originalTexts: ['Camel', 'Leave', 'Peace', 'Proud'],
        translatedTexts: ['Gaala', 'Baala', 'Nagaa', 'Boonaa'],
      ),
      TranslationPage(
        originalTexts: [
          'Camel',
          'Leave',
          'Peace',
          'Proud',
          'Thank you',
          'Please'
        ],
        translatedTexts: [
          'Gaala',
          'Baala',
          'Nagaa',
          'Boonaa',
          "Galatoomi" "Adaraa"
        ],
      ),
      TranslationPage(
        originalTexts: ['Pleatue', 'Right', 'Child', 'Now', 'Chance', "Ear"],
        translatedTexts: [
          'Baddaa',
          'Sirrii',
          'Gaammee',
          'Amma',
          "Carraa",
          "Gurra"
        ],
      ),
      TranslationPage(
        originalTexts: ['Grass', 'See', 'Horse', 'Stubborn'],
        translatedTexts: ['Marga', 'Argi', 'Farda.', 'Gaangee.'],
      ),
      TranslationPage(
        originalTexts: ['Wedding', 'Today', 'Extra', 'Hot'],
        translatedTexts: ["Gaa'ila", "Har'a", "Fa'a.", "Ho'a"],
      )
    ],
    [
      TranslationPage(
        originalTexts: [
          'He can speak.',
          'Goodbye',
          'Thank you,',
          'Please.',
          "Where are you?",
          "Are you sure?",
          "I am student.",
          "We are SE students"
        ],
        translatedTexts: [
          "Inni dubbachu danda'a.",
          'Nagaan turi.',
          'galatoomi.',
          'Adaraa.',
          "Eessa jirta?",
          "Are you sure?",
          "Ani barataadha.",
          "Nuti barattoota software dha."
        ],
      ),
      TranslationPage(
        originalTexts: [
          'Are you there?',
          'What is going on?',
          'Can you speak?',
          'What is our name?',
          "Where are you?",
          "Is there anyone?"
        ],
        translatedTexts: [
          'Jirtaa?',
          "Maaltu ta'a jira?",
          'Dubbachuu dandeessa?',
          'Maqaankee eenyu?',
          "Eessa jirta?",
          "Namni jiraa?"
        ],
      ),
      TranslationPage(
        originalTexts: [
          'Wow',
          'What the hell!',
          'Jesus Christ',
          'You are lying!'
        ],
        translatedTexts: [
          "Ajaa'iba!",
          'Garam garam!',
          'Gooftaa Yesus!',
          'Soba jirta'
        ],
      ),
      TranslationPage(
        originalTexts: [
          'Come here.',
          'Get out.',
          'Take this book.',
          'Drink the water.'
        ],
        translatedTexts: [
          'As Koottu.',
          'Bahi asi.',
          'Kitaaba kana kaasi.',
          'Buna dhugi'
        ],
      )
    ],
  ];
  List<String> theTitles = [
    "Qubee / alphabet",
    "Sagalee / Sounds",
    "Jechoota / Words",
    "Hima / Sentence"
  ];
  List<String> theNames = ["alphabet", "sound", "word", "sentence"];
  double _duelCommandment = 0.0;

  List<int> theProgress = [];

  getContent() async {
    for (int j = 0; j < theNames.length; j++) {
      await DefaultAssetBundle.of(context)
          .loadString('json/${theNames[j]}.json')
          .then((value) {
        _content = json.decode(value);
      });
      _theWholeContent.add(_content);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    String token = context.read<CustomBloc>().state.token ?? "";
    String role = context.read<CustomBloc>().state.role ?? "";
    String userId = context.read<CustomBloc>().state.userId ?? "";
    return BlocConsumer<ProgressBloc, ProgressState>(
      listener: (context, state) {
        if (state is EmptyState) {
          print("-----------sfskjdfdj$state");
          context.read<ProgressBloc>().add(
              LoadProgressAction(token: token, role: role, userId: userId));
        }
        if (state is InitialProgress) {
          if (theProgress.isEmpty) {
            context.read<ProgressBloc>().add(
                LoadProgressAction(token: token, role: role, userId: userId));
          }
          setState(() {
            theProgress = state.progress;
          });
        }
      },
      builder: (context, state) {
        if (theProgress.isEmpty && state is InitialProgress) {
          context.read<ProgressBloc>().add(
              LoadProgressAction(token: token, role: role, userId: userId));
        }
        print(
            "--------$theProgress--------running state is--------------$state");
        return theProgress.isEmpty
            ? CheckLoaded(connected: false)
            : ListView.separated(
                itemCount: _theWholeContent.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 5,
                          right: 5,
                          bottom: 0,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    theTitles[index],
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: kPrimaryColor,
                                      inactiveTrackColor: kPrimaryLightColor,
                                      // trackShape: const RoundedRectSliderTrackShape(),
                                      trackHeight: 3.0,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 0.0),
                                      thumbColor: kPrimaryColor,
                                      overlayColor: kPrimaryColor,
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 28.0),
                                      tickMarkShape:
                                          const RoundSliderTickMarkShape(),
                                      activeTickMarkColor: kPrimaryColor,
                                      inactiveTickMarkColor: kPrimaryLightColor,
                                      valueIndicatorShape:
                                          const PaddleSliderValueIndicatorShape(),
                                      valueIndicatorColor: kPrimaryColor,
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Slider(
                                      value: theProgress[index].toDouble(),
                                      min: 0.0,
                                      max: 100.0,
                                      divisions: 10,
                                      label: theProgress[index].toString(),
                                      onChanged: (value) {
                                        setState(() {
                                          _duelCommandment = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _theWholeContent[index].length,
                                      itemBuilder: (BuildContext context,
                                          int pageIndex) {
                                        return MouseRegion(
                                          cursor: SystemMouseCursors.progress,
                                          child: GestureDetector(
                                            onTap: () {
                                              int activeProgress = 0;
                                              activeProgress = ((1 /
                                                          _theWholeContent[
                                                                  index]
                                                              .length) *
                                                      100)
                                                  .toInt();
                                              theProgress[index] =
                                                  theProgress[index] +
                                                      activeProgress;

                                              context.read<ProgressBloc>().add(
                                                    MakeProgress(
                                                      progress: [
                                                        token,
                                                        theNames[index],
                                                        theProgress[index],
                                                      ],
                                                      userId: context
                                                          .read<CustomBloc>()
                                                          .state
                                                          .userId!,
                                                    ),
                                                  );
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Course(
                                                            theContent: [
                                                              index,
                                                              pageIndex
                                                            ],
                                                            theCourses:
                                                                eachCourse,
                                                          )));
                                            },
                                            child: Container(
                                              height: 100,
                                              width: 150,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        255, 239, 243, 246),
                                                    blurRadius: 2,
                                                    offset: Offset(1, 1),
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Column(children: [
                                                Text(
                                                  _theWholeContent[index]
                                                      [pageIndex]["type"],
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 9.0,
                                                ),
                                                Expanded(
                                                  child: Image.asset(
                                                      _theWholeContent[index]
                                                          [pageIndex]["img"],
                                                      // fit: BoxFit.fitWidth,
                                                      // height: 140,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      fit: BoxFit.fitHeight),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  thickness: 1,
                  color: kPrimaryLightColor,
                  indent: 15,
                ),
              );
      },
    );
  }
}

class CheckLoaded extends StatefulWidget {
  bool connected;
  CheckLoaded({required this.connected});

  @override
  _CheckLoadedState createState() => _CheckLoadedState();
}

class _CheckLoadedState extends State<CheckLoaded> {
  Widget _child = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    _changeChildAfterDelay();
  }

  void _changeChildAfterDelay() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _child = widget.connected
              ? const Text('you have not shared anything')
              : const Text("no connection");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _child,
    );
  }
}
