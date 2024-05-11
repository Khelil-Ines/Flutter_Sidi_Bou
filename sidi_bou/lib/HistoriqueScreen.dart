import 'package:flutter/material.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/navigation_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({Key? key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigation_drawer(),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            Config.Localization["learn"],
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
              image: NetworkImage(
                  "https://www.boky.tn/wp-content/uploads/2023/07/The-beautiful-towns-of-Northern-Tunisia-Bizerte-and-Sidi-Bou-Said.png"), // Replace with your image URL
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 100,
                width: 200,
                child: Image.asset('images/mascotte.png'),
              ),
              Container(
                decoration: BoxDecoration(
                  //color: Colors.white.withOpacity(0.8),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    Config.Localization["description"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerif(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Text(
                  Config.Localization["btnPlay"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('VideoScreen');
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue[900],
                  ),
                  child: Text(
                    Config.Localization["videos"],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
