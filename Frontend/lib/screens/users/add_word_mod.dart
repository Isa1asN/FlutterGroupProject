import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/blocs/word_moderator/Moder_word_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:lastlearn/repository/repository.dart';
import 'package:lastlearn/blocs/admin_word/word_bloc.dart';
import '../common/generic_dialogue.dart';
import '../../blocs/progress/progress_bloc.dart';
import '../../../repository/local_db.dart';

class ListWordDialog {
  late Repository repository;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Widget shareWord(
    BuildContext context,
    String word,
    String category,
    String meaning,
    String example,
    bool edit,
    String token,
    WordofDay? unedited,
  ) {
    if (edit) {
      _wordController.text = word;
      _categoryController.text = category;
      _meaningController.text = meaning;
      _descriptionController.text = example;
    }
    return AlertDialog(
      title: Text(
        edit ? "Edit Word" : "Share Word",
        style: TextStyle(
          color: kPrimaryColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          height: 500,
          width: 300,
          child: Column(
            children: [
              TextField(
                controller: _wordController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: kPrimaryExerciseList, fontSize: 20),
                decoration: const InputDecoration(
                  hintText: "Word",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: kPrimaryOutlineBorder,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _categoryController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: kPrimaryExerciseList,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  hintText: "category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: kPrimaryOutlineBorder,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _meaningController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: kPrimaryExerciseList,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  hintText: "meaning",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: kPrimaryOutlineBorder,
                      width: 2,
                    ),
                  ),
                ),
                minLines: 4,
                maxLines: 7,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                minLines: 5,
                maxLines: 10,
                style: const TextStyle(
                  color: kPrimaryExerciseList,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  hintText: "example",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: kPrimaryOutlineBorder,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  WordofDay word = WordofDay(
                    id: "",
                    word: _wordController.text,
                    category: _categoryController.text,
                    meaning: _meaningController.text,
                    example: _descriptionController.text,
                  );
                  if (edit) {
                    context.read<ModeratorWordBloc>().add(EditMyWord(
                          content: "Error occured while editing your word",
                          context: context,
                          title: "Editing Error",
                          optionsBuilder: () => {"ok": true},
                          sword: showGenericDialog,
                          token: token,
                          word: word,
                          unedited: unedited!,
                        ));
                  } else {
                    context.read<ModeratorWordBloc>().add(ShareTodaysWord(
                        token: token,
                        word: word,
                        content: "Error occured while sharing word of the day",
                        title: "Edit error",
                        context: context,
                        sword: showGenericDialog,
                        optionsBuilder: () => {"ok": true}));
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  edit ? "Edit Word" : "Share Word",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
