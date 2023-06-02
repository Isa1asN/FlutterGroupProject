import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastlearn/models/word_of_day.dart';

import '../../dataprovider/data_provider.dart';

class WordOfZDBloc extends Bloc<WordAction, WordState> {
  DataFetch dataProvider;
  WordOfZDBloc(this.dataProvider) : super(EmptyWordState()) {
    on<LoadWordAction>((event, emit) async {
      List<WordofDay> response = [];

      response = await dataProvider.fetchTodaysWords(event.token);

      if (response.isNotEmpty) {
        emit(WordsLoadedState(words: response));
      }
    });
    on<SelectWordOfDay>(
      (event, emit) async {
        print(event.word);
        bool response = await dataProvider.selectWord(event.word, event.token);
        if (!response) {
          // ignore: use_build_context_synchronously
          event.sword(
            content: event.content,
            optionsBuilder: event.optionsBuilder,
            context: event.context,
            title: event.title,
          );
        } else {
          event.words?.remove(event.sword);

          // ignore: use_build_context_synchronously
          event.sword(
            content: "You Have Successfully Posted Word of The Day",
            optionsBuilder: event.optionsBuilder,
            context: event.context,
            title: "Posted Successfully",
          );
          emit(WordSelectedState(words: event.words));
        }
      },
    );
  }
}

abstract class WordAction {}

abstract class WordState {}

class EmptyWordState extends WordState {}

class LoadWordAction extends WordAction {
  String token;
  LoadWordAction({
    required this.token,
  });
}

class WordsLoadedState extends WordState {
  List<WordofDay> words;
  WordsLoadedState({required this.words});
}

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef UserPro = Future<dynamic> Function({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
});

class SelectWordOfDay extends WordAction {
  String token;
  WordofDay word;
  UserPro sword;
  BuildContext context;
  String title;
  String content;
  List<WordofDay>? words;
  DialogOptionBuilder optionsBuilder;
  SelectWordOfDay({
    required this.content,
    required this.context,
    required this.title,
    required this.optionsBuilder,
    required this.sword,
    required this.token,
    required this.word,
    required this.words,
  });
}

class WordSelectedState extends WordState {
  List<WordofDay>? words;
  WordSelectedState({required this.words});
}
