import 'package:http/http.dart' as http;
import 'package:lastlearn/screens/admin/word_of_zday.dart';
import 'dart:convert';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/repository/repository.dart';
import '../models/word_of_day.dart';

class DataFetch {
  Repository repository = Repository();
  String baseURI = "http://10.4.115.199:3003";
  Future<Map<String, dynamic>> login(String email, String password) {
    return repository.login(email, password);
  }

  Future<Map<String, dynamic>> signup(
      String email, String password, String fName, String lName) async {
    return await repository.signup(email, password, fName, lName);
  }

  Future<Map<String, dynamic>> loadCourseProgress(
      String token, String userId) async {
    return await repository.loadCourseProgress(token, userId);
  }

  Future<Map<String, dynamic>> updateCourseProgress(
      List<dynamic> courseDto, String userId) async {
    return await repository.updateCourseProgress(courseDto, userId);
  }

  Future<Map<String, dynamic>> loadUsesrs(String token) async {
    return await repository.loadUsesrs(token);
  }

  Future<List<WordofDay>> fetchTodaysWords(String token) async {
    return await repository.fetchTodaysWord(token);
  }

  Future<bool> promoteUser(User user, String token) async {
    return await repository.promoteUser(user, token);
  }

  Future<bool> demoteUser(User user, String token) async {
    return await repository.demoteUser(user, token);
  }

  Future<bool> selectWord(WordofDay word, String token) async {
    return await repository.selectWord(word, token);
  }

  Future<List<Vocabulary>?> fetchVocabularies(String token) async {
    return repository.fetchVocabulary(token);
  }

  Future<List<Vocabulary?>> addVocabulary(
      String token, Vocabulary vocabulary) async {
    return repository.insertVocabulary(token, vocabulary);
  }

  Future<bool> editVocabulary(
      String token, Vocabulary unedited, Vocabulary word) async {
    return repository.editVocabulary(token, unedited, word);
  }

  Future<bool> deleteVocabulary(String token, int id) async {
    return await repository.deleteVocabulary(token, id);
  }

  Future<bool> receive_code(String email) async {
    return await repository.receive_code(email);
  }

  Future<bool> resetPassword(String email, int code, String password) {
    return repository.resetPassword(email, code, password);
  }

  Future<WordofDay?> getTodaysWord(String token) async {
    return await repository.getTodaysWord(token);
  }

  Future<List<WordofDay?>> loadMyWords(String token) {
    return repository.loadMyWords(token);
  }

  Future<User?> loadUser(String token, String userId) {
    return repository.loadUser(token, userId);
  }

  Future<bool> changeEmail(String token, String userId, String email) {
    return repository.changeEmail(token, userId, email);
  }

  Future<bool> deleteMyAccount(String token, String password, String userId) {
    return repository.deleteMyAccount(token, password, userId);
  }

  Future<List<WordofDay?>> shareTodaysShare(WordofDay word, String token) {
    return repository.shareTodaysWord(word, token);
  }

  Future<bool> editMyWord(String token, WordofDay unedited, WordofDay word) {
    return repository.editMyWord(token, unedited, word);
  }

  Future<bool> deleteMyWord(String token, WordofDay word) {
    return repository.deleteMyWord(token, word);
  }
  // Future<bool> insertVocabulary(Vocabulary vocabulary, String token) async {
  //   return await repository.insertVocabulary(vocabulary, token);
  // }
}
