
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../util/Localization.dart';
import '../../../../../util/styles.dart';
import '../../../../widgets/WebViewScrean.dart';
class Termesandcondition extends StatefulWidget {

  Color colorsss;

  Termesandcondition({this.colorsss=Colors.white});

  @override
  State<Termesandcondition> createState() => _TermesandconditionState();
}

class _TermesandconditionState extends State<Termesandcondition> {
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(
            child: Text.rich( TextSpan(
                children: [
                  TextSpan(
                    text:'By continuing you agree to the',style:style5.copyWith(color: Colors.black45, fontSize:  SizeConfig.TenSize!*1.0,fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewScrean(name: getLang( context: context, key: "Terms_Service"), link: 'https://blush-clarinda-19.tiiny.site/',),));
                    },
                    text:  ' Terms Of Service ' ,style:style5.copyWith( fontSize: SizeConfig.TenSize! ,fontWeight: FontWeight.bold,   color:Colors.black),
                  ),
                  TextSpan(
                    text:  ' and ' ,style:style5.copyWith(color:Colors.black45,fontSize: SizeConfig.TenSize!*1.0,fontWeight: FontWeight.bold),
                  ),

                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewScrean(name: getLang( context: context, key: "Privacy_Policy"), link: 'https://salmon-celene-54.tiiny.site/',),));
                    },
                    text:  "Privacy Policy",style:style5.copyWith( fontSize: SizeConfig.TenSize!,fontWeight: FontWeight.bold, color:Colors.black),
                  ),


                ]),maxLines: null,textAlign: TextAlign.center,),
          ),



        ],
      ),
    );
  }
}
