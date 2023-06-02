
import 'package:flutter/material.dart';

class EachExercise extends StatefulWidget {
  late String theCourse;
  EachExercise({super.key, required this.theCourse});

  @override
  State<EachExercise> createState() => EachExerciseState();
}

class EachExerciseState extends State<EachExercise> {
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Madrid'],
      'answer': 0
    },
    {
      'question': 'What is 2+2?',
      'options': ['3', '4', '5', '6'],
      'answer': 1
    },
    {
      'question': 'What is the tallest mammal?',
      'options': ['Giraffe', 'Elephant', 'Rhino', 'Lion'],
      'answer': 0
    },
    {
      'question': 'What is the currency of Japan?',
      'options': ['Yuan', 'Rupee', 'Yen', 'Dollar'],
      'answer': 2
    },
    {
      'question': 'What is the largest planet in our solar system?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 2
    }
  ];
  List<int> selectedChoices = List.filled(5, -1);
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Page'),
      ),
      backgroundColor: Color.fromARGB(255, 226, 229, 234),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < questions.length; i++)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  color: Colors.white,
                  shadowColor: Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questions[i]['question'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        for (int j = 0; j < questions[i]['options'].length; j++)
                          Column(
                            children: [
                              RadioListTile(
                                dense: true,
                                title: Text(questions[i]['options'][j]),
                                value: j,
                                groupValue: selectedChoices[i],
                                onChanged: isSubmitted
                                    ? null
                                    : (value) {
                                        setState(() {
                                          selectedChoices[i] = value! as int;
                                        });
                                      },
                              ),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: isSubmitted ? null : submitAnswers,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitAnswers() {
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedChoices[i] == questions[i]['answer']) {
        correctAnswers++;
      }
    }
    setState(() {
      isSubmitted = true;
    });
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Result'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You got $correctAnswers out of 5 questions.'),
                    SizedBox(height: 16),
                    for (int i = 0; i < questions.length; i++)
                      Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questions[i]['question'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              for (int j = 0;
                                  j < questions[i]['options'].length;
                                  j++)
                                Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedChoices[i] == j
                                            ? questions[i]['answer'] == j
                                                ? Colors.green
                                                : Colors.red
                                            : questions[i]['answer'] == j
                                                ? Colors.green
                                                : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          (j + 1).toString(),
                                          style: TextStyle(
                                            color: selectedChoices[i] == j
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        questions[i]['options'][j],
                                        style: TextStyle(
                                          color: selectedChoices[i] == j
                                              ? questions[i]['answer'] == j
                                                  ? Colors.green
                                                  : Colors.red
                                              : questions[i]['answer'] == j
                                                  ? Colors.green
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isSubmitted = false;
                      selectedChoices = List.filled(5, -1);
                    });
                  },
                  child: Text('Close'),
                ),
              ],
            ));
  }
}
