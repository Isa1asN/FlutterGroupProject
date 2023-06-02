import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:http/testing.dart';
import 'package:lastlearn/models/progress.dart';
import 'package:lastlearn/models/user.dart';
import 'package:lastlearn/models/vocabulary.dart';
import 'package:lastlearn/models/word_of_day.dart';
import 'package:lastlearn/repository/local_db.dart';
import 'package:mockito/annotations.dart';
import 'package:lastlearn/repository/repository.dart';
import "package:mockito/mockito.dart";

class MockConnectivity extends Mock implements Connectivity {
  @override
  Future<ConnectivityResult> checkConnectivity() {
    return Future.value(ConnectivityResult.mobile);
  }
}

// class MockHttpClient extends Mock implements http.Client {}

class MockDatabase extends Mock implements DBHelper {
  @override
  Future<int> insertUser(User user) {
    return Future.value(1);
  }

  @override
  Future<int> insertProgress(Progress progress) {
    return Future.value(1);
  }

  @override
  Future<Progress?> loadProgress(String id) async {
    return Progress(
      userId: "sample_user_id",
      alphabet: 0,
      sound: 0,
      word: 0,
      sentence: 0,
      paragraph: 0,
    );
  }

  @override
  Future<Progress?> updateProgress(
      String specific, int value, String userId) async {
    return Progress(
        userId: "", alphabet: 0, sound: 0, word: 0, sentence: 0, paragraph: 0);
  }

  @override
  Future<List<Vocabulary>> insertVocabulary(Vocabulary vocabulary) {
    return Future.value([
      Vocabulary(
          id: 1,
          word: "word",
          category: "category",
          meaning: "meaning",
          description: "description")
    ]);
  }

  @override
  Future<bool> updateVocabulary(Vocabulary vocabulary, Vocabulary vocab) async {
    return true;
  }
}

