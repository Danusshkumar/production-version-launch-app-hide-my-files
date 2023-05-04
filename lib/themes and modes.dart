import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:launch_app/ui_for_file_pages.dart';

class UiAndModeChange extends StatefulWidget {
  const UiAndModeChange({Key? key}) : super(key: key);

  @override
  State<UiAndModeChange> createState() => _UiAndModeChangeState();
}

class _UiAndModeChangeState extends State<UiAndModeChange> {
  static var mainDirectory = "storage/emulated/0";
  static var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
  var mainJson = jsonDecode(mainInfo.readAsStringSync());
  var radioValueTheme;
  var radioValueMode;
  var textStyle = const TextStyle(color:Colors.white60);
  var themeUI;

  @override
  void initState() {

    var mainDirectory = "storage/emulated/0";
    var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
    mainJson = jsonDecode(mainInfo.readAsStringSync());
    if(mainJson["encryptionType"] == "no encryption"){
      radioValueMode = 1;
    }
    else if(mainJson["encryptionType"] == "secure encryption"){
      radioValueMode = 2;
    }
    else if(mainJson["encryptionType"] == "ultra secure encryption"){
      radioValueMode = 3;
    }

    if(mainJson["theme"] == "blue and black"){
      radioValueTheme = 1;
    }
    else if(mainJson["theme"] == "dark"){
      radioValueTheme = 2;
    }
    else if(mainJson["theme"] == "light"){
      radioValueTheme = 3;
    }


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

    return SafeArea(
        child:Scaffold(
          appBar:AppBar(
            title:Text(
                "Encryption modes",
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
            child: Column(
              children: [
                SizedBox(height:20),
                ListTile(
                  title:Text("No encryption",style:textStyle),
                  trailing:Radio(
                    activeColor: Colors.blue,
                    groupValue:radioValueMode,
                    value:1,
                    onChanged:(val){
                      radioValueMode = 1;
                      setState(() {});
                    },
                  ),
                ),
                ListTile(
                  title:Text("Secure encryption",style:textStyle),
                  trailing:Radio(
                    activeColor: Colors.blue,
                    groupValue:radioValueMode,
                    value:2,
                    onChanged:(val){
                      radioValueMode = 2;
                      setState(() {});
                    },
                  ),
                ),
                ListTile(
                  title:Text("Ultra secure mode",style:textStyle),
                  trailing:Radio(
                    activeColor: Colors.blue,
                    groupValue:radioValueMode,
                    value:3,
                    onChanged:(val){
                      radioValueMode = 3;
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10),
                  child: TextButton(
                    child:const Text("SAVE",style:TextStyle(color:Colors.blue,fontSize:15,letterSpacing: 2,fontWeight:FontWeight.bold),),
                    onPressed:(){
                      mainJson = jsonDecode(mainInfo.readAsStringSync());
                      if(radioValueMode == 1){
                        mainJson["encryptionType"] = "no encryption";
                      }
                      else if(radioValueMode == 2){
                        mainJson["encryptionType"] = "secure encryption";
                      }
                      else if(radioValueMode == 3){
                        mainJson["encryptionType"] = "ultra secure encryption";
                      }

                      if(radioValueTheme == 1){
                        mainJson["theme"] = "blue and black";
                      }
                      else if(radioValueTheme == 2){
                        mainJson["theme"] = "dark";
                      }
                      else if(radioValueTheme == 3){
                        mainJson["theme"] = "light";
                      }
                      mainInfo.writeAsStringSync(jsonEncode(mainJson));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
    )
    );
  }
}
