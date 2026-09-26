

import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


String ? Lang='En';
checklanguage()async{
  DisableBatteryOptimization.showDisableAllOptimizationsSettings(
      "Enable Auto Start",
      "Follow the steps and enable the auto start of this app",
      "Your device has additional battery optimization",
      "Follow the steps and disable the optimizations to allow smooth functioning of this app");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Lang= prefs.getString('Lang');
  print("language====================================$Lang");
  print('Lang is $Lang');

}
class languageViewmodel extends ChangeNotifier {


  void Arbic() async{

    Lang = 'Ar';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Lang','Ar');
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void English() async{

    Lang = 'En';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Lang','En');
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }



}