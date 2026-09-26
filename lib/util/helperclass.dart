import 'dart:convert';
import 'dart:io';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
class Helper{
  static Future<String> Downloadfile(String strURL,String filename)async{

    var Direction = await getTemporaryDirectory();
    final filepath='${Direction.path}/$filename';
    final  responseData = await http.get(Uri.parse(strURL));
    File file = await File(filepath);
    await file.writeAsBytes(responseData.bodyBytes);
    return filepath;
  }
  String utf8convert(String text) {
    var encoded = utf8.encode(text);
    List<int> intList = List<int>.from(encoded);
    String result = Utf8Decoder().convert(List<int>.from(intList));
    return  result ;
  }


  Future<String?>  getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  CutName(String name){
    if(name.length >23 ){
   return name.substring(0, 23)+'...';
    }else{
      return name;
    }

  }

  CutName2({required String name}){
    if(name.length >15 ){
      return name.substring(0, 15)+'...';
    }else{
      return name;
    }

  }
  CutName3({required String name}){
    if(name.length >11 ){
      return name.substring(0, 11)+'...';
    }else{
      return name;
    }

  }
  CutName4({required String name}){
    if(name.length >7 ){
      return name.substring(0, 7)+'...';
    }else{
      return name;
    }

  }
  CutName5({required String name}){
    if(name.length >9){
      return name.substring(0, 9)+'...';
    }else{
      return name;
    }

  }
  CutName7({required String name}){
    if(name.length >5 ){
      return name.substring(0, 5)+'..';
    }else{
      return name;
    }

  }
  void checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;

  }
  ids()async{
    deviceId = await getId();
  }
PlayMusic({path})async{
  final player = AudioPlayer();
  await player.setAsset(path,preload: false);
  await player.play();
}
PlaylinkMusic({path})async{

  final player = AudioPlayer();                   // Create a player
  await player.setUrl(           // Load a URL
      path,preload: false);                 // Schemes: (https: | file: | asset: )
  await player.play();
}
  RequestPermissions()async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();


  }
  Future<void> launchInBrowser(url) async {

    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      Dialogs().showtoast('This Account Invalid');
    }
  }

  Getage({year,day,month}){
    String diff = ((((DateTime(int.parse(year??''), int.parse(month??''),int.parse(day??'')).difference(DateTime.now())).inDays)/365).round()+1).abs().toString();
    return diff;
  }
  getTimeago({time}){

    return timeago.format(DateTime.tryParse(time??'')as DateTime).toString();
  }

  getdayago({String ?time}){
    final createdAt = DateTime.parse(time??'');

    // حساب فرق الأيام.
    final now = DateTime.now().toUtc();
    final difference = now.difference(createdAt).inDays;
    if(difference==0){
      return ' التعارف 1 الأيام ';
    }
    return ' التعارف $difference الأيام ';

  }
  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
}
String CheckQuantaty({quantity}){
  switch (quantity) {
    case '1':
      return 'assets/image/1x.png';

    case '5':
      return 'assets/image/5x.png';
      break;
    case '10':
      return 'assets/image/10x.png';
      break;
    case '20':
      return 'assets/image/20x.png';
      break;
    case '30':
      return 'assets/image/30x.png';
      break;
    default: {
      return  'assets/image/1x.png';
    }

    break;


  }
}

