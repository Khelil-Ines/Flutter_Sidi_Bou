import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sidi_bou/HomeScreen.dart';
import 'package:sidi_bou/LoginScreen.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/settings/settings_page.dart';
import 'package:sidi_bou/widgets/edit_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetAccount extends StatefulWidget {
  const SetAccount({Key? key}) : super(key: key);
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
  State<SetAccount> createState() => _SetAccountState();
}

class _SetAccountState extends State<SetAccount> {
  String imageURL = '';

  var currentPass = TextEditingController();
  var newPass = TextEditingController();

  var emailController = TextEditingController();
  var pseudoController = TextEditingController();

  Future<void> pickImage() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Aucun utilisateur connecté.'),
      ));
      return;
    }

    // Step 1: Pick the image
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(result.files.single.path!);
      String userId = user.uid;

      // Step 2: Upload the image to Firebase Storage using the user ID as part of the image name
      Reference imageRef = FirebaseStorage.instance.ref('${userId}.jpg');
      await imageRef.putFile(file);

      // Step 3: Get the download URL of the uploaded image
      String imageURL = await imageRef.getDownloadURL();

      // Step 4: Update the Firestore document with the new image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'imgprofile': imageURL});

      // Update UI and show a success message
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image modifiée avec succès !'),
      ));
    } else {
      // Handle the case where the user cancels the image selection
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sélection d\'image annulée'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Config.Localization["setAccount"]),
        leading: IconButton(
          icon: const Icon(Ionicons.chevron_back_outline),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Config.Localization["account"],
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: Config.Localization["photo"],
                widget: FutureBuilder<Map<String, String?>>(
                  future: widget.getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String? profilePictureUrl = snapshot.data?['img'];

                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: profilePictureUrl != null
                                ? NetworkImage(profilePictureUrl)
                                : null,
                            child: profilePictureUrl == null
                                ? Icon(Icons.person)
                                : null,
                            radius: 50,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: pickImage,
                                child: Text(
                                  Config.Localization["uploadImg"],
                                  style: GoogleFonts.robotoCondensed(
                                    color: Colors.blue[500],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              EditItem(
                widget: FutureBuilder<Map<String, String?>>(
                  future: widget.getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String? userEmail = snapshot.data?['email'];

                      return Text(
                        userEmail ??
                            '', // Utilisez le courriel de l'utilisateur s'il est disponible, sinon une chaîne vide
                        style: TextStyle(
                          color: Colors.black, // Couleur du texte
                          fontStyle: FontStyle.italic, // Style du texte
                        ),
                      );
                    }
                  },
                ),
                title: "Email",
              ),
              SizedBox(height: 20),
              EditItem(
                widget: FutureBuilder<Map<String, String?>>(
                  future: widget.getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String? userPseudo = snapshot.data?['pseudo'];

                      return TextField(
                        controller: pseudoController,
                        decoration: InputDecoration(
                          hintText: userPseudo ?? '',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }
                  },
                ),
                title: "Pseudo",
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (pseudoController.value.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(pseudoController.text);
                          // Mettez à jour l'email' dans Firestore
                          String userId =
                              FirebaseAuth.instance.currentUser!.uid;
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({'pseudo': pseudoController.text});
                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()));
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fixedSize: const Size(68, 58),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Ionicons.checkmark),
                  ),
                ),
              ),
              //SizedBox(height: 40),
              Text(
                Config.Localization["pwd"],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: currentPass,
                  decoration:
                      InputDecoration(hintText: Config.Localization["current"]),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: newPass,
                  decoration:
                      InputDecoration(hintText: Config.Localization["new"]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Ensure both fields are filled
                    if (currentPass.text.isNotEmpty &&
                        newPass.text.isNotEmpty) {
                      try {
                        // Re-authenticate the user with the current password
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: FirebaseAuth.instance.currentUser!.email!,
                          password: currentPass.text, // Current password input
                        );

                        // If re-authentication is successful, update the password
                        await userCredential.user!.updatePassword(newPass.text);

                        // Update the password in Firestore
                        String userId = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({'password': newPass.text});

                        // Log out the user after changing the password
                        await FirebaseAuth.instance.signOut();

                        // Redirect to the login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );

                        // Display success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password changed successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        // Handle authentication errors like incorrect password
                        String errorMessage;
                        if (e.code == 'wrong-password') {
                          errorMessage = 'Incorrect current password entered.';
                        } else {
                          errorMessage = 'Authentication error: ${e.message}';
                        }

                        // Display error message using a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      } catch (e) {
                        // General catch for other errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Password entered do not match current one!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Handle missing input fields
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill out both fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(Config.Localization["update"]),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  // Delete the current user
                  bool success = await deleteCurrentUser();

                  // If deletion was successful, navigate to the login screen
                  if (success) {
                    Navigator.of(context).pushReplacementNamed('LoginScreen');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User deleted successfully !"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Handle deletion errors, e.g., show a message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Error occurred while deleting the account"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(60, 25, 60, 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.red[900],
                    ),
                    child: Text(
                      "Delete Account", // Adjust the label according to your needs
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> deleteCurrentUser() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    try {
      // Delete the user's document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .delete();

      // Delete the user from Firebase Authentication
      await currentUser.delete();

      print("User account and data successfully deleted.");
      return true; // Success
    } on FirebaseAuthException catch (e) {
      print("Error deleting user: ${e.message}");
      if (e.code == 'requires-recent-login') {
        print(
            "The user needs to be re-authenticated before deleting their account.");
      }
    } catch (e) {
      print("An error occurred while deleting the account: $e");
    }
  } else {
    print("No user is currently logged in.");
  }

  return false; // Failure
}
