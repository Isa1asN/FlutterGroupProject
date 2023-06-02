import 'package:flutter/material.dart';

class Course extends StatefulWidget {
  final List theContent;
  final List theCourses;

  const Course({Key? key, required this.theCourses, required this.theContent});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 231, 233, 239),
        child: Center(
          child: widget.theCourses[widget.theContent[0]][widget.theContent[1]],
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 50), // Add horizontal padding
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Align buttons at the ends
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.theContent[1] = widget.theContent[1] == 0
                          ? widget.theContent[1]
                          : widget.theContent[1] - 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color.fromARGB(255, 26, 28, 30),
                    elevation: 1,
                    fixedSize: const Size(100, 40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "prev",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.theContent[1] = widget.theContent[1] ==
                              widget.theCourses[widget.theContent[0]].length - 1
                          ? widget.theContent[1]
                          : widget.theContent[1] + 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color.fromARGB(255, 26, 28, 30),
                    fixedSize: const Size(100, 40),
                    elevation: 1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "next",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
