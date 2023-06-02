import 'package:flutter/material.dart';

class SmallLetters extends StatefulWidget {
  const SmallLetters({super.key});

  @override
  State<SmallLetters> createState() => _SmallLettersState();
}

class _SmallLettersState extends State<SmallLetters> {
  List<String> smalls = ["a", "b", "c", "d", "e", "f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Small Letters'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left:12.0,right: 12.0, top: 40.0),
          child: Column(children: [
      
            Expanded(
              // Wrap GridView with Expanded
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: smalls.map((letter) {
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
