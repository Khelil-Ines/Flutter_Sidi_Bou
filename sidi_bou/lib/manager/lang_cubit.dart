import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidi_bou/core/Config.dart';

class LangState {}

class LangInitial extends LangState {}

class LangLoaded extends LangState {}

class LangCubit extends Cubit<LangState> {
  LangCubit() : super(LangInitial());
  void ChangeLang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String lang = pref.getString("lang") ?? "en";

    if (lang == 'en') {
      pref.setString("lang", "fr");
      Config.LoadLanguage("fr");
    } else {
      pref.setString("lang", "en");
      Config.LoadLanguage("en");
    }
    emit(LangLoaded());
  }
}
