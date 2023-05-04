import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_app/ui_for_file_pages.dart';

import 'dot_icons.dart';

class SetSecurityQuestion extends StatefulWidget {
  const SetSecurityQuestion({Key? key}) : super(key: key);

  @override
  State<SetSecurityQuestion> createState() => _SetSecurityQuestionState();
}

class _SetSecurityQuestionState extends State<SetSecurityQuestion> {
  var themeUI;
  var pageViewController = PageController(initialPage:0);
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();
  var slideNumber = 0;
  var onPressedSkip;
  var securityQuestions;
  static var mainDirectory = "storage/emulated/0";
  static var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
  var mainJson = jsonDecode(mainInfo.readAsStringSync());

  @override
  void initState() {
    if (mainJson["theme"] == "blue and black") {
      themeUI = BlueBlackTheme();
    }
    else if (mainJson["theme"] == "dark") {
      themeUI = DarkTheme();
    }
    else if (mainJson["theme"] == "light") {
      themeUI = LightTheme();
    }
    securityQuestions = mainJson["security questions"];
    controller1.text = securityQuestions[0];
    controller2.text = securityQuestions[1];
    controller3.text = securityQuestions[2];
    controller4.text = securityQuestions[3];
    super.initState();
  }

  filledFieldCount() {
    var filledFieldCount = 0;
    if(controller1.text != ""){
      filledFieldCount++;
    }
    if(controller2.text != ""){
      filledFieldCount++;
    }
    if(controller3.text != ""){
      filledFieldCount++;
    }
    if(controller4.text != ""){
      filledFieldCount++;
    }
    return filledFieldCount;
  }
  @override
  Widget build(BuildContext context) {

    if(slideNumber != 3) {
      onPressedSkip = () {
        if (slideNumber < 3) {
          pageViewController.jumpToPage(++slideNumber);
        }
      };
      setState(() {});
    }
    else {
      onPressedSkip = null;
    }


    return SafeArea(
      child:Scaffold(
        resizeToAvoidBottomInset: false,
       appBar:AppBar(
         title:Text(
           "Set security questions",
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
            children: [
              Flexible(
                  flex:2,
                  child: Container(
                    decoration:BoxDecoration(
                      color:Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding:const EdgeInsets.fromLTRB(15, 12, 15, 12),
                      child:const Text(
                      "You must answer at least two question inorder to retrieve your password when you forgot the password",
                    textAlign:TextAlign.justify,
                    style:TextStyle(color:Colors.white60),
                  ))
              ),
              Flexible(
                flex:5,
                  child:Column(
                    children: [
                      Flexible(
                        flex:9,
                        child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowIndicator();
                            return false;
                          },
                          child: PageView(
                             controller:pageViewController,
                            onPageChanged: (val){
                               slideNumber = val;
                               setState(() {});
                            } ,
                     children:[
                       Padding(
                           padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
                           child: Card(
                             color:const Color.fromARGB(180, 65, 65, 102),
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child:Column(
                              children: [
                                const Flexible(flex:1,child:Center(child: Text("What's your pet name?",style:TextStyle(color:Colors.white60,fontSize:15,fontWeight:FontWeight.bold)))),
                                Flexible(
                                  flex:1,
                                  child: Container(
                                    padding:const EdgeInsets.fromLTRB(50,0,50,50),
                                    child:TextField(
                                      style:const TextStyle(color:Colors.white60),
                                    controller:controller1,
                                    cursorColor: Colors.blue,
                                    onChanged: (val){
                                      setState(() {});
                                    },
                                    decoration:const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                       ),
                       Padding(
                           padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
                           child: Card(
                             color:const Color.fromARGB(180, 65, 65, 102),
                             shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                             child:Column(
                               children: [
                                 const Flexible(flex:1,child:Center(child: Text("What's the name of your best friend?",style:TextStyle(color:Colors.white60,fontSize:15,fontWeight:FontWeight.bold)))),
                                 Flexible(
                                   flex:1,
                                   child: Container(
                                     padding:const EdgeInsets.fromLTRB(50,0,50,50),
                                     child:TextField(
                                       style:const TextStyle(color:Colors.white60),
                                       controller:controller2,
                                       cursorColor: Colors.blue,
                                       onChanged: (val){
                                         setState(() {});
                                       },
                                       decoration:const InputDecoration(
                                         focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                       ),
                       Padding(
                           padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
                           child: Card(
                             color:const Color.fromARGB(180, 65, 65, 102),
                             shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                             child:Column(
                               children: [
                                 const Flexible(flex:1,child:Center(child: Text("Who's your role model?",style:TextStyle(color:Colors.white60,fontSize:15,fontWeight:FontWeight.bold)))),
                                 Flexible(
                                   flex:1,
                                   child: Container(
                                     padding:const EdgeInsets.fromLTRB(50,0,50,50),
                                     child:TextField(
                                       style:const TextStyle(color:Colors.white60),
                                       controller:controller3,
                                       cursorColor: Colors.blue,
                                       onChanged: (val){
                                         setState(() {});
                                       },
                                       decoration:const InputDecoration(
                                         focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                       ),
                       Padding(
                           padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
                           child: Card(
                             color:const Color.fromARGB(180, 65, 65, 102),
                             shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                             child:Column(
                               children: [
                                 const Flexible(flex:1,child:Center(child: Text("Things you may like (hobbies or something)",style:TextStyle(color:Colors.white60,fontSize:15,fontWeight:FontWeight.bold)))),
                                 Flexible(
                                   flex:1,
                                   child: Container(
                                     padding:const EdgeInsets.fromLTRB(50,0,50,50),
                                     child:TextField(
                                       style:const TextStyle(color:Colors.white60),
                                       controller:controller4,
                                       cursorColor: Colors.blue,
                                       onChanged: (val){
                                         setState(() {});
                                       },
                                       decoration:const InputDecoration(
                                         focusedBorder: UnderlineInputBorder(
                                           borderSide: BorderSide(color: Colors.blue),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                       ),
                ],
              ),
                        ),
                      ),
                      Flexible(
                        flex:1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Icon(Dot.dot,color:(slideNumber == 0) ? Colors.white : Colors.white60,size: 20),
                              Icon(Dot.dot,color:(slideNumber == 1) ? Colors.white : Colors.white60,size:20),
                              Icon(Dot.dot,color:(slideNumber == 2) ? Colors.white : Colors.white60,size:20),
                              Icon(Dot.dot,color:(slideNumber == 3) ? Colors.white : Colors.white60,size:20),
                            ]),
                      )
                    ],
                  )),
              Flexible(
                flex:2,
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children:[
                    Container(
                      padding:const EdgeInsets.all(15),
                      child: TextButton(
                        onPressed:onPressedSkip,
                        child:Text("SKIP",style:TextStyle(color:(slideNumber != 3) ? Colors.blue : Colors.black45)),
                      ),
                    ),
                    Container(
                      padding:const EdgeInsets.all(15),
                      child: TextButton(
                        onPressed:(){
                          if(slideNumber < 3 ) {
                            pageViewController.jumpToPage(++slideNumber);
                          }
                          else {
                            if(filledFieldCount() >= 2) {
                              securityQuestions = [controller1.text,controller2.text,controller3.text,controller4.text];
                              for(int i = 0;i<securityQuestions.length;i++){
                                securityQuestions[i] = securityQuestions[i].toLowerCase();
                                securityQuestions[i] = securityQuestions[i].replaceAll(" ","");
                              }
                              mainJson["security questions"] = securityQuestions;
                              mainInfo.writeAsStringSync(jsonEncode(mainJson));
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                msg: "Your response was updated successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                // length
                                gravity: ToastGravity.SNACKBAR,
                                backgroundColor: const Color.fromARGB(
                                    80, 0, 0, 0),
                                textColor: const Color(0xffdbdbdb), // location
                              );
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "You must answer at least two questions",
                                toastLength: Toast.LENGTH_SHORT,
                                // length
                                gravity: ToastGravity.SNACKBAR,
                                backgroundColor: const Color.fromARGB(
                                    80, 0, 0, 0),
                                textColor: const Color(0xffdbdbdb), // location
                              );
                            }
                          }
                          setState(() {});
                        },
                        child:const Text("NEXT",style:TextStyle(color:Colors.blue),
                      ),
                    ),
                    )
                  ],
                ),
              ),
              const Flexible(
                flex:4,
                  child:SizedBox()),
            ],
          )
        ),
      )
    );
  }
}
