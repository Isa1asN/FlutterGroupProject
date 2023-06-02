import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
// import 'package:lastlearn/repository/local_db.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/repository/repository.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';
import '../../common/constants.dart';
import 'add_dialog.dart';

class VocabScreen extends StatefulWidget {
  const VocabScreen({
    Key? key,
  }) : super(key: key);

  @override
  _VocabScreenState createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  Repository repository = Repository();
  List<Vocabulary> items = [];
  late ListVocabDialog dialog;
  late int indexAt;
  bool isDismiss = true;
  _VocabScreenState();

  // @override
  // void initState() {
  //   context.read<ProgressBloc>().add(LoadVocabularies(vocabularies: items));
  //   super.initState();
  //   print("here is the changed $items");
  // }r

  @override
  Widget build(BuildContext context) {
    dialog = ListVocabDialog();
    String token = context.read<CustomBloc>().state.token!;

    return BlocConsumer<VocabularyBloc, VocabularyState>(
        listener: (context, state) {
      if (state is VocabularyEmptyState) {
        print("---------------to load vocabs");
        context
            .read<VocabularyBloc>()
            .add(LoadVocabulariesAction(token: token, vocabs: items));
        print("vocabs loaded #######################");
      }
      if (state is VocabularyInitialState) {
        print("here it is fetched..............");
        setState(() {
          items = state.vocabularies!;
        });
      } else if (state is AddedVoacbularyState) {
        context
            .read<VocabularyBloc>()
            .add(LoadVocabulariesAction(token: token, vocabs: items));
        // setState(() {
        //   items.add(state.vocabulary);
        // });
      } else if (state is EditedVocabState) {
        context
            .read<VocabularyBloc>()
            .add(LoadVocabulariesAction(token: token, vocabs: items));
        // setState(() {
        //   items[indexAt] = state.vocabulary!;
        // });
      } else if (state is DeletedVocabState) {
        setState(() {
          items.removeAt(indexAt);
        });
        context
            .read<VocabularyBloc>()
            .add(LoadVocabulariesAction(token: token, vocabs: items));
        // setState(() {
        //   if (!isDismiss) {
        //     items.removeAt(indexAt);
        //   }
        // });
      }
    }, builder: (context, state) {
      if (items.isEmpty && state is VocabularyInitialState) {
        context
            .read<VocabularyBloc>()
            .add(LoadVocabulariesAction(token: token, vocabs: items));
      }
      if (state is VocabularyEmptyState) {
        print("---------------to load vocabs");
        context
            .read<VocabularyBloc>()
            .add(LoadVocabulariesAction(token: token, vocabs: items));
        print("vocabs loaded #######################");
      }
      print("working state is..........$state");
      return VocabularyPage(token, context, items);
    });
  }

  Scaffold VocabularyPage(
      String token, BuildContext context, List<Vocabulary> vocabs) {
    return Scaffold(
      body: items.isEmpty
          ? CheckLoaded()
          : Container(
              color: kPrimaryLightColor,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(items[index].word),
                    onDismissed: (direction) {
                      Vocabulary strName = items[index];
                      setState(() {
                        indexAt = index;
                      });
                      context.read<VocabularyBloc>().add(DeleteVocabularyAction(
                            id: items[index].localId!,
                            content: "Error occured while trying to delet",
                            title: "Delete Error",
                            context: context,
                            optionsBuilder: () => {"ok": true},
                            sword: showGenericDialog,
                            vocabs: items,
                            token: token,
                          ));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${strName.word} deleted"),
                          duration: const Duration(seconds: 5),
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
                        title: Text(items[index].word),
                        subtitle: Text(items[index].meaning),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VocabularyDetails(
                                      vocabulary: items[index])));
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
                                      dialog.buildAlert(
                                    context,
                                    items[index].id!,
                                    items[index].word,
                                    items[index].category,
                                    items[index].meaning,
                                    items[index].description,
                                    true,
                                    token,
                                    items,
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
                                  isDismiss = false;
                                });
                                Vocabulary strName = items[index];
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${strName.word} deleted"),
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                                // sleep(Duration(seconds: 5));
                                context
                                    .read<VocabularyBloc>()
                                    .add(DeleteVocabularyAction(
                                      id: items[index].localId!,
                                      content:
                                          "Error occured while trying to delet",
                                      title: "Delete Error",
                                      context: context,
                                      optionsBuilder: () => {"ok": true},
                                      sword: showGenericDialog,
                                      vocabs: items,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildAlert(
              context,
              0,
              "",
              "",
              "",
              "",
              false,
              token,
              items,
              null,
            ),
          );
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VocabularyDetails extends StatelessWidget {
  // final Vocabulary vsocabulary;
  Vocabulary vocabulary;
  VocabularyDetails({required this.vocabulary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vocabulary Details"),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Column(children: [
                  Text(
                    vocabulary.word,
                    style: TextStyle(
                        color: kPrimaryExerciseList,
                        fontSize: 36,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    vocabulary.category,
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
                        vocabulary.meaning,
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
                        vocabulary.description,
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
      if (mounted) {
        setState(() {
          _child = Text('No vocabularies');
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