// @GenerateMocks([Database])
@GenerateMocks([http.Client])
void main() {
  late MockConnectivity mockConnectivity;
  late Repository repository;
  late MockClient mockHttpClient;
  late MockDatabase mockDatabase;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockDatabase = MockDatabase();
    repository =
        Repository(connected: mockConnectivity, dbHelper: mockDatabase);
  });
  test('isConnected', () async {
    // when(mockConnectivity.checkConnectivity())
    //     .thenReturn(Future.value(ConnectivityResult.mobile));
    final connected = await isConnected(mockConnectivity);

    expect(connected, true);
  });

  test('login', () async {
    mockHttpClient = MockClient((request) async => http.Response(
          '{"token": "sample_token", "role": "admin", "success": true}',
          200,
          headers: {'content-type': 'application/json'},
        ));
    String email = 'login@example.com';

    String password = 'password';
    String path = 'some_path';
    final result = await repository.login(email, password, mockHttpClient);

    expect(result, {
      "token": "sample_token",
      "role": "admin",
      "success": true,
    });
    // verify(isConnected(mockConnectivity));
  });

  test('signup - successful registration', () async {
    const email = 'test@example.com';
    const password = 'password';
    const fName = 'John';
    const lName = 'Doe';
    const path = 'some_path';
    Map<String, dynamic> user = {
      "_id": "some id",
      "role": "learner",
      "email": email,
      "password": password,
      "firstName": fName,
      "lastName": lName
    };
    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode(user),
          201,
          headers: {'content-type': 'application/json'},
        ));

    // Mock the HTTP response

    final result =
        await repository.signup(email, password, fName, lName, mockHttpClient);

    expect(result, {
      "success": true,
    });
  });

  test("setAllProgresses", () async {
    Progress progress = Progress(
      userId: "some id",
      alphabet: 10,
      sound: 20,
      word: 30,
      sentence: 40,
      paragraph: 50,
    );
    String token = 'sample_token';

    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode({
            "alphabet": progress.alphabet,
            "sound": progress.sound,
            "word": progress.word,
            "sentence": progress.sentence,
            "paragraph": progress.paragraph,
          }),
          201,
          headers: {'content-type': 'application/json'},
        ));
    final result = await repository.setAllProgresses(progress, token);

    expect(result, isA<bool>());
  });

  test('loadCourseProgress - successful', () async {
    String token = 'sample_token';

    mockHttpClient = MockClient((request) async => http.Response(
          '{"progress": [1, 2, 3, 4, 5]}',
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result =
        await repository.loadCourseProgress(token, "", mockHttpClient);

    expect(result, {
      "progress": [1, 2, 3, 4, 5],
    });
  });

  test('updateCourseProgress - successful', () async {
    String token = 'sample_token';
    List<dynamic> courseDto = [
      token,
      'course_id',
      10,
    ];

    mockHttpClient = MockClient((request) async => http.Response(
          '{"progress": [1, 2, 3, 4, 5]}',
          201,
          headers: {'content-type': 'application/json'},
        ));

    final result =
        await repository.updateCourseProgress(courseDto, "", mockHttpClient);

    expect(result, {
      "progress": [1, 2, 3, 4, 5],
    });

    // // Verify that the dbHelper updateProgress method was called with the correct parameters
    // verify(repository.dbHelper.updateProgress('course_id', 10)).called(1);
  });

  test("Load users", () async {
    String token = 'sample_token';
    List users = [
      {
        "_id": "some id",
        "role": "learner",
        "email": "example@test.com",
        "password": "password",
        "firstName": "fedasa",
        "lastName": "bote"
      },
    ];
    List words = [
      {
        "word": "learner",
        "category": "example@test.com",
        "meaning": "password",
        "example": "fedasa",
      },
    ];
    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode({"users": users, "words": words}),
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.loadUsesrs(token, mockHttpClient);

    expect(result, {"users": isA<List>(), "words": isA<List>()});
  });

  test('promoteUser - successful', () async {
    String token = 'sample_token';
    User user = User(
      firstName: "fedasa",
      lastName: "bote",
      email: "fedasagete@gmail.com",
      password: "password",
      id: 'sample_user_id',
      role: 'learner',
    );

    mockHttpClient = MockClient((request) async => http.Response(
          "",
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.promoteUser(user, token, mockHttpClient);

    expect(result, true);
    expect(user.role, 'moderator');
  });

  test('demoteUser - successful', () async {
    String token = 'sample_token';
    User user = User(
      firstName: "fedasa",
      lastName: "bote",
      email: "fedasagete@gmail.com",
      password: "password",
      id: 'sample_user_id',
      role: 'moderator',
    );

    mockHttpClient = MockClient((request) async => http.Response(
          "",
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.demoteUser(user, token, mockHttpClient);

    expect(result, true);
    expect(user.role, 'learner');
  });

  test("fetchTodaysWord - successfull", () async {
    String token = 'sample_token';
    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode({
            "words": [
              {
                "word": "learner",
                "category": "example@test.com",
                "meaning": "password",
                "example": "fedasa",
              }
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.fetchTodaysWord(token, mockHttpClient);

    expect(result, isA<List>());
  });

  test("selectWord - successful", () async {
    String token = "sample_token";
    WordofDay word = WordofDay(
        id: "",
        word: "garaa",
        category: "maqaa",
        meaning: "kan nyaatu",
        example: "kan nyaata bulleessuu garaacha");

    mockHttpClient = MockClient((request) async => http.Response(
          "",
          201,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.selectWord(word, token, mockHttpClient);

    expect(result, true);
  });

  test('insertVocabulary -- succeesfull', () async {
    String token = "Sample_token";
    Vocabulary vocabulary = Vocabulary(
        id: 0,
        word: "harree",
        category: "maqaa",
        meaning: "kan nyaatu hin quufne",
        description: "harreen miila afur qabdi");

    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode(vocabulary.toMap()),
          201,
          headers: {'content-type': 'application/json'},
        ));

    final result =
        await repository.insertVocabulary(token, vocabulary, mockHttpClient);

    expect(result, isA<Vocabulary>());
  });

  test('editVocabulary -- succeesfull', () async {
    String token = "Sample_token";
    Vocabulary vocabulary = Vocabulary(
        id: 0,
        word: "harree",
        category: "maqaa",
        meaning: "kan nyaatu hin quufne",
        description: "harreen miila afur qabdi");

    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode(vocabulary.toMap()),
          201,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.editVocabulary(
        token, vocabulary, vocabulary, mockHttpClient);

    expect(result, isA<Vocabulary>());
  });

  test('fetchVocabulary -- succeesfull', () async {
    String token = "Sample_token";
    List vocabs = [
      {
        "id": "",
        "word": "harree",
        "category": "maqaa",
        "meaning": "kan nyaatu hin quufne",
        "description": "harreen miila afur qabdi"
      }
    ];

    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode({"vocabs:$vocabs"}),
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.fetchVocabulary(token, mockHttpClient);

    expect(result, isA<List>());
  });

  test("getTodayWord -- succeesfull", () async {
    String token = "Sample_token";
    final vocabs = [
      {
        "word": "harree",
        "category": "maqaa",
        "meaning": "kan nyaatu hin quufne",
        "example": "harreen miila afur qabdi"
      }
    ];

    mockHttpClient = MockClient((request) async => http.Response(
          jsonEncode({"word": vocabs}),
          200,
          headers: {'content-type': 'application/json'},
        ));

    final result = await repository.getTodaysWord(token, mockHttpClient);

    expect(result, isA<WordofDay>());
  });
}
