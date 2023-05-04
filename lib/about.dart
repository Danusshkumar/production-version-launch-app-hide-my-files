import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:launch_app/ui_for_file_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);



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
              "About",
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
          body:SingleChildScrollView(
          child:Container(
              color:const Color(0xff383854),
              width:MediaQuery.of(context).size.width,
              child:Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Center(
                    child: Container(
                      width:MediaQuery.of(context).size.height*0.2,
                      height:MediaQuery.of(context).size.height*0.2,
                      margin:const EdgeInsets.only(top:90),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/logo.jpg"),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child:Container(
                        padding:const EdgeInsets.all(25),
                        child: const Text("v 1.0.0",style:TextStyle(color:Colors.white60,letterSpacing: 2.0,fontSize: 30,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                    ),
                  ),
                  Center(
                    child:InkWell(
                      onTap:() => launch("https://sites.google.com/view/hidemyfiles/home"),
                      child:const Text(
                          "Our Terms of service and Privacy policy",
                        style:TextStyle(
                          decoration:TextDecoration.underline,
                          color:Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:const EdgeInsets.symmetric(vertical:25,horizontal: 20),
                    child:const Text("About the app:",style:TextStyle(color:Colors.white60,fontSize:25,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                  ),
                  Container(
                    padding:const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• This app is the first version of \"Hide My Files\"\n (v 1.0.0)",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• The files that are selected when you are in encrypted mode only be encrypted",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• In case of selecting the \"no encryption\" mode, your file won't be encrypted",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• All your encrypted files and app-related files are stored in your internal storage",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• We can't steal your data as all your data will be stored in internal storage",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• As you select more secure algorithm, the time taken for encryption and decryption may increase",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                        Container(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          child:const Text("• In case of any issues regarding passwords, file loss, encryption, decryption, or camera, and have any feedback related to this app, kindly mail your issues and feedback to danusshkumarofficial@gmail.com",style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize:15),textAlign: TextAlign.justify,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        )
    );
  }
}
