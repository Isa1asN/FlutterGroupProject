import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastlearn/dataprovider/data_provider.dart';

import '../../models/vocabulary.dart';
import '../../models/word_of_day.dart';

class ModeratorWordBloc extends Bloc<ModeratorWordAction, ModeratorWordState> {
  DataFetch dataProvider;
  ModeratorWordBloc(this.dataProvider) : super(ModeratorWordEmptyState()) {
    on<LoadWordOfZDay>((event, emit) async {
      WordofDay? word = await dataProvider.getTodaysWord(event.token);
      print("loaded from back $word");
      if (word != null) {
        emit(WordLoadedState(word: word));
      }
    });
    on<ShareTodaysWord>((event, emit) async {
      List<WordofDay?> words =
          await dataProvider.shareTodaysShare(event.word, event.token);
      print("-----------------------------------askjdksfkd");
      if (words.isNotEmpty) {
        // ignore: use_build_context_synchronously
        // event.sword(
        //   content: "You have successfully shared word",
        //   optionsBuilder: event.optionsBuilder,
        //   context: event.context,
        //   title: "Share Word",
        // );
        emit(WordSharedState(words: words));
      } else {
        // ignore: use_build_context_synchronously
        // event.sword(
        //   content: event.content,
        //   optionsBuilder: event.optionsBuilder,
        //   context: event.context,
        //   title: event.title,
        // );
      }
    });
    on<LoadMyWords>((event, emit) async {
      List<WordofDay?> words = await dataProvider.loadMyWords(event.token);
      if (words.isNotEmpty) {
        emit(MyWordsLoaded(words: words));
      }
      emit(NoWordsState(words: []));
    });
    on<EditMyWord>((event, emit) async {
      bool response = await dataProvider.editMyWord(
          event.token, event.unedited, event.word);
      if (response) {
        // ignore: use_build_context_synchronously
        // event.sword(
        //   content: "You have successfully edited the word",
        //   optionsBuilder: event.optionsBuilder,
        //   context: event.context,
        //   title: "Edit Word",
        // );
        emit(EditedWordSate());
      } else {
        // ignore: use_build_context_synchronously
        // event.sword(
        //   content: event.content,
        //   optionsBuilder: event.optionsBuilder,
        //   context: event.context,
        //   title: event.title,
        // );
      }
    });
    on<DeleteMyWord>((event, emit) async {
      bool response = await dataProvider.deleteMyWord(event.token, event.word);
      if (response) {
        emit(WordDeletedState());
      } else {
        // ignore: use_build_context_synchronously
        // event.sword(
        //   content: event.content,
        //   optionsBuilder: event.optionsBuilder,
        //   context: event.context,
        //   title: event.title,
        // );
      }
    });
  }
}

abstract class ModeratorWordState {}

abstract class ModeratorWordAction {}

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef UserPro = Future<dynamic> Function({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
});

class ModeratorWordEmptyState extends ModeratorWordState {}

class LoadWordOfZDay extends ModeratorWordAction {
  String token;
  LoadWordOfZDay({
    required this.token,
  });
}

class LoadingWordState extends ModeratorWordState {
  @override
  List<Vocabulary>? get vocabularies => null;
}

class WordLoadedState extends ModeratorWordState {
  WordofDay word;
  WordLoadedState({required this.word});

  @override
  List<Vocabulary>? get vocabularies => null;
}

class ShareTodaysWord extends ModeratorWordAction {
  WordofDay word;
  UserPro sword;
  DialogOptionBuilder optionsBuilder;
  BuildContext context;
  String title;
  String content;
  String token;
  ShareTodaysWord({
    required this.word,
    required this.content,
    required this.context,
    required this.optionsBuilder,
    required this.sword,
    required this.title,
    required this.token,
  });
}

class WordSharedState extends ModeratorWordState {
  @override
  List<Vocabulary>? get vocabularies => null;

  List<WordofDay?> words;
  WordSharedState({required this.words});
}

class LoadMyWords extends ModeratorWordAction {
  String token;
  LoadMyWords({required this.token});
}

class MyWordsLoaded extends ModeratorWordState {
  @override
  List<Vocabulary>? get vocabularies => null;

  List<WordofDay?> words;
  MyWordsLoaded({required this.words});
}

class NoWordsState extends ModeratorWordState {
  @override
  List<Vocabulary>? get vocabularies => null;

  List words = [];
  NoWordsState({required this.words});
}

class EditMyWord extends ModeratorWordAction {
  String token;
  WordofDay word;
  WordofDay unedited;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  DialogOptionBuilder optionsBuilder;
  EditMyWord({
    required this.content,
    required this.context,
    required this.title,
    required this.optionsBuilder,
    required this.sword,
    required this.token,
    required this.word,
    required this.unedited,
  });
}

class EditedWordSate extends ModeratorWordState {
  @override
  List<Vocabulary>? get vocabularies => null;
}

class DeleteMyWord extends ModeratorWordAction {
  String token;
  WordofDay word;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  DialogOptionBuilder optionsBuilder;
  DeleteMyWord({
    required this.content,
    required this.context,
    required this.title,
    required this.optionsBuilder,
    required this.sword,
    required this.token,
    required this.word,
  });
}

class WordDeletedState extends ModeratorWordState {
  @override
  List<Vocabulary>? get vocabularies => null;
}
