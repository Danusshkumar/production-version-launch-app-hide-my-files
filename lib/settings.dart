import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:launch_app/main.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import "bulb_icons.dart";

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var themeUI;
  static var mainDirectory = "storage/emulated/0";
  static var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
  var mainJson = jsonDecode(mainInfo.readAsStringSync());

  @override
  void initState() {
    if(mainJson["theme"] == "blue and black"){
      themeUI = BlueBlackTheme();
    }
    else if(mainJson["theme"] == "dark"){
      themeUI = DarkTheme();
    }
    else if(mainJson["theme"] == "light"){
      themeUI = LightTheme();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    mainJson = jsonDecode(mainInfo.readAsStringSync());
    return SafeArea(
      child:Scaffold(
        appBar:AppBar(
          title:Text(
              "Settings",
            style:themeUI.appBarTxtStyle,
          ),
          leading:IconButton(//backIcon
            onPressed:Navigator.of(context).pop,
            icon:const Icon(
              Icons.arrow_back_ios_new_sharp,
              size:18,
              color:Colors.white60,
            ),
          ),
          backgroundColor: UiForFilePages.appBarColor,
          elevation:4,
        ),
        body:Container(
          decoration:UiForFilePages.filePageContainerDecoration(),
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: SingleChildScrollView(
              child: Container(
                margin:const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Card(
                      elevation: 8,
                      color:const Color(0xff32324f),
                      shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          width:MediaQuery.of(context).size.width,
                          padding:const EdgeInsets.fromLTRB(15, 30, 0, 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tip",
                                style:themeUI.settingTipTxtStyle,
                              ),
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Bulb.lightbulb,color:Colors.amberAccent),
                                  const SizedBox(width:25),
                                  Flexible(
                                    child: Text("type 112233 and press equal to ( = ) in calculator when you forgot password",
                                      style:themeUI.settingTipSubTxtStyle,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                    const SizedBox(height:5,),
                    Card(
                      elevation: 8,
                      color:const Color(0xff32324f),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        padding:const EdgeInsets.fromLTRB(15, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Auto name files from camera",
                              style:themeUI.settingPgTxtStyle,
                            ),
                            Switch(
                              activeColor: Colors.blue,
                              value:(mainJson['camFileNameOption'] == "auto") ? true : false,
                              onChanged: (val){
                                if(val){
                                  mainJson['camFileNameOption'] = "auto";
                                }
                                else{
                                  mainJson['camFileNameOption'] = "self";
                                }
                                mainInfo.writeAsStringSync(jsonEncode(mainJson));
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height:5,),
                    InkWell(
                      onTap:(){
                        mainJson["password"] = "newNull";
                        mainInfo.writeAsStringSync(jsonEncode(mainJson));
                        Navigator.pushReplacementNamed(context, "calculator");
                      },
                      child: Card(
                        color:const Color(0xff32324f),
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 8,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            width:MediaQuery.of(context).size.width,
                            padding:const EdgeInsets.fromLTRB(15, 30, 0, 30),
                            child: const Text(
                              "Reset your password",
                              style:TextStyle(
                                color:Colors.white60,
                              ),
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height:5,),
                    InkWell(
                      onTap:(){
                        Navigator.pushNamed(context, "themes and modes");
                      },
                      child: Card(
                        color:const Color(0xff32324f),
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 8,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            width:MediaQuery.of(context).size.width,
                            padding:const EdgeInsets.fromLTRB(15, 30, 0, 30),
                            child: Text(
                              "Encryption modes",
                              style:themeUI.settingPgTxtStyle,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height:5,),
                    InkWell(
                      onTap:(){
                        Navigator.pushNamed(context, "set security question");
                      },
                      child: Card(
                        color:const Color(0xff32324f),
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 8,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            width:MediaQuery.of(context).size.width,
                            padding:const EdgeInsets.fromLTRB(15, 30, 0, 30),
                            child: Text(
                              "Set security questions",
                              style:themeUI.settingPgTxtStyle,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height:5,),
                    InkWell(
                      onTap:(){
                        Navigator.pushNamed(context, "developer contact");
                      },
                      child: Card(
                        color:const Color(0xff32324f),
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 8,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            width:MediaQuery.of(context).size.width,
                            padding:const EdgeInsets.fromLTRB(15, 30, 0, 30),
                            child: Text(
                              "Developer contact",
                              style:themeUI.settingPgTxtStyle,
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height:5,),
                    InkWell(
                      onTap:(){
                        Navigator.pushNamed(context, "about");
                      },
                      child: Card(
                        color:const Color(0xff32324f),
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 8,
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            width:MediaQuery.of(context).size.width,
                            padding:const EdgeInsets.fromLTRB(15, 30, 0, 30),
                            child: Text(
                              "About",
                              style:themeUI.settingPgTxtStyle,
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
