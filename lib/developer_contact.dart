import 'dart:convert';
import 'dart:io';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart' as mail;
import 'account_icons.dart';
import "package:flutter/services.dart";

class DeveloperContact extends StatelessWidget {
  const DeveloperContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeUI;
    var mainDirectory = "storage/emulated/0";
    var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
    var mainJson = jsonDecode(mainInfo.readAsStringSync());
    if(mainJson["theme"] == "blue and black"){
      themeUI = BlueBlackTheme();
    }
    else if(mainJson["theme"] == "dark"){
      themeUI = DarkTheme();
    }
    else if(mainJson["theme"] == "light"){
      themeUI = LightTheme();
    }
    return SafeArea(
      child:Scaffold(
        appBar:AppBar(
          title:Text(
            "Developer contact",
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
          child:Column(
            children:[
              Container(
                padding:const EdgeInsets.all(30),
                child:const Icon(Account.account_circle,size:160,color:Colors.white60),
              ),
              const SizedBox(height:20),
              Container(
                padding:const EdgeInsets.symmetric(vertical: 10,horizontal:10),
                margin:const EdgeInsets.symmetric(vertical: 15,horizontal:10),
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Colors.black.withOpacity(0.2),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:const [
                    Text("mail id:",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize: 20)),
                    SizedBox(height:20),
                    Text("danusshkumarofficial@gmail.com",style:TextStyle(color:Colors.white60,fontSize: 12,letterSpacing: 2)),
                      ],
                    ),
                    Container(
                      padding:const EdgeInsets.all(10),
                        child:IconButton(
                          onPressed:() async {
                            var mailto = mail.Mailto(
                              to:["danusshkumarofficial@gmail.com"],
                              body:'',
                              subject:'',
                            );
                            await launchUrl(Uri.parse('$mailto'));
                          },
                            icon:const Icon(Icons.mail,color:Colors.white60),
                        )
                    ),
                  ],
                ),
              ),
              Container(
                padding:EdgeInsets.symmetric(vertical: 10,horizontal:10),
                margin:const EdgeInsets.symmetric(vertical: 15,horizontal:10),
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:Colors.black.withOpacity(0.2),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:const [
                        Text("instagram id:",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize: 20)),
                        SizedBox(height:20),
                        Text("danusshkumar_official",style:TextStyle(color:Colors.white60,fontSize: 12,letterSpacing: 2)),
                      ],
                    ),
                    Container(
                        padding:const EdgeInsets.all(10),
                        child:IconButton(
                            icon:const Icon(Icons.copy,color:Colors.white60),
                          onPressed: () async {
                            await Clipboard.setData(const ClipboardData(text: "danusshkumar_official"));
                            Fluttertoast.showToast(
                              msg: "text copied to clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              // length
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                              textColor: const Color(0xffdbdbdb), // location
                            );
                          },
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
