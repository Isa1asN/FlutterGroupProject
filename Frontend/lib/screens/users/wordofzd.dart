import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/blocs/word_moderator/Moder_word_bloc.dart';
import 'package:lastlearn/screens/users/add_word_mod.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:lastlearn/repository/repository.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';

import '../../models/vocabulary.dart';

class TodaysWordPage extends StatefulWidget {
  const TodaysWordPage({super.key});

  @override
  State<TodaysWordPage> createState() => _TodaysWordPageState();
}

class _TodaysWordPageState extends State<TodaysWordPage> {
  List<WordofDay> word = [];
  List<WordofDay?> myword = [];
  late ListWordDialog dialog;
  late int indexAt;

  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    String token = context.read<CustomBloc>().state.token!;
    String role = context.read<CustomBloc>().state.role!;
    return BlocConsumer<ModeratorWordBloc, ModeratorWordState>(
        listener: (context, state) {
      if (state is VocabularyEmptyState) {
        print("word to ........");
        context.read<ModeratorWordBloc>().add(LoadWordOfZDay(token: token));
      }
      if (state is VocabularyInitialState) {
        print("word to ........");
        context.read<ModeratorWordBloc>().add(LoadWordOfZDay(token: token));
      }
      if (state is WordLoadedState) {
        context.read<ModeratorWordBloc>().add(LoadMyWords(token: token));
        print("loaded word in //\\\\\\${state.word}");
        setState(() {
          word.add(state.word);
        });
      }
      if (state is MyWordsLoaded) {
        print(
            "loaded word in -----------------------------------------${state.words}");
        setState(() {
          myword = state.words;
        });
      }
      if (state is WordSharedState) {
        context.read<ModeratorWordBloc>().add(LoadMyWords(token: token));
      }
      if (state is MyWordsLoaded) {
        setState(() {
          myword = state.words;
        });
      }
      if (state is EditedWordSate) {
        context.read<ModeratorWordBloc>().add(LoadMyWords(token: token));
      }
      if (state is WordDeletedState) {
        context.read<ModeratorWordBloc>().add(LoadMyWords(token: token));
      }
    }, builder: (context, state) {
      print("current state is $state $word");

      if (word.isEmpty) {
        context.read<ModeratorWordBloc>().add(LoadWordOfZDay(
              token: token,
            ));
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text("Word Of The Day"),
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
        ),
        body: word.isEmpty
            ? CheckLoaded(
                connected: false,
              )
            : role == "moderator"
                ? ModeratorScaffold(context, token, role, myword)
                : LearnerScaffold(context, token, role, myword),
      );
    });
  }

  Scaffold ModeratorScaffold(
      BuildContext context, String token, String role, List<WordofDay?> items) {
    dialog = ListWordDialog();
    return Scaffold(
      body: CommonMethod(context, token, role, items),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog.shareWord(
                    context,
                    "",
                    "",
                    "",
                    "",
                    false,
                    token,
                    null,
                  ));
        },
      ),
    );
  }

  Scaffold LearnerScaffold(
      BuildContext context, String token, String role, List<WordofDay?> items) {
    return Scaffold(
      body: CommonMethod(context, token, role, items),
    );
  }

  Container CommonMethod(
      BuildContext context, String token, String role, List<WordofDay?> items) {
    return Container(
      alignment: Alignment.topLeft,
      color: kPrimaryLightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Column(children: [
                          Text(
                            word[0].word,
                            style: TextStyle(
                                color: kPrimaryExerciseList,
                                fontSize: 36,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            word[0].category,
                            style: TextStyle(
                              color: kPrimaryOutlineBorder,
                              fontSize: 14,
                            ),
                          ),
                        ])),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Meaning: ",
                              style: TextStyle(
                                  color: kPrimaryExerciseList,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                word[0].meaning,
                                style: TextStyle(
                                    color: kPrimaryGreydesks,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Description: ",
                              style: TextStyle(
                                  fontSize: 28,
                                  color: kPrimaryExerciseList,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                word[0].example,
                                style: TextStyle(
                                    color: kPrimaryGreydesks,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Vocabulary vocabulary = Vocabulary(
                      id: 0,
                      word: word[0].word,
                      category: word[0].category,
                      meaning: word[0].meaning,
                      description: word[0].example,
                    );
                    context.read<VocabularyBloc>().add(AddVocabulary(
                          content: "Error while adding Vocabular",
                          context: context,
                          title: "Add Vocabulary Error",
                          optionsBuilder: () => {"ok": true},
                          sword: showGenericDialog,
                          token: token,
                          vocab: vocabulary,
                          words: null,
                        ));
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text(
                    "Add to Vocabulary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (role != "learner")
            Container(
              alignment: Alignment.topLeft,
              child: Text("My Shared Words"),
            ),
          if (role == "moderator")
            Container(
              child: items.isEmpty
                  ? CheckLoaded(
                      connected: true,
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(items[index]!.word),
                            onDismissed: (direction) {
                              WordofDay theword = items[index]!;

                              context
                                  .read<ModeratorWordBloc>()
                                  .add(DeleteMyWord(
                                    content:
                                        "Error occured while trying to delet",
                                    title: "Delete Error",
                                    context: context,
                                    optionsBuilder: () => {"ok": true},
                                    sword: showGenericDialog,
                                    token: token,
                                    word: theword,
                                  ));
                              setState(() {
                                items.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${theword.word} deleted"),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(
                                    Icons.wordpress,
                                  ),
                                ),
                                title: Text(items[index]!.word),
                                subtitle: Text(items[index]!.meaning),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             VocabularyDetails(vocabulary: items[index])));
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          indexAt = index;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              dialog.shareWord(
                                            context,
                                            items[index]!.word,
                                            items[index]!.category,
                                            items[index]!.meaning,
                                            items[index]!.example,
                                            true,
                                            token,
                                            items[index],
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          indexAt = index;
                                        });
                                        WordofDay strName = items[index]!;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text("${strName.word} deleted"),
                                            duration:
                                                const Duration(seconds: 5),
                                          ),
                                        );

                                        context
                                            .read<ModeratorWordBloc>()
                                            .add(DeleteMyWord(
                                              content:
                                                  "Error occured while trying to delet",
                                              title: "Delete Error",
                                              context: context,
                                              optionsBuilder: () =>
                                                  {"ok": true},
                                              sword: showGenericDialog,
                                              word: items[index]!,
                                              token: token,
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            )
          else
            Container(),
        ],
      ),
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
    Future.delayed(Duration(seconds: 3), () {
      _child = widget.connected
          ? const Text('you have not shared anything')
          : const Text("no connection");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _child,
    );
  }
}
