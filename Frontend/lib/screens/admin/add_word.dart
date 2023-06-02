import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:lastlearn/repository/repository.dart';
import 'package:lastlearn/blocs/admin_word/word_bloc.dart';
import '../common/generic_dialogue.dart';
import '../../blocs/progress/progress_bloc.dart';
import '../../repository/local_db.dart';

class ListWordDialog {
  late Repository repository;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Widget addWord(
    BuildContext context,
    String token,
  ) {
    return AlertDialog(
      title: const Text(
        "Post Word of The Day",
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
                  context.read<WordOfZDBloc>().add(SelectWordOfDay(
                      token: token,
                      word: word,
                      content: "Error occured while selecting word of the day",
                      title: "Selection error",
                      context: context,
                      sword: showGenericDialog,
                      words: null,
                      optionsBuilder: () => {"ok": true}));
                },
                child: Text(
                  "Post Word",
                  style: TextStyle(
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
