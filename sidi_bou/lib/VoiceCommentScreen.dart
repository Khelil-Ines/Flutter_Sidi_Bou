import 'package:flutter/material.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoiceCommentScreen extends StatefulWidget {
  const VoiceCommentScreen({Key? key});

  @override
  State<VoiceCommentScreen> createState() => _VoiceCommentScreenState();
}

class _VoiceCommentScreenState extends State<VoiceCommentScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  String _submissionMessage = '';

  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
      _commentController.text = _wordsSpoken;
    });
  }

  void _submitComment() async {
    String comment = _commentController.text;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Get the existing comments for the user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Check if the userData is not null and contains the 'comments' key
      if (userData != null && userData.containsKey('comments')) {
        List<dynamic> existingComments = userData['comments'];

        // Check if the comment already exists in the list
        if (existingComments.contains(comment)) {
          setState(() {
            _submissionMessage = 'Comment already exists ❌';
          });
          print('Comment already exists: $comment');
          return;
        }
      } else {
        setState(() {
          _submissionMessage = 'Error: Comments data not found for the user ❌';
        });
        print('Error: Comments data not found for the user');
        return;
      }

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'comments': FieldValue.arrayUnion([comment])
        });
        setState(() {
          _submissionMessage = 'Comment submitted successfully ✅';
        });
        print('Comment submitted successfully: $comment');
      } catch (e) {
        setState(() {
          _submissionMessage = 'Error submitting comment: $e ❌';
        });
        print('Error submitting comment: $e');
      }
    } else {
      setState(() {
        _submissionMessage = 'Error submitting comment: User not logged in ❌';
      });
      print('Error submitting comment: User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigation_drawer(),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 60.0),
          child: Text(
            Config.Localization["comment"],
            style: GoogleFonts.robotoCondensed(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color(0xFF1E88E5),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? Config.Localization["comment"]
                    : _speechEnabled
                        ? Config.Localization["tapMic"]
                        : Config.Localization["notAvailable"],
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: Config.Localization["yourCmt"],
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
            ),
            Text(
              _submissionMessage,
              style: TextStyle(
                color: _submissionMessage.startsWith('Error')
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
                child: Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _submitComment,
                child: Text(Config.Localization["btnRate"],
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  elevation: 5.0,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
