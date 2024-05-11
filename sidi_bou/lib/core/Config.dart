import 'dart:convert';

import 'package:flutter/services.dart';

abstract class Config {
  static Map Localization = {};
  static LoadLanguage(String Lang) async {
    String Translation;
    if (Lang == 'en') {
      Translation = await rootBundle.loadString("assets/localization/en.json");
    } else {
      Translation = await rootBundle.loadString("assets/localization/fr.json");
    }
    Localization = jsonDecode(Translation);
  }
}