CheckLevel({required int Karisma}){
  if(50000>=Karisma){
    return 1;
     }
    else if(Karisma>50000&&100000>=Karisma){
      return 2;
    } else if(Karisma>100000&&300000>=Karisma){
    return 3;
  } else if(Karisma>300000&&500000>=Karisma){
    return 4;
  } else if(Karisma>500000&&700000>=Karisma){
    return 5;
  } else if(Karisma>700000&&900000>=Karisma){
    return 6;
  } else if(Karisma>900000&&1300000>=Karisma){
    return 7;
  } else if(Karisma>1300000&&1500000>=Karisma){
    return 8;
  } else if(Karisma>1500000&&1700000>=Karisma){
    return 9;
  }else if(Karisma>1700000&&2000000>=Karisma){
    return 10;
  } else if(Karisma>2000000&&2500000>=Karisma){
    return 11;
  }   else if(Karisma>2500000&&3500000>=Karisma){
    return 12;
  } else if(Karisma>3500000&&4000000>=Karisma){
    return 13;
  }else if(Karisma>4000000&&4500000>=Karisma){
    return 14;
  } else if(Karisma>4500000&&5500000>=Karisma){
    return 15;
  } else if(Karisma>5500000&&6000000>=Karisma){
    return 16;
  }else if(Karisma>6000000&&6500000>=Karisma){
    return 17;
  } else if(Karisma>6500000&&7000000>=Karisma){
    return 18;
  } else if(Karisma>7000000&&7500000>=Karisma){
    return 19;
  } else if(Karisma>7500000&&8000000>=Karisma){
    return 20;
  }else if(Karisma>8000000&&9000000>=Karisma){
    return 21;
  } else if(Karisma>9000000&&11000000>=Karisma){
    return 22;
  }else if(Karisma>11000000&&13000000>=Karisma){
    return 23;
  } else if(Karisma>13000000&&17000000>=Karisma){
    return 24;
  } else if(Karisma>17000000&&23000000>=Karisma){
    return 25;
  } else if(Karisma>23000000&&29000000>=Karisma){
    return 26;
  }else if(Karisma>29000000&&37000000>=Karisma){
    return 27;
  }else if(Karisma>37000000&&45000000>=Karisma){
    return 28;
  } else if(Karisma>45000000&&54000000>=Karisma){
    return 29;
  } else if(Karisma>54000000&&64000000>=Karisma){
    return 30;
  }else if(Karisma>64000000&&74000000>=Karisma){
    return 31;
  } else if(Karisma>74000000&&84000000>=Karisma){
    return 32;
  } else if(Karisma>84000000&&104000000>=Karisma){
    return 33;
  } else if(Karisma>104000000&&114000000>=Karisma){
    return 34;
  }else if(Karisma>114000000&&124000000>=Karisma){
    return 35;
  } else if(Karisma>124000000&&134000000>=Karisma){
    return 36;
  } else if(Karisma>134000000&&144000000>=Karisma){
    return 37;
  }else if(Karisma>144000000&&154000000>=Karisma){
    return 38;
  } else if(Karisma>154000000&&164000000>=Karisma){
    return 39;
  } else if(Karisma>164000000&&174000000>=Karisma){
    return 40;
  }else if(Karisma>174000000&&184000000>=Karisma){
    return 41;
  } else if(Karisma>184000000&&194000000>=Karisma){
    return 42;
  } else if(Karisma>194000000&&204000000>=Karisma){
    return 43;
  } else if(Karisma>204000000&&214000000>=Karisma){
    return 44;
  }else if(Karisma>214000000&&224000000>=Karisma){
    return 45;
  } else if(Karisma>224000000&&234000000>=Karisma){
    return 46;
  }else if(Karisma>234000000&&244000000>=Karisma){
    return 47;
  } else if(Karisma>244000000&&254000000>=Karisma){
    return 48;
  } else if(Karisma>254000000&&264000000>=Karisma){
    return 49;
  } else if(Karisma>264000000&&274000000>=Karisma){
    return 50;
  }else{
    return 51;
    }
}
bool validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return false;    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true ;
  }

}
void navigateTo({required BuildContext context, required Widget screen}) {
  Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
            screen,
        transitionDuration: Duration(
          milliseconds: 300,
        ),
        transitionsBuilder: (context, animation,
            secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));
}
void navigatereplacementTo(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
        screen,
        transitionDuration: Duration(
          milliseconds: 300,
        ),
        transitionsBuilder: (context, animation,
            secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));
}
void ShowGlopalLoading(){
  SmartDialog.showLoading(
    builder: (context) => Container(
      decoration: BoxDecoration(color: Colors.white,  shape: BoxShape.circle,),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: CircularProgressIndicator(color: MainColor),
      ),
    ),
  );
}
void DismissGlopalLoading(){
  SmartDialog.dismiss();
}
List UserLevel=[
  {'Level':'1','karisma':0,'image':'assets/image/rl1.png'},
  {'Level':'2','karisma':10000,'image':'assets/image/rl1.png'},
  {'Level':'3','karisma':15000,'image':'assets/image/rl1.png'},
  {'Level':'4','karisma':20000,'image':'assets/image/rl1.png'},
  {'Level':'5','karisma':25000,'image':'assets/image/rl1.png'},
  {'Level':'6','karisma':30000,'image':'assets/image/rl1.png'},
  {'Level':'7','karisma':35000,'image':'assets/image/rl1.png'},
  {'Level':'8','karisma':40000,'image':'assets/image/rl1.png'},
  {'Level':'9','karisma':45000,'image':'assets/image/rl1.png'},
  {'Level':'10','karisma':50000,'image':'assets/image/rl1.png'},
  {'Level':'11','karisma':65000,'image':'assets/image/rl2.png'},
  {'Level':'12','karisma':75000,'image':'assets/image/rl2.png'},
  {'Level':'13','karisma':85000,'image':'assets/image/rl2.png'},
  {'Level':'14','karisma':95000,'image':'assets/image/rl2.png'},
  {'Level':'15','karisma':110000,'image':'assets/image/rl2.png'},
  {'Level':'16','karisma':120000,'image':'assets/image/rl2.png'},
  {'Level':'17','karisma':130000,'image':'assets/image/rl2.png'},
  {'Level':'18','karisma':140000,'image':'assets/image/rl2.png'},
  {'Level':'19','karisma':150000,'image':'assets/image/rl2.png'},
  {'Level':'20','karisma':210000,'image':'assets/image/rl2.png'},
  {'Level':'21','karisma':290000,'image':'assets/image/rl3.png'},
  {'Level':'22','karisma':390000,'image':'assets/image/rl3.png'},
  {'Level':'23','karisma':490000,'image':'assets/image/rl3.png'},
  {'Level':'24','karisma':560000,'image':'assets/image/rl3.png'},
  {'Level':'25','karisma':630000,'image':'assets/image/rl3.png'},
  {'Level':'26','karisma':790000,'image':'assets/image/rl3.png'},
  {'Level':'27','karisma':900000,'image':'assets/image/rl3.png'},
  {'Level':'28','karisma':1150000,'image':'assets/image/rl3.png'},
  {'Level':'29','karisma':1400000,'image':'assets/image/rl3.png'},
  {'Level':'30','karisma':1690000,'image':'assets/image/rl3.png'},
  {'Level':'31','karisma':2200000,'image':'assets/image/rl4.png'},
  {'Level':'32','karisma':3000000,'image':'assets/image/rl4.png'},
  {'Level':'33','karisma':3900000,'image':'assets/image/rl4.png'},
  {'Level':'34','karisma':4800000,'image':'assets/image/rl4.png'},
  {'Level':'35','karisma':6300000,'image':'assets/image/rl4.png'},
  {'Level':'36','karisma':6900000,'image':'assets/image/rl4.png'},
  {'Level':'37','karisma':7500000,'image':'assets/image/rl4.png'},
  {'Level':'38','karisma':8100000,'image':'assets/image/rl4.png'},
  {'Level':'39','karisma':9000000,'image':'assets/image/rl4.png'},
  {'Level':'40','karisma':9300000,'image':'assets/image/rl4.png'},
  {'Level':'41','karisma':9600000,'image':'assets/image/rl5.png'},
  {'Level':'42','karisma':10000000,'image':'assets/image/rl5.png'},
  {'Level':'43','karisma':10300000,'image':'assets/image/rl5.png'},
  {'Level':'44','karisma':10500000,'image':'assets/image/rl5.png'},
  {'Level':'45','karisma':10700000,'image':'assets/image/rl5.png'},
  {'Level':'46','karisma':10900000,'image':'assets/image/rl5.png'},
  {'Level':'47','karisma':11000000,'image':'assets/image/rl5.png'},
  {'Level':'48','karisma':11100000,'image':'assets/image/rl5.png'},
  {'Level':'49','karisma':11300000,'image':'assets/image/rl5.png'},
  {'Level':'50','karisma':11700000,'image':'assets/image/rl5.png'},
  {'Level':'51','karisma':13300000,'image':'assets/image/rl6.png'},
  {'Level':'52','karisma':15600000,'image':'assets/image/rl6.png'},
  {'Level':'53','karisma':18000000,'image':'assets/image/rl6.png'},
  {'Level':'54','karisma':19500000,'image':'assets/image/rl6.png'},
  {'Level':'55','karisma':20000000,'image':'assets/image/rl6.png'},
  {'Level':'56','karisma':24000000,'image':'assets/image/rl6.png'},
  {'Level':'57','karisma':28000000,'image':'assets/image/rl6.png'},
  {'Level':'58','karisma':32000000,'image':'assets/image/rl6.png'},
  {'Level':'59','karisma':36000000,'image':'assets/image/rl6.png'},
  {'Level':'60','karisma':40000000,'image':'assets/image/rl6.png'},
  {'Level':'61','karisma':45000000,'image':'assets/image/rl7.png'},
  {'Level':'62','karisma':50000000,'image':'assets/image/rl7.png'},
  {'Level':'63','karisma':55000000,'image':'assets/image/rl7.png'},
  {'Level':'64','karisma':65000000,'image':'assets/image/rl7.png'},
  {'Level':'65','karisma':75000000,'image':'assets/image/rl7.png'},
  {'Level':'66','karisma':85000000,'image':'assets/image/rl7.png'},
  {'Level':'67','karisma':95000000,'image':'assets/image/rl7.png'},
  {'Level':'68','karisma':100000000,'image':'assets/image/rl7.png'},
  {'Level':'69','karisma':110000000,'image':'assets/image/rl7.png'},
  {'Level':'70','karisma':120000000,'image':'assets/image/rl7.png'},
  {'Level':'71','karisma':130000000,'image':'assets/image/rl8.png'},
  {'Level':'72','karisma':140000000,'image':'assets/image/rl8.png'},
  {'Level':'73','karisma':150000000,'image':'assets/image/rl8.png'},
  {'Level':'74','karisma':160000000,'image':'assets/image/rl8.png'},
  {'Level':'75','karisma':170000000,'image':'assets/image/rl8.png'},
  {'Level':'76','karisma':180000000,'image':'assets/image/rl8.png'},
  {'Level':'77','karisma':190000000,'image':'assets/image/rl8.png'},
  {'Level':'78','karisma':200000000,'image':'assets/image/rl8.png'},
  {'Level':'79','karisma':220000000,'image':'assets/image/rl8.png'},
  {'Level':'80','karisma':240000000,'image':'assets/image/rl8.png'},
  {'Level':'81','karisma':260000000,'image':'assets/image/rl9.png'},
  {'Level':'82','karisma':280000000,'image':'assets/image/rl9.png'},
  {'Level':'83','karisma':300000000,'image':'assets/image/rl9.png'},
  {'Level':'84','karisma':330000000,'image':'assets/image/rl9.png'},
  {'Level':'85','karisma':360000000,'image':'assets/image/rl9.png'},
  {'Level':'86','karisma':390000000,'image':'assets/image/rl9.png'},
  {'Level':'87','karisma':420000000,'image':'assets/image/rl9.png'},
  {'Level':'88','karisma':450000000,'image':'assets/image/rl9.png'},
  {'Level':'89','karisma':480000000,'image':'assets/image/rl9.png'},
  {'Level':'90','karisma':510000000,'image':'assets/image/rl9.png'},
  {'Level':'91','karisma':540000000,'image':'assets/image/rl10.png'},
  {'Level':'92','karisma':570000000,'image':'assets/image/rl10.png'},
  {'Level':'93','karisma':610000000,'image':'assets/image/rl10.png'},
  {'Level':'94','karisma':650000000,'image':'assets/image/rl10.png'},
  {'Level':'95','karisma':700000000,'image':'assets/image/rl10.png'},
  {'Level':'96','karisma':800000000,'image':'assets/image/rl10.png'},
  {'Level':'97','karisma':900000000,'image':'assets/image/rl10.png'},
  {'Level':'98','karisma':1000000000,'image':'assets/image/rl10.png'},
  {'Level':'99','karisma':1100000000,'image':'assets/image/rl10.png'},
  {'Level':'100','karisma':1300000000,'image':'assets/image/rl10.png'},
  {'Level':'101','karisma':1600000000,'image':'assets/image/rl11.png'},
  {'Level':'102','karisma':1900000000,'image':'assets/image/rl11.png'},
  {'Level':'103','karisma':2100000000,'image':'assets/image/rl11.png'},
  {'Level':'104','karisma':2400000000,'image':'assets/image/rl11.png'},
  {'Level':'105','karisma':2700000000,'image':'assets/image/rl11.png'},
  {'Level':'106','karisma':3000000000,'image':'assets/image/rl11.png'},
  {'Level':'107','karisma':3000000000,'image':'assets/image/rl11.png'},
  {'Level':'108','karisma':4000000000,'image':'assets/image/rl11.png'},
  {'Level':'109','karisma':5000000000,'image':'assets/image/rl11.png'},
  {'Level':'110','karisma':6000000000,'image':'assets/image/rl11.png'},
  {'Level':'111','karisma':7000000000,'image':'assets/image/rl11.png'},
];

Future<String?> getIPAddress() async {
  final interfaces = await NetworkInterface.list();
  for (final interface in interfaces) {
    final addresses = interface.addresses;
    for (final address in addresses) {
      if (address.type == InternetAddressType.IPv4) {
        if (!address.isLinkLocal) {
          UserIP=address.address;
         // Dialogs().showtoast(UserIP);
          return address.address;

        }
      }
    }
  }
  return null;
}


Future  getPublicIP() async {

  final response = await http.get(Uri.parse('https://api.ipify.org'));

    await http.get(Uri.parse(AppConstants.BASE_URL+'api/SetPublicIp/$UserId/${response.body.toString()}'));



}

