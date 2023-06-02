import 'package:flutter/material.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'each_exercise.dart';

class Exercise extends StatefulWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  double _duelCommandment = 1;
  final List theExercise = [
    "Shaakala Qubee / Exercise on alphabet",
    "Shaakala Sagalee / Exercise on sounds",
    "Shaakala Jechootaa / Exercise on words",
    "Shaakala Himaa / Exercise on sentence",
    "Shaakala Keeyyataa / Exercise on paragraph"
  ];
  final List theProgress = [80, 70, 50, 10, 25];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: theExercise.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (_, i) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EachExercise(theCourse: theExercise[i])));
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: Colors.white,
            shadowColor: Colors.black38,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      theExercise[i],
                      style: const TextStyle(
                          color: kPrimaryExerciseList,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                    Icon(
                      Icons.read_more,
                      size: 40,
                      color: kPrimaryExerciseList,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:lastlearn/each_exercise.dart';

// class Exercise extends StatefulWidget {
//   const Exercise({Key? key}) : super(key: key);

//   @override
//   State<Exercise> createState() => _ExerciseState();
// }

// class _ExerciseState extends State<Exercise> {
//   double _duelCommandment = 1;
//   final List theExercise = [
//     "Shaakala Qubee / Exercise on alphabet",
//     "Shaakala Sagalee / Exercise on sounds",
//     "Shaakala Jechootaa / Exercise on words",
//     "Shaakala Himaa / Exercise on sentence",
//     "Shaakala Keeyyataa / Exercise on paragraph"
//   ];
//   final List theProgress = [80, 70, 50, 10, 25];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: theExercise.length,
//       scrollDirection: Axis.vertical,
//       itemBuilder: (_, i) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         EachExercise(theCourse: theExercise[i])));
//           },
//           child: Card(
//             margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//             color: Colors.lightBlue.shade600,
//             shadowColor: Colors.black38,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
//               child: Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       theExercise[i],
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20),
//                     ),
//                     Icon(
//                       Icons.read_more,
//                       size: 40,
//                       color: Colors.white70,
//                     ),
//                     SliderTheme(
//                       data: SliderTheme.of(context).copyWith(
//                         activeTrackColor: Colors.blue[900],
//                         inactiveTrackColor: Colors.blue[100],
//                         trackShape: const RoundedRectSliderTrackShape(),
//                         trackHeight: 8.0,
//                         thumbShape: const RoundSliderThumbShape(
//                             enabledThumbRadius: 12.0),
//                         thumbColor: Colors.blue[900],
//                         overlayColor: Colors.blue[900],
//                         overlayShape:
//                             const RoundSliderOverlayShape(overlayRadius: 28.0),
//                         tickMarkShape: const RoundSliderTickMarkShape(),
//                         activeTickMarkColor: Colors.blue[900],
//                         inactiveTickMarkColor: Colors.blue[100],
//                         valueIndicatorShape: PaddleSliderValueIndicatorShape(),
//                         valueIndicatorColor: Colors.blue[900],
//                         valueIndicatorTextStyle: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       child: Slider(
//                         value: theProgress[i].toDouble(),
//                         min: 0.0,
//                         max: 100.0,
//                         divisions: 10,
//                         label: theProgress[i].toString(),
//                         onChanged: (value) {
//                           setState(
//                             () {
//                               _duelCommandment = value;
//                             },
//                           );
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
