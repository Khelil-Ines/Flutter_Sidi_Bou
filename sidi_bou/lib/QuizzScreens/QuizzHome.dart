import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/navigation_drawer.dart';

class QuizzHome extends StatefulWidget {
  const QuizzHome({super.key});

  @override
  State<QuizzHome> createState() => _QuizzHomeState();
}

class _QuizzHomeState extends State<QuizzHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigation_drawer(),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 80.0),
          child: Text(
            'Quizz 🎮 ⁉️',
            style: GoogleFonts.robotoCondensed(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              image: DecorationImage(
                image: AssetImage('images/quizz.png'),
              ),
            ),
          ),
          SizedBox(height: 60),
          Center(
            child: Text(
              "Top Quizz Categories",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Container(
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('QuizzMarabouts'),
                        child: Column(
                          children: [
                            Text(
                              '🧔🏻',
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Marabouts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 60),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('QuizzPlace'),
                        child: Column(
                          children: [
                            Text(
                              '📌',
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Config.Localization["places"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 60),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('QuizzQuestion'),
                        child: Column(
                          children: [
                            Text(
                              '🍽️',
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Config.Localization["Quizz"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
