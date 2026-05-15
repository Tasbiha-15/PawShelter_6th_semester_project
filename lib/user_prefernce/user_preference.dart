

import 'package:shared_preferences/shared_preferences.dart';

class UserPreference
{
   Future<bool> isFirstLogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLogin') ?? true;

  }

   Future<void> setFirstLoginDone() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLogin', false);

  }

}
