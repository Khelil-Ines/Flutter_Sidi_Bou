import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizzPlace extends StatefulWidget {
  const QuizzPlace({Key? key}) : super(key: key);

  @override
  State<QuizzPlace> createState() => _QuizzPlaceState();
}

class _QuizzPlaceState extends State<QuizzPlace> {
  List<Map<String, dynamic>> questions = [
    {
      'questionText': 'What is this place called?',
      'imagePath': 'images/mosque.jpg',
      'answers': ['Mosque', 'Restaurant', 'Musem'],
      'correctAnswerIndex': 0,
    },
    {
      'questionText': 'What famous port is this ?',
      'answers': ['Sidi Bou Said Port', 'Bizerte Port', 'Goulette Port'],
      'imagePath': 'images/port.jpg',
      'correctAnswerIndex': 0,
    },
  ];
  int questionIndex = 0;
  int score = 0;

  late BuildContext
      _scaffoldContext; // Déclarez une variable pour stocker le contexte

  void updateScore() async {
    // Vérifiez si l'utilisateur est authentifié
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Récupérez l'ID de l'utilisateur connecté
      String userId = user.uid;

      // Récupérez les données de l'utilisateur à partir de Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'placescore': score});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 10.0).copyWith(bottom: 40),
          child: Builder(
            builder: (BuildContext scaffoldContext) {
              _scaffoldContext = scaffoldContext; // Stockez le contexte
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex:
                        5, // Give more weight to the question and answer section
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Text(
                            questions[questionIndex]['questionText'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 40.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 40),
                          Expanded(
                            flex: 1, // Give less weight to the image section
                            child: SizedBox(
                              height: 200, // Adjust the height as needed
                              child: Image.asset(
                                questions[questionIndex]['imagePath'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  ..._buildAnswerButtons(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnswerButtons() {
    return questions[questionIndex]['answers']
        .asMap()
        .entries
        .map<Widget>((entry) {
      int idx = entry.key;
      String answer = entry.value;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 25.0),
              iconColor: Colors.white,
            ),
            onPressed: () => checkAnswer(idx),
            child: Text(answer),
          ),
        ),
      );
    }).toList();
  }

  void checkAnswer(int selectedIndex) {
    if (selectedIndex == questions[questionIndex]['correctAnswerIndex']) {
      score++;
      ScaffoldMessenger.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      ScaffoldMessenger.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text('Wrong!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }

    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
      });
    } else {
      // Navigate to results page or show score
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Finished!'),
          content: Text('You scored $score out of ${questions.length}'),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                setState(() {
                  questionIndex = 0;
                  score = 0;
                });
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text('Quit'),
              onPressed: () {
                updateScore();

                Navigator.of(context).pushReplacementNamed('QuizzScreen');
              },
            ),
          ],
        ),
      );
    }
  }
}
