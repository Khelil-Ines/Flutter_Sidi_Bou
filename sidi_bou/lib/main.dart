import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidi_bou/ForgotPass.dart';
import 'package:sidi_bou/HistoriqueScreen.dart';
import 'package:sidi_bou/QuizzScreens/QuizzHome.dart';
import 'package:sidi_bou/QuizzScreens/QuizzQuestion.dart';
import 'package:sidi_bou/QuizzScreens/QuizzPlace.dart';
import 'package:sidi_bou/QuizzScreens/QuizzMarabouts.dart';
import 'package:sidi_bou/RateScreen.dart';
//import 'package:sidi_bou/SplashScreen.dart';
import 'package:sidi_bou/VoiceCommentScreen.dart';
import 'package:sidi_bou/auth.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/firebase_options.dart';
import 'package:sidi_bou/manager/lang_cubit.dart';
import 'package:sidi_bou/settings/set_account.dart';
import 'package:sidi_bou/videoplayerpage.dart';
import './SignupScreen.dart';
import './LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import './HomeScreen.dart';
import 'package:sidi_bou/settings/settings_page.dart';
import 'package:sidi_bou/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String lang = preferences.getString("lang") ?? "en";
  await Config.LoadLanguage(lang);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ThemeProvider.instance.changeTheme(ThemeEnum.Light);
  await Future.delayed(const Duration(seconds: 1));
  //FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider.instance,
          ),
          Provider(create: (context) => LangCubit()),
        ],
        builder: (context, widget) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sidi Bou Said',
            theme: Provider.of<ThemeProvider>(context).currentThemeData,
            home: Auth(),
            routes: {
              //'/': (context) => const Auth(),
              'SettingScreen': (context) => const SettingsPage(),
              'HomeScreen': (context) => const HomeScreen(),
              'SignUpScreen': (context) => const SignupScreen(),
              'LoginScreen': (context) => const LoginScreen(),
              'RateScreen': (context) => const RateScreen(),
              'VoiceCommentScreen': (context) => const VoiceCommentScreen(),
              'HistoriqueScreen': (context) => const HistoriqueScreen(),
              'QuizzScreen': (context) => const QuizzHome(),
              'VideoScreen': (context) => const VideoPlayerPage(),
              'QuizzQuestion': (context) => const QuizzQuestion(),
              'QuizzPlace': (context) => const QuizzPlace(),
              'QuizzMarabouts': (context) => const QuizzMarabouts(),
              'ForgotPass': (context) => const ForgotPass(),
              'Setaccount': (context) => const SetAccount(),
            },
          );
        });
  }
}
