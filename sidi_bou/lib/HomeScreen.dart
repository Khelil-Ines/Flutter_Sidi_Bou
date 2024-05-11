import 'package:flutter/material.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/navigation_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigation_drawer(),
      appBar: AppBar(
        title: Center(
          child: Text(
            Config.Localization["title"],
            style: GoogleFonts.robotoCondensed(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/test.jpg'),
              fit: BoxFit
                  .fill, // Adjusts the image to cover the entire container
            ),
            color: Color.fromARGB(255, 70, 103, 140),
          ),
          child: Column(
            children: [
              //SizedBox(height: 40),
              Image.asset('images/tunisia.png', height: 150),
              Container(
                padding: const EdgeInsets.all(28.0),
                child: Text(
                  Config.Localization["body"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Text(
                Config.Localization["press"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed('HistoriqueScreen');
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(60, 25, 60, 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue[900],
                  ),
                  child: Text(
                    Config.Localization["btnStart"],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80),
              Image.asset('images/mascotte.png', height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
