import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class navigation_drawer extends StatelessWidget {
  const navigation_drawer({super.key});
  Future<Map<String, String?>> getUserInfo() async {
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

      // Récupérez l'e-mail à partir des données de l'utilisateur
      String? email = (userSnapshot.data() as Map<String, dynamic>)['email'];

      // Récupérez l'image de profil à partir des données de l'utilisateur
      String? img = (userSnapshot.data() as Map<String, dynamic>)['imgprofile'];

      String? pseudo = (userSnapshot.data() as Map<String, dynamic>)['pseudo'];

      // Retournez un map contenant l'e-mail et l'image de profil
      return {'email': email, 'img': img, 'pseudo': pseudo};
    } else {
      // L'utilisateur n'est pas authentifié
      return {'email': null, 'img': null, 'pseudo': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, String?>>(
            future: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String? email = snapshot.data?['email'];
                String? profilePictureUrl = snapshot.data?['img'];
                String? pseudo = snapshot.data?['pseudo'];

                return UserAccountsDrawerHeader(
                  accountName: Text(pseudo ?? ''),
                  accountEmail: Text(email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : null, // Load the image if URL is available
                    child: profilePictureUrl == null
                        ? Icon(Icons.person)
                        : null, // Show default icon if URL is not available
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://proactivecreative.com/wp-content/uploads/2022/04/shades-of-blue-featured.jpg')),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: Text(
              Config.Localization["Home"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 9, 51, 110),
            ), // Add leading icon for Home
            onTap: () {
              Navigator.of(context).pushReplacementNamed('HomeScreen');
            },
          ),
          ListTile(
            title: Text(
              Config.Localization["History"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.book,
              color: Color.fromARGB(255, 9, 51, 110),
            ), // Add leading icon for History
            onTap: () {
              Navigator.of(context).pushReplacementNamed('HistoriqueScreen');
            },
          ),
          ListTile(
            title: const Text(
              'Video',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.video_file,
              color: Color.fromARGB(255, 9, 51, 110),
            ), // Add leading icon for Quizz
            onTap: () {
              Navigator.of(context).pushReplacementNamed('VideoScreen');
            },
          ),
          ListTile(
            title: const Text(
              'Quizz',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.quiz,
              color: Color.fromARGB(255, 9, 51, 110),
            ), // Add leading icon for Quizz
            onTap: () {
              Navigator.of(context).pushReplacementNamed('QuizzScreen');
            },
          ),
          
          ListTile(
            title: Text(
              Config.Localization["settings"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 9, 51, 110),
            ), // Add leading icon for Settings
            onTap: () {
              Navigator.of(context).pushReplacementNamed('SettingScreen');
            },
          ),
          ListTile(
            title: Text(
              Config.Localization["Rate"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.star_rate,
              color: Color.fromARGB(255, 225, 225, 35),
            ), // Add leading icon for Rate
            onTap: () {
              Navigator.of(context).pushReplacementNamed('RateScreen');
            },
          ),
          ListTile(
            title: Text(
              Config.Localization["cmt"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.comment,
              color: Color.fromARGB(255, 9, 51, 110),
            ), // Add leading icon for Rate
            onTap: () {
              Navigator.of(context).pushReplacementNamed('VoiceCommentScreen');
            },
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: MaterialButton(
              onPressed: () async {
                Provider.of<ThemeProvider>(context, listen: false).resetTheme();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('LoginScreen');
              },
              child: Text('Sign out'),
              elevation: 15,
              color: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
