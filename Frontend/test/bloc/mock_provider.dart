import 'package:lastlearn/dataprovider/data_provider.dart';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:mockito/mockito.dart';

class MockDataProvider extends Mock implements DataFetch {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    return {
      'success': true,
      "userId": "some user id",
      'role': 'learner',
      "token": "some_random_token",
    };
  }

  @override
  Future<Map<String, dynamic>> signup(
      // ignore: use_function_type_syntax_for_parameters

      String email,
      String password,
      String fName,
      String lName) async {
    print("I have reacehd here whit $email $password $fName $lName");
    return {
      "success": true,
    };
  }

  @override
  Future<Map<String, dynamic>> loadCourseProgress(
      String token, String userId) async {
    return {
      "progress": [0, 0, 0, 0, 0],
    };
  }

  @override
  Future<Map<String, dynamic>> updateCourseProgress(
      List<dynamic> courseDto, String userId) async {
    return {
      "progress": [0, 0, 0, 0, 0]
    };
  }

  @override
  Future<Map<String, dynamic>> loadUsesrs(String token) async {
    User user = User.fromJson({
      "_id": "some id",
      "email": "some email",
      "firstName": "some first name",
      "lastName": "some last name",
      "password": "some password",
      "role": "learner"
    });
    List<User> users = [user];
    return {"users": users};
  }

  @override
  Future<bool> promoteUser(User user, String token) async {
    return true;
  }

  @override
  Future<bool> demoteUser(User user, String token) async {
    return true;
  }

  @override
  Future<bool> selectWord(WordofDay word, String token) async {
    return true;
  }

  @override
  Future<List<WordofDay>> fetchTodaysWords(String token) async {
    return [
      WordofDay(
        id: "some id",
        word: "some word",
        meaning: "some meaning",
        example: "some example",
        category: "some category",
      )
    ];
  }

  @override
  Future<bool> receive_code(String email) async {
    return true;
  }

  @override
  Future<bool> resetPassword(String email, int code, String password) async {
    return true;
  }

  @override
  Future<User?> loadUser(String token, String userId) async {
    User user = User.fromJson({
      "_id": "some id",
      "email": "some email",
      "firstName": "some first name",
      "lastName": "some last name",
      "password": "some password",
      "role": "learner"
    });
    return user;
  }

  @override
  Future<bool> changeEmail(String token, String userId, String email) async {
    return true;
  }

  @override
  Future<WordofDay?> getTodaysWord(String token) async {
    return WordofDay(
      id: "some id",
      word: "some word",
      meaning: "some meaning",
      example: "some example",
      category: "some category",
    );
  }

  @override
  Future<List<Vocabulary>?> fetchVocabularies(String token) async {
    return [
      Vocabulary(
        id: 1,
        word: "some word",
        meaning: "some meaning",
        description: "some example",
        category: "some category",
      )
    ];
  }
}
