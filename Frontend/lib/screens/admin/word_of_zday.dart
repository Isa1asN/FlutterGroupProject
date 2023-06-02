import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:lastlearn/repository/repository.dart';
import 'package:lastlearn/blocs/admin_word/word_bloc.dart';

import '../../blocs/sign in/signin_bloc.dart';
import '../common/generic_dialogue.dart';
import '../../blocs/progress/progress_bloc.dart';
import 'add_word.dart';

class WordOfTheDay extends StatefulWidget {
  WordOfTheDay();
  @override
  _WordOfTheDayState createState() {
    return _WordOfTheDayState();
  }
}

class _WordOfTheDayState extends State<WordOfTheDay> {
  late ListWordDialog dialog;
  Repository repository = Repository();
  List<WordofDay> words = [];

  _WordOfTheDayState();
  @override
  Widget build(BuildContext context) {
    dialog = ListWordDialog();
    String token = context.read<CustomBloc>().state.token!;

    return BlocConsumer<WordOfZDBloc, WordState>(listener: (context, state) {
      if (state is EmptyWordState) {
        context.read<WordOfZDBloc>().add(LoadWordAction(token: token));
      }
      if (state is WordsLoadedState) {
        print("......................");
        setState(() {
          words = state.words;
        });
      }
    }, builder: (context, state) {
      if (words.isEmpty) {
        context.read<WordOfZDBloc>().add(LoadWordAction(token: token));
      }
      print("the running state is $state");
      return Scaffold(
        appBar: AppBar(
          title: const Text("Word Of The Day"),
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
        ),
        body: words.isEmpty
            ? CheckLoaded()
            : ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: kPrimaryExerciseList,
                        child: Icon(
                          Icons.wordpress,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(words[index].word),
                      subtitle: Text(words[index].meaning),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WordofDayDetails(
                                    vocabulary: words[index])));
                      },
                      trailing: SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text(
                            "Select",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            context.read<WordOfZDBloc>().add(SelectWordOfDay(
                                token: context.read<CustomBloc>().state.token!,
                                word: words[index],
                                content:
                                    "Error occured while selecting word of the day",
                                title: "Selection error",
                                context: context,
                                sword: showGenericDialog,
                                words: words,
                                optionsBuilder: () => {"ok": true}));
                            words.removeAt(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => dialog.addWord(
                context,
                token,
              ),
            );
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  // Future<void> addWord(String token, WordofDay word) async {
  //   await repository.selectWord(word, token);
  // }
}

class WordofDayDetails extends StatelessWidget {
  final WordofDay vocabulary;
  const WordofDayDetails({Key? key, required this.vocabulary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vocabulary Details"),
      ),
      body: Column(
        children: [
          Text(vocabulary.word),
          Text(vocabulary.meaning),
          Text(vocabulary.example),
        ],
      ),
    );
  }
}

class CheckLoaded extends StatefulWidget {
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
      setState(() {
        _child = Text('No today\'s word shared');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _child,
    );
  }
}
