import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';

import '../../models/vocabulary.dart';
import '../../models/word_of_day.dart';

class VocabularyBloc extends Bloc<VocabularyAction, VocabularyState> {
  DataFetch dataProvider;
  VocabularyBloc(this.dataProvider) : super(VocabularyEmptyState()) {
    on<AddVocabulary>((event, emit) async {
      List<Vocabulary?> response =
          await dataProvider.addVocabulary(event.token, event.vocab);
      if (response.isEmpty) {
        // ignore: use_build_context_synchronously
        event.sword(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      } else {
        emit(AddedVoacbularyState(vocabulary: event.vocab, vocabs: response));
      }
    });

    on<EditVocabulary>((event, emit) async {
      bool response = await dataProvider.editVocabulary(
          event.token, event.unedited, event.word);
      if (response == false) {
        // ignore: use_build_context_synchronously
        event.sword(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      } else {
        // ignore: use_build_context_synchronously
        event.sword(
          content: "You Have Successfully Edited the Word",
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: "Posted Successfully",
        );
        emit(EditedVocabState(
          vocabulary: event.word,
          vocabs: event.vocabs,
        ));
      }
    });

    on<LoadVocabulariesAction>((event, emit) async {
      List<Vocabulary>? response =
          await dataProvider.fetchVocabularies(event.token);
      print(response);
      if (response != null) {
        emit(VocabularyInitialState(vocabularies: response));
      }
    });

    on<DeleteVocabularyAction>((event, emit) async {
      bool response =
          await dataProvider.deleteVocabulary(event.token, event.id);
      if (response) {
        emit(DeletedVocabState(vocabs: event.vocabs));
      } else {
        // ignore: use_build_context_synchronously
        event.sword(
          content: event.content,
          optionsBuilder: event.optionsBuilder,
          context: event.context,
          title: event.title,
        );
      }
    });
  }
}

abstract class VocabularyState {
  List<Vocabulary>? get vocabularies;
}

class VocabularyEmptyState extends VocabularyState {
  @override
  List<Vocabulary>? get vocabularies => null;
}

class VocabErrorState extends VocabularyState {
  @override
  List<Vocabulary>? get vocabularies => null;
}

class VocabularyInitialState extends VocabularyState {
  @override
  List<Vocabulary>? vocabularies;
  VocabularyInitialState({required this.vocabularies});
}

class AddedVoacbularyState extends VocabularyState {
  Vocabulary vocabulary;
  List<Vocabulary?> vocabs;
  AddedVoacbularyState({
    required this.vocabulary,
    required this.vocabs,
  });

  @override
  List<Vocabulary>? get vocabularies => null;
}

class EditedVocabState extends VocabularyState {
  Vocabulary? vocabulary;
  List<Vocabulary> vocabs;
  EditedVocabState({
    required this.vocabulary,
    required this.vocabs,
  });

  @override
  List<Vocabulary>? get vocabularies => vocabs;
}

class DeletedVocabState extends VocabularyState {
  List<Vocabulary> vocabs;
  DeletedVocabState({required this.vocabs});
  @override
  List<Vocabulary>? get vocabularies => vocabs;
}

abstract class VocabularyAction {}

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef UserPro = Future<dynamic> Function({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
});

class AddVocabulary extends VocabularyAction {
  String token;
  Vocabulary vocab;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  List<Vocabulary>? words;
  DialogOptionBuilder optionsBuilder;
  AddVocabulary({
    required this.content,
    required this.context,
    required this.title,
    required this.optionsBuilder,
    required this.sword,
    required this.token,
    required this.vocab,
    required this.words,
  });
}

class EditVocabulary extends VocabularyAction {
  String token;
  Vocabulary word;
  Vocabulary unedited;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  List<Vocabulary> vocabs;
  DialogOptionBuilder optionsBuilder;
  EditVocabulary({
    required this.content,
    required this.context,
    required this.title,
    required this.optionsBuilder,
    required this.sword,
    required this.token,
    required this.word,
    required this.unedited,
    required this.vocabs,
  });
}

class LoadVocabulariesAction extends VocabularyAction {
  String token;
  List<Vocabulary>? vocabs;
  LoadVocabulariesAction({
    required this.token,
    required this.vocabs,
  });
}

class DeleteVocabularyAction extends VocabularyAction {
  int id;
  UserPro sword;
  DialogOptionBuilder optionsBuilder;
  BuildContext context;
  String title;
  String content;
  List<Vocabulary> vocabs;
  String token;
  DeleteVocabularyAction({
    required this.id,
    required this.token,
    required this.sword,
    required this.optionsBuilder,
    required this.context,
    required this.content,
    required this.title,
    required this.vocabs,
  });
}
