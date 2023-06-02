import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/blocs/vocabulary/load_vocab_bloc.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:lastlearn/repository/repository.dart';
import '../../common/generic_dialogue.dart';
import '../../../repository/local_db.dart';

class ListVocabDialog {
  late Repository repository;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Widget buildAlert(
    BuildContext context,
    int id,
    String word,
    String category,
    String meaning,
    String description,
    bool edit,
    String token,
    List<Vocabulary> vocabs,
    Vocabulary? unedited,
  ) {
    if (edit) {
      _wordController.text = word;
      _categoryController.text = category;
      _meaningController.text = meaning;
      _descriptionController.text = description;
    }
    return AlertDialog(
      title: Text(
        edit ? "Edit Word" : "Add new word",
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
                  hintText: "word",
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
                  hintText: "Category",
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
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                minLines: 5,
                maxLines: 10,
                style: TextStyle(
                  color: kPrimaryExerciseList,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  hintText: "description",
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
              ElevatedButton(
                onPressed: () {
                  if (edit) {
                    Vocabulary vocabulary = Vocabulary(
                      id: null,
                      word: _wordController.text,
                      category: _categoryController.text,
                      meaning: _meaningController.text,
                      description: _descriptionController.text,
                    );
                    context.read<VocabularyBloc>().add(EditVocabulary(
                          content: "Successfully Edited your vocabulary",
                          context: context,
                          sword: showGenericDialog,
                          title: "Edit Vocabulary",
                          token: token,
                          unedited: unedited!,
                          word: vocabulary,
                          optionsBuilder: () => {"ok": true},
                          vocabs: vocabs,
                        ));
                  } else {
                    Vocabulary vocabulary = Vocabulary(
                      id: 0,
                      word: _wordController.text,
                      category: _categoryController.text,
                      meaning: _meaningController.text,
                      description: _descriptionController.text,
                    );

                    context.read<VocabularyBloc>().add(AddVocabulary(
                          content: "Error occured while adding the Vocabulary",
                          context: context,
                          title: "Add Vocabulary",
                          optionsBuilder: () => {"ok": true},
                          sword: showGenericDialog,
                          token: token,
                          vocab: vocabulary,
                          words: vocabs,
                        ));
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  edit ? "Edit Word" : "Save Word",
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
