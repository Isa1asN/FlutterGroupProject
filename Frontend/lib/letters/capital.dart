import 'package:flutter/material.dart';

class CapitalLetters extends StatefulWidget {
  const CapitalLetters({super.key});

  @override
  State<CapitalLetters> createState() => _CapitalLettersState();
}

class _CapitalLettersState extends State<CapitalLetters> {
  List<String> capitals = ["A", "B", "C", "D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Capital Letters'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left:12.0,right: 12.0,top:40),
          child: Column(children: [
            Expanded(
              // Wrap GridView with Expanded
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: capitals.map((letter) {
                  return Card(
                    elevation: 2,
                    color: Color.fromARGB(255, 248, 251, 253),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      letter,
                      style: const TextStyle(
                          fontSize: 34,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )),
                  );
                }).toList(),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
