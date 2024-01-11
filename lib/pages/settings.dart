import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joosecustomer/localization/app_localization.dart';
import 'package:joosecustomer/localization/language.dart';
import 'package:joosecustomer/localization/language_const.dart';
import 'package:joosecustomer/widgets/drawer.dart';
import 'package:joosecustomer/widgets/joose_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool value1 = false;
  bool value2 = false;
  String? lang;


  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // languageget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading:  InkWell(
          onTap: () => Navigator.pop(context),
          child:   Padding(
            padding: EdgeInsets.only(left: 10,top: 30),
            child:  JooseText(
              text:  AppLocalizations.of(context).translate('cl'),
              fontColor: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),

        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 0.01,
        flexibleSpace: Container(
          decoration:
          const BoxDecoration(
            image: DecorationImage(
              image: AssetImage( "assets/images/appbarimg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: JooseText(
          text:  AppLocalizations.of(context).translate('SETTINGS'),
          fontColor: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      key: _key,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Container(
            //   margin: EdgeInsets.only(left: 30, top: 20, right: 20),
            //   child: Row(
            //     children: [
            //       JooseText(
            //         text: AppLocalizations.of(context).translate("Allowallpushnotifications"),
            //         fontSize: 14,
            //         fontColor: Colors.black,
            //       ),
            //       Expanded(child: SizedBox()),
            //       Checkbox(
            //         activeColor: Colors.redAccent.shade700,
            //         side: BorderSide(color: Colors.black),
            //         checkColor: Colors.white,
            //         value: this.value1,
            //         onChanged: (bool? value) {
            //           setState(() {
            //             this.value1 = value!;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),



            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                children: [
                  JooseText(
                    text: AppLocalizations.of(context).translate("Language"),
                    fontSize: 14,
                    fontColor: Colors.black,
                    alignment: TextAlign.justify,
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    child:  DropdownButton<Language>(
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      iconSize: 30,
                      hint: JooseText(text: AppLocalizations.of(context).translate("change_language"),
                          fontWeight: FontWeight.w500,
                          fontColor: Colors.redAccent.shade700,
                          fontSize: 14,
                          over: TextOverflow.ellipsis
                      ),
                      onChanged: (Language? language) {
                        _changeLanguage(language!);
                      },
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                            (e) => DropdownMenuItem<Language>(
                          value: e,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              JooseText(text: e.flag,
                                fontWeight: FontWeight.w500,
                                fontColor: Colors.white,
                                fontSize: 23,
                              ),
                              JooseText(text: e.name,
                                fontWeight: FontWeight.w500,
                                fontColor: Colors.black,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
