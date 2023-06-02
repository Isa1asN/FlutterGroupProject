import 'package:connectivity/connectivity.dart';
import 'package:lastlearn/models/progress.dart';
import 'package:lastlearn/models/vocabulary.dart';
import '../models/user.dart';
import '../models/word_of_day.dart';
import "./local_db.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//general pupose function for checking internet connection
Future<bool> isConnected([Connectivity? connectivity]) async {
  ConnectivityResult connectivityResult =
      await connectivity?.checkConnectivity() ??
          await Connectivity().checkConnectivity();

  return connectivityResult != ConnectivityResult.none;
}

// a repository class that will be used to save and fetch data from local and backend
class Repository {
  final DBHelper dbHelper;
  Connectivity connected;
  Repository({Connectivity? connected, DBHelper? dbHelper})
      : connected = connected ?? Connectivity(),
        dbHelper = dbHelper ?? DBHelper();

  String baseURI = "http://10.4.112.238:3003";
  Future<Map<String, dynamic>> login(String email, String password,
      [http.Client? httpsf]) async {
    final https = httpsf?.post ?? http.post;
    print(await isConnected());
    if (await isConnected()) {
      try {
        http.Response res = await https(
          Uri.parse("$baseURI/auth/login"),
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print(res.statusCode);
        if (res.statusCode == 200) {
          String token = jsonDecode(res.body)["token"];
          String userId = jsonDecode(res.body)["userId"];
          Map<String, dynamic> response =
              await loadCourseProgress(token, userId);
          List tobeMap = response["progress"];
          Map<String, dynamic> mymap = {
            "userId": userId,
            "alphabet": tobeMap[0],
            "sound": tobeMap[1],
            "word": tobeMap[2],
            "sentence": tobeMap[3],
            "paragraph": tobeMap[4]
          };
          await dbHelper.insertProgress(Progress.fromMap(mymap));
          return {
            "token": token,
            "role": jsonDecode(res.body)["role"],
            "success": true,
            "userId": userId
          };
        }
        return {
          "token": "",
          "success": false,
          "userId": "",
        };
      } catch (error) {
        print(error);
        return {
          "token": "",
          "success": false,
          "userId": "",
        };
      }
    } else {
      User? user = await dbHelper.getUser();
      if (email == user?.email && password == user?.password) {
        return {
          "role": user?.role,
          "success": true,
          "token": "",
          "userId": user?.id,
        };
      } else {
        return {
          "token": "",
          "success": false,
        };
      }
    }
  }

  Future<Map<String, dynamic>> signup(
      String email, String password, String fName, String lName,
      [http.Client? httpsf]) async {
    final https = httpsf?.post ?? http.post;
    print("$email $password");
    print(await isConnected());
    if (await isConnected()) {
      try {
        http.Response res = await https(
          Uri.parse("$baseURI/auth/register"),
          body: jsonEncode({
            "email": email,
            "password": password,
            "firstName": fName,
            "lastName": lName
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print(res.statusCode);
        if (res.statusCode == 201) {
          User user = User.fromJson(jsonDecode(res.body));
          user.password = password;
          dbHelper.insertUser(user);
          dbHelper.insertProgress(
            Progress(
              userId: user.id,
              alphabet: 0,
              sound: 0,
              word: 0,
              sentence: 0,
              paragraph: 0,
            ),
          );
          return {
            "success": true,
          };
        }
        return {
          "success": false,
        };
      } catch (error) {
        print(error);
        return {
          "success": false,
        };
      }
    } else {
      return {
        "success": false,
      };
    }
  }

  bool checkToken(String? token) {
    return token != null;
  }

  Future<bool> setAllProgresses(Progress progress, String token) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$baseURI/course-progress/setAllProgress"),
        body: jsonEncode({
          "alphabet": progress.alphabet,
          "sound": progress.sound,
          "word": progress.word,
          "sentence": progress.sentence,
          "paragraph": progress.paragraph
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<Map<String, dynamic>> loadCourseProgress(String token, String userId,
      [http.Client? httpsf]) async {
    final https = httpsf?.get ?? http.get;
    if (await isConnected()) {
      Progress? prog = await dbHelper.loadProgress(userId);
      print("#########################$prog");
      if (prog != null) {
        await setAllProgresses(prog, token);
      }
      try {
        http.Response res = await https(
          Uri.parse("$baseURI/course-progress/course"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        //print("plrase say something " + jsonDecode(res.body)["progress"]);
        if (res.statusCode == 200) {
          print(jsonDecode(res.body)["progress"]);
          return {
            "progress": jsonDecode(res.body)["progress"],
          };
        } else {
          return {};
        }
      } catch (error) {
        return {
          "progress": [0],
        };
      }
    } else {
      Progress? progress = await dbHelper.loadProgress(userId);
      print("-------------################--------------");
      print(progress);
      print("---------------------------");
      return {
        "progress": progress!.toList(),
      };
    }
  }

  Future<Map<String, dynamic>> updateCourseProgress(
      List<dynamic> courseDto, String userId,
      [http.Client? httpsf]) async {
    final https = httpsf?.post ?? http.post;
    if (await isConnected()) {
      Progress? prog = await dbHelper.loadProgress(userId);

      if (prog != null) {
        await setAllProgresses(prog, courseDto[0]);
      }
      try {
        await dbHelper.updateProgress(courseDto[1], courseDto[2], userId);
        http.Response res = await https(
          Uri.parse("$baseURI/course-progress/setProgress"),
          body: jsonEncode({
            courseDto[1] as String: courseDto[2] as int,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer ${courseDto[0]}"
          },
        );
        if (res.statusCode == 201) {
          return {"progress": jsonDecode(res.body)["progress"]};
        } else {
          return {
            "progress": [0, 0, 0, 0, 0]
          };
        }
      } catch (error) {
        return {
          "error": "",
        };
      }
    } else {
      Progress? progress =
          await dbHelper.updateProgress(courseDto[1], courseDto[2], userId);

      return {
        "progress": progress?.toList(),
      };
    }
  }

  Future<Map<String, dynamic>> loadUsesrs(String token,
      [http.Client? httpsf]) async {
    final https = httpsf?.get ?? http.get;
    try {
      print("print login");
      http.Response res = await https(
        Uri.parse("$baseURI/api/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );
      if (res.statusCode == 200) {
        List users = jsonDecode(res.body)["users"];
        // print(users);
        List<User> lastUsers = users.map((user) {
          User usera = User(
              id: user["_id"] ?? "id mam",
              email: user["email"],
              password: user["password"],
              firstName: user["firstName"],
              lastName: user["lastName"],
              role: user["role"]);

          print(usera);

          return usera;
        }).toList();

        // print(lastUsers);
        // List words = jsonDecode(res.body)["words"];
        // List<WordofDay> lastWords =
        //     words.map((word) => WordofDay.fromJson(word)).toList();

        return {
          "users": lastUsers,
        };
      } else {
        return {"users": ""};
      }
    } catch (error) {
      print("it is error");
      return {
        "error": "erorr",
      };
    }
  }

  Future<bool> promoteUser(User user, String token,
      [http.Client? httpsf]) async {
    final https = httpsf?.put ?? http.put;
    try {
      print("user id ${user.id}");
      String id = user.id;
      http.Response res = await https(
        Uri.parse("$baseURI/api/users/$id/assign-role"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );
      print("user id sec $id");
      print(res.statusCode);
      if (res.statusCode == 200) {
        return true;
      } else {
        print(jsonDecode(res.body)["error"]);
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> demoteUser(User user, String token,
      [http.Client? httpsf]) async {
    final https = httpsf?.put ?? http.put;
    try {
      http.Response res = await https(
        Uri.parse("$baseURI/api/users/${user.id}/revoke-role"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );
      print(res.statusCode);
      if (res.statusCode == 200) {
        user.role = user.role == "moderator" ? "learner" : "moderator";
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<List<WordofDay>> fetchTodaysWord(String token,
      [http.Client? httpsf]) async {
    final https = httpsf?.get ?? http.get;
    List<WordofDay> word = [];
    if (await isConnected()) {
      print(token);
      try {
        http.Response res = await https(
          Uri.parse("$baseURI/wordOfTD/words"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print(res.statusCode);
        if (res.statusCode == 200) {
          print(jsonDecode(res.body)["words"]);
          List words = jsonDecode(res.body)["words"];
          List<WordofDay> lastWords =
              words.map((word) => WordofDay.fromJson(word)).toList();
          return lastWords;
        }
      } catch (e) {
        return word;
      }
    }
    return word;
  }

  Future<bool> selectWord(WordofDay word, String token,
      [http.Client? httpsf]) async {
    final https = httpsf?.post ?? http.post;
    try {
      http.Response res = await https(
        Uri.parse("$baseURI/wordOfTD/theword"),
        body: jsonEncode({
          "localId": word.localId,
          "word": word.word,
          "category": word.category,
          "meaning": word.meaning,
          "example": word.example,
          "createdBy": word.createdBy
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );
      print(res.statusCode);
      if (res.statusCode == 201) {
        // user.role = user.role == "moderator" ? "learner" : "moderator";
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateAllVocabs(List<Vocabulary> vocabs, String token) async {
    try {
      print("these words--------------------------- $vocabs");
      List<String> encodedVocabs =
          vocabs.map((vocab) => jsonEncode(vocab.toJson())).toList();
      http.Response res = await http.post(
        Uri.parse("$baseURI/api/edit-all"),
        body: jsonEncode({
          "vocabs": encodedVocabs,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
      );
      print("the stausecodeeeee${res.statusCode}");
    } catch (err) {
      print(err);
    }
  }

  Future<List<Vocabulary?>> insertVocabulary(
      String token, Vocabulary vocabulary,
      [http.Client? httpsf]) async {
    final https = httpsf?.post ?? http.post;
    if (await isConnected()) {
      try {
        List<Vocabulary> fromLocal =
            await dbHelper.insertVocabulary(vocabulary);
        Vocabulary storeLocalWord = fromLocal[fromLocal.length - 1];

        print("to send ........... $storeLocalWord");
        http.Response res = await https(
          Uri.parse("$baseURI/api/vocabulary"),
          body: jsonEncode({
            "word": storeLocalWord.word,
            "category": storeLocalWord.category,
            "meaning": storeLocalWord.meaning,
            "description": storeLocalWord.description,
            "localId": storeLocalWord.id,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print("this is status code ....${res.statusCode}");
        if (res.statusCode == 201) {
          Map<String, dynamic> savedVocab = jsonDecode(res.body)["vocab"];

          Vocabulary vocab = Vocabulary.fromJson(savedVocab);
          vocab.id = storeLocalWord.id;
          return [vocab];
        }
        return [];
      } catch (error) {
        return [];
      }
    } else {
      List<Vocabulary?> storeLocalWord =
          await dbHelper.insertVocabulary(vocabulary);
      if (storeLocalWord.isNotEmpty) {
        return storeLocalWord;
      }
      return [];
    }
  }

  Future<bool> editVocabulary(
      String token, Vocabulary unedited, Vocabulary word,
      [http.Client? httpsf]) async {
    final https = httpsf?.put ?? http.put;
    if (await isConnected()) {
      try {
        await dbHelper.updateVocabulary(unedited, word);
        http.Response res = await https(Uri.parse("$baseURI/api/vocab"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({
              "localId": unedited.localId,
              "word": word.word,
              "category": word.category,
              "meaning": word.meaning,
              "description": word.description
            }));
        print(res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 200) {
          print(jsonDecode(res.body)["word"]);
          return true;
        }
        return false;
      } catch (err) {
        return false;
      }
    } else {
      return await dbHelper.updateVocabulary(unedited, word);
    }
  }

  Future<List<Vocabulary>?> fetchVocabulary(String token,
      [http.Client? httpsf]) async {
    final https = httpsf?.get ?? http.get;
    List<Vocabulary> words = [];
    if (await isConnected()) {
      try {
        List<Vocabulary> fromLocal = await dbHelper.loadVocabularies();
        print("these words--------------------------- $fromLocal");
        updateAllVocabs(fromLocal, token);
        http.Response res = await https(
          Uri.parse("$baseURI/api/vocabularies"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print("get status ${res.statusCode}");
        if (res.statusCode == 200 || res.statusCode == 201) {
          List maps = jsonDecode(res.body)["vocabs"];
          print(maps);
          words = maps.map((e) => Vocabulary.fromJson(e)).toList();
          print("after model ${words[0].id}");
          return words;
        } else {
          return words;
        }
      } catch (e) {
        return words;
      }
    } else {
      words = await dbHelper.loadVocabularies();

      return words;
    }
  }

  Future<bool> deleteVocabulary(String token, int id) async {
    if (await isConnected()) {
      try {
        await dbHelper.deleteVocabulary(id);
        http.Response res = await http.delete(
          Uri.parse("$baseURI/api/del-vocab/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print(res.statusCode);
        if (res.statusCode == 200 || res.statusCode == 204) {
          return true;
        }
        return false;
      } catch (e) {
        return false;
      }
    }

    return await dbHelper.deleteVocabulary(id);
  }

  Future<WordofDay?> getTodaysWord(String token, [http.Client? httpsf]) async {
    final https = httpsf?.get ?? http.get;
    if (await isConnected()) {
      try {
        http.Response res = await https(
          Uri.parse("$baseURI/wordOfTD/today-word"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        if (res.statusCode == 200) {
          dynamic getWord = jsonDecode(res.body)["word"];
          WordofDay theword = WordofDay.fromJson(getWord[0]);
          print("after model ${theword.id}");
          return theword;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<List<WordofDay?>> shareTodaysWord(WordofDay word, String token) async {
    if (await isConnected()) {
      try {
        List<WordofDay> fromLocal = await dbHelper.shareTodaysWord(word);
        WordofDay storeLocalWord = fromLocal[fromLocal.length - 1];

        print("to send ........... $storeLocalWord");
        http.Response res = await http.post(
          Uri.parse("$baseURI/wordOfTD/word"),
          body: jsonEncode({
            "word": storeLocalWord.word,
            "category": storeLocalWord.category,
            "meaning": storeLocalWord.meaning,
            "example": storeLocalWord.example,
            "localId": storeLocalWord.id,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print("this is status code ....${res.statusCode}");
        if (res.statusCode == 201) {
          Map<String, dynamic> theWord = jsonDecode(res.body)["savedWord"];

          WordofDay word = WordofDay.fromJson(theWord);
          word.id = storeLocalWord.id;
          return fromLocal;
        }
        return [];
      } catch (error) {
        return [];
      }
    } else {
      List<WordofDay?> storeLocalWord = await dbHelper.shareTodaysWord(word);
      if (storeLocalWord.isNotEmpty) {
        return storeLocalWord;
      }
      return [];
    }
  }

  Future<List<WordofDay?>> loadMyWords(String token) async {
    List<WordofDay> words = [];
    if (await isConnected()) {
      try {
        http.Response res = await http.get(
          Uri.parse("$baseURI/wordOfTD/mywords"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        if (res.statusCode == 200) {
          List maps = jsonDecode(res.body)["words"];
          words = maps.map((e) => WordofDay.fromJson(e)).toList();
          print("after model ${words[0].id}");
          return words;
        } else {
          return words;
        }
      } catch (e) {
        return words;
      }
    } else {
      words = await dbHelper.loadTodaysWord();
      return words;
    }
  }

  Future<bool> editMyWord(
      String token, WordofDay unedited, WordofDay word) async {
    if (await isConnected()) {
      try {
        http.Response res =
            await http.put(Uri.parse("$baseURI/wordOfTD/editword"),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  "Authorization": "Bearer $token"
                },
                body: jsonEncode({
                  "editAt": unedited.localId,
                  "word": word.word,
                  "category": word.category,
                  "meaning": word.meaning,
                  "example": word.example
                }));
        print(res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 200) {
          print(jsonDecode(res.body)["word"]);
          return true;
        }
        return false;
      } catch (err) {
        return false;
      }
    } else {
      return await dbHelper.editMyWord(unedited, word);
    }
  }

  Future<bool> deleteMyWord(String token, WordofDay word) async {
    if (await isConnected()) {
      try {
        http.Response res = await http.delete(
          Uri.parse("$baseURI/wordOfTD/deleteword/${word.localId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print(res.statusCode);
        if (res.statusCode == 200 || res.statusCode == 204) {
          return true;
        }
        return false;
      } catch (e) {
        return false;
      }
    } else {
      return await dbHelper.deleteMyWord(word);
    }
  }

  Future<bool> receive_code(String email) async {
    try {
      print(email);
      http.Response res =
          await http.post(Uri.parse("$baseURI/auth/forgotPassword"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "email": email,
              }));
      print(res.statusCode);
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<bool> resetPassword(String email, int code, String password) async {
    try {
      http.Response res =
          await http.post(Uri.parse("$baseURI/auth/resetPassword"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "email": email,
                "code": code,
                "password": password,
              }));
      print(res.statusCode);
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<User?> loadUser(String token, String useId) async {
    if (await isConnected()) {
      try {
        http.Response res = await http.get(
          Uri.parse("$baseURI/api/$useId/profile"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token"
          },
        );
        print(res.statusCode);
        if (res.statusCode == 200) {
          print(res.body);
          Map<String, dynamic> user = jsonDecode(res.body)["user"];
          print("Not modeled $user");
          User theuser = User.fromJson(user);
          print("from repo $theuser");
          return theuser;
        }
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      User? user = await dbHelper.getUser();
      return user;
    }
  }

  Future<bool> changeEmail(String token, String userId, String email) async {
    try {
      http.Response res =
          await http.put(Uri.parse("$baseURI/api/$userId/change-email"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                "Authorization": "Bearer $token"
              },
              body: jsonEncode({
                "email": email,
              }));
      print(res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 200) {
        print(jsonDecode(res.body)["user"]);
        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<bool> deleteMyAccount(
      String token, String password, String userId) async {
    try {
      http.Response res = await http.post(
        Uri.parse("$baseURI/auth/del-account/$userId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(
          {"password": password},
        ),
      );
      print(res.statusCode);
      await dbHelper.deletMe();
      if (res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
