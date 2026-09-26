import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_calling_code_picker_plus/country_calling_code_picker_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';

import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';

class CompleteSignUpID extends StatefulWidget {
  const CompleteSignUpID({Key? key}) : super(key: key);

  @override
  State<CompleteSignUpID> createState() => _CompleteSignUpIDState();
}

class _CompleteSignUpIDState extends State<CompleteSignUpID> {
  @override
  void _showDatePickers(ctx) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    FocusScope.of(context).unfocus();
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: SizeConfig.screenHeight! * 0.48366,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.screenHeight! * 0.392,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        minimumYear: 1950,
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: (val) {
                          setState(() {
                            user.History =
                                '${val.month}/${val.day}/${val.year}';
                            user.day = val.day;
                            user.year = val.year;
                            user.month = val.month;
                          });
                        }),
                  ),
                  CupertinoButton(
                    child: Text(
                      getLang(context: context, key: "OK"),
                      style: style1.copyWith(color: MainColor),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      FocusScope.of(context).unfocus();
                    },
                  )
                ],
              ),
            ));
  }

  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(getLang(context: context, key: "Set_Profile"),
            style: style2.copyWith(fontSize: 17)),
        backgroundColor: whitecolor,
        iconTheme: IconThemeData(
          color: Colors.black45,
        ),
        leading: InkWell(
          onTap: () async {
            if (Gmail != null && Gmail!.isNotEmpty) {
              await signOutGoogle();
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Icon(
            Icons.navigate_before_rounded,
            size: 40,
            color: Colors.black26,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Gmail != null && Gmail!.isNotEmpty) {
            await signOutGoogle();
          }

          return true;
        },
        child: Container(
          height: SizeConfig.screenHeight!,
          width: SizeConfig.screenWidth!,
          child: Padding(
            padding: WPadding15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                InkWell(
                    onTap: () => user.ComtImage(context),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: user.Comimage == null
                                      ? CachedNetworkImageProvider(
                                          user.userinfo?.image ??
                                              Images.profilephoto)
                                      : FileImage(user.Comimage)
                                          as ImageProvider)),
                        ),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: MainColor,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white,
                              size: SizeConfig.TenSize! * 1.5),
                        )
                      ],
                    )),
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.TenSize! * 4,
                        decoration: BoxDecoration(
                            color: whitecolor3,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.TenSize!, vertical: 2),
                            child: TextFormField(
                                onChanged: (value) {
                                  user.UpdateUsernameComp(name: value);
                                },
                                keyboardType: TextInputType.text,
                                initialValue: user.UsernameComp,
                                decoration: InputDecoration.collapsed(
                                  hintText: getLang(
                                      context: context, key: "Enter_Name"),
                                ),
                                style: style8.copyWith(height: 1)),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    FaIcon(FontAwesomeIcons.pen, size: 20, color: MainColor),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.TenSize! * 4,
                        decoration: BoxDecoration(
                            color: whitecolor3,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.TenSize!, vertical: 2),
                            child: TextFormField(
                                onChanged: (value) {
                                  user.UpdatePasswordComp(name: value);
                                },
                                keyboardType: TextInputType.text,
                                initialValue: user.PasswordComp,
                                decoration: InputDecoration.collapsed(
                                  hintText: getLang(
                                      context: context, key: "Set_Password"),
                                ),
                                style: style8.copyWith(height: 1)),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    FaIcon(FontAwesomeIcons.key, size: 20, color: MainColor),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                InkWell(
                  onTap: () {
                    _showDatePickers(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          height: SizeConfig.TenSize! * 4,
                          decoration: BoxDecoration(
                              color: whitecolor3,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.TenSize! * 2),
                                child: Text(
                                    user.History ??
                                        getLang(
                                            context: context,
                                            key: "What_Birthday"),
                                    style: style8.copyWith(
                                        height: 2.0,
                                        fontSize: SizeConfig.TenSize! * 1.5)),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FaIcon(FontAwesomeIcons.birthdayCake,
                          size: 20, color: MainColor),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        user.ginder = 1;

                        setState(() {});
                      },
                      child: Container(
                        width: SizeConfig.TenSize! * 12,
                        decoration: BoxDecoration(
                            color: MainColor.withOpacity(
                                user.ginder == 1 ? 1 : 0.1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.TenSize! * 3,
                              vertical: SizeConfig.TenSize!),
                          child: Center(
                            child: Text(
                              getLang(context: context, key: "Female"),
                              style: style4.copyWith(
                                  fontSize: SizeConfig.TenSize! * 1.3,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        user.ginder = 0;
                        setState(() {});
                      },
                      child: Container(
                        width: SizeConfig.TenSize! * 12,
                        decoration: BoxDecoration(
                            color: MainColor.withOpacity(
                                user.ginder == 0 ? 1 : 0.1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.TenSize! * 3,
                              vertical: SizeConfig.TenSize!),
                          child: Center(
                            child: Text(
                              getLang(context: context, key: "Male"),
                              style: style4.copyWith(
                                  fontSize: SizeConfig.TenSize! * 1.3,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    FaIcon(FontAwesomeIcons.person, size: 20, color: MainColor),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.FONT_SIZE_LARGE,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppConstants.PickCode_Screan2);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: SizeConfig.TenSize! * 4,
                          decoration: BoxDecoration(
                              color: whitecolor3,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.TenSize! * 2),
                                child: Text(
                                  user.Name2 ??
                                      getLang(context: context, key: "Country"),
                                  style: style4.copyWith(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ),
                              Spacer(),
                              user.Code2 != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(width: 15),
                                        Image.asset(
                                          user.Flag2,
                                          package: countryCodePackageName,
                                          width: SizeConfig.TenSize! * 3,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      getLang(
                                          context: context,
                                          key: "what_Country"),
                                      style: styleb45.copyWith(fontSize: 13)),
                              SizedBox(
                                width: SizeConfig.TenSize! * 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: Dimensions.FONT_SIZE_LARGE,
                      ),
                      FaIcon(FontAwesomeIcons.location,
                          size: 20, color: MainColor),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: SizeConfig.TenSize! * 2.5,
                ),
                InkWell(
                  onTap: () {
                    if (user.Comimage == null) {
                      Dialogs().showtoast(
                          getLang(context: context, key: "Select_Photo"));
                    } else if (user.UsernameComp == null ||
                        user.UsernameComp == '') {
                      Dialogs().showtoast(
                          getLang(context: context, key: "Select_Name"));
                    } else if (user.PasswordComp == null ||
                        user.PasswordComp == '') {
                      Dialogs().showtoast(
                          getLang(context: context, key: "Enter_Password"));
                    } else if (user.History == null) {
                      Dialogs().showtoast(
                          getLang(context: context, key: "Select_Birthday"));
                    } else if (user.Code2 == null) {
                      Dialogs().showtoast(
                          getLang(context: context, key: "Select_Country"));
                    } else {
                      user.RegesterNewUser2(context: context);
                    }
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: MainColor,
                          borderRadius: BorderRadius.circular(20)),
                      width: SizeConfig.screenWidth!,
                      height: SizeConfig.TenSize! * 4.4,
                      child: Center(
                          child: Text(
                        getLang(context: context, key: "Done"),
                        style: style1,
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.TenSize! * 2.8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signOutGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      print('Google Sign Out Successfully');
    } catch (e) {
      print('Google Sign Out Error: $e');
    }
  }
}
