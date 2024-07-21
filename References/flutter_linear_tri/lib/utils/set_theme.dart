import 'package:shared_preferences/shared_preferences.dart';

import '../res/color.dart';

setTheme(int theme) async {
  final _prefs = await SharedPreferences.getInstance();
  switch (theme) {
    case 1:
      textBgColor = green;
      editBgColor = yellow;
      _prefs.setInt('theme', 1);
      break;
    case 2:
      textBgColor = white;
      editBgColor = yellow;
      _prefs.setInt('theme', 2);
      break;
    case 3:
      textBgColor = green;
      editBgColor = white;
      _prefs.setInt('theme', 3);
      break;
    default:
      textBgColor = green;
      editBgColor = yellow;
      _prefs.setInt('theme', 1);
  }
}
