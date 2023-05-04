import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icon.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import 'package:mailto/mailto.dart' as mail;
import 'package:url_launcher/url_launcher.dart';

import 'dot_icons.dart';

class AskQuestions extends StatefulWidget {
  const AskQuestions({Key? key}) : super(key: key);

  @override
  State<AskQuestions> createState() => _AskQuestionsState();
}

class _AskQuestionsState extends State<AskQuestions> {

  static var mainDirectory = "storage/emulated/0";
  static var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
  var mainJson = jsonDecode(mainInfo.readAsStringSync());
  var securityAnswers = [];
  List<Widget> showSlide = [];
  var securityQuestions = [];
  var slideNumber = 0;
  var controller = [];
  var userAnswers = [];
  var pageViewController = PageController();

  @override
  void initState() {
    for(int i = 0;i<4;i++) {
      if (mainJson["security questions"][i] != "") {
        securityAnswers.add(mainJson["security questions"][i]);
        controller.add(TextEditingController());
        if(i == 0){
          securityQuestions.add("What's your pet name?");
        }
        else if(i == 1){
          securityQuestions.add("What's the name of your best friend?");
        }
        else if(i == 2){
          securityQuestions.add("Who's your role model?");
        }
        else if(i == 3){
          securityQuestions.add("Things you may like (hobbies or something)");
        }
      }
    }
    for(int i = 0;i<securityAnswers.length;i++){
      showSlide.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical:10,horizontal: 15),
          child: Card(
            color:const Color.fromARGB(180, 65, 65, 102),
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child:Column(
              children: [
                Flexible(flex:1,child:Center(child: Text(securityQuestions[i],style:const TextStyle(color:Colors.white60,fontSize:15,fontWeight:FontWeight.bold)))),
                Flexible(
                  flex:1,
                  child: Container(
                    padding:const EdgeInsets.fromLTRB(50,0,50,50),
                    child:TextField(
                      controller:controller[i],
                      style:const TextStyle(color:Colors.white60),
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
      );
    }
    super.initState();
  }

  var onPressedNext;
  var noOfCorrectAnswers = 0;

  @override
  Widget build(BuildContext context) {
    print(securityAnswers);
    print(userAnswers);
    print("slide number $slideNumber");
    if(securityAnswers.isNotEmpty) {
      if (slideNumber == securityAnswers.length - 1) {
        onPressedNext = () {
          print("last question");
          userAnswers = List.generate(
              securityAnswers.length, (index) => "${controller[index].text
              .toLowerCase().replaceAll(" ", "")}");
          for (int i = 0; i < securityAnswers.length; i++) {
            if (userAnswers[i] == securityAnswers[i]) {
              noOfCorrectAnswers++;
            }
          }

          if (noOfCorrectAnswers >= 2) {
            Fluttertoast.showToast(
              msg: (noOfCorrectAnswers != 4)
                  ? "$noOfCorrectAnswers of your answers are correct"
                  : "all the four answers are correct",
              toastLength: Toast.LENGTH_SHORT,
              // length
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: const Color.fromARGB(80, 0, 0, 0),
              textColor: const Color(0xffdbdbdb), // location
            );
            var mainInfo = File(
                "$mainDirectory/.hmf/!important folder/mainInfo.json");
            Map mainInfoMap = jsonDecode(mainInfo.readAsStringSync());
            mainInfoMap["password"] = "newNull";
            mainInfo.writeAsStringSync(jsonEncode(mainInfoMap));
            Navigator.pushReplacementNamed(context, "calculator");
          }
          else {
            noOfCorrectAnswers = 0;
            pageViewController.jumpToPage(0);
            for (int i = 0; i < controller.length; i++) {
              controller[i].text = "";
            }
            slideNumber = 0;
            setState(() {});
            print("not a last question");
            Fluttertoast.showToast(
              msg: "your answers seems not correct",
              toastLength: Toast.LENGTH_SHORT,
              // length
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: const Color.fromARGB(80, 0, 0, 0),
              textColor: const Color(0xffdbdbdb), // location
            );
          }
        };
      }
      else {
        if (controller[slideNumber].text != "") {
          onPressedNext = () {
            pageViewController.jumpToPage(++slideNumber);
            setState(() {});
          };
        }
        else {
          onPressedNext = null;
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar:AppBar(
          title:const Text("Forgot Password",style:TextStyle(color:Colors.white60,fontSize: 20)),
          leading:IconButton(//backIcon
            onPressed:() {exit(0);},
            icon:const Icon(
              Icons.arrow_back_ios_new_sharp,
              size:18,
              color:Colors.white60,
            ),
          ),
          backgroundColor: UiForFilePages.appBarColor,
          elevation:4,
          actions: [
            Container(
              margin:const EdgeInsets.all(10),
              decoration:const BoxDecoration(
                color:Color(0xff3a374f),
                borderRadius:BorderRadius.all(Radius.circular(8)),
              ),
              child: TextButton(
                onPressed:() async {
                  var mailto = mail.Mailto(
                    to:["danusshkumarofficial@gmail.com"],
                    body:'Describe your issue here...',
                    subject:'regarding the resetting of my password',
                  );
                  await launchUrl(Uri.parse('$mailto'));
                },
                child:const Text("Get Help",style:TextStyle(color:Colors.white60)),
              ),
            ),
          ],
        ),
        body:Container(
          decoration:UiForFilePages.filePageContainerDecoration(),
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: (securityAnswers.isEmpty) ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Flexible(child: Text("You won't answered \nany security questions",textAlign:TextAlign.center,style:TextStyle(color:Colors.white60,fontSize:20),)),
            ],
          )) :
          Column(
            children:[
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
                        "You must answer at least two question inorder to retrieve your password",
                        textAlign:TextAlign.center,
                        style:TextStyle(color:Colors.white60),
                      ))
              ),
              Flexible(
                flex:4,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return false;
                  },
                  child: PageView(
                    controller:pageViewController,
                    physics: const NeverScrollableScrollPhysics(),
                    children:showSlide,
                  ),
                ),
              ),
              Flexible(
                flex:2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:const EdgeInsets.all(15),
                      child: TextButton(
                        onPressed:(){
                          if(slideNumber != 0) {
                            pageViewController.jumpToPage(--slideNumber);
                            setState(() {});
                          }
                        },
                        child:const Text("PREVIOUS",style:TextStyle(color:Colors.blue)),
                      ),
                    ),
                    Container(
                      padding:const EdgeInsets.all(15),
                      child: TextButton(
                        onPressed:onPressedNext,
                        child:Text("NEXT",style:TextStyle(color:(controller[slideNumber].text == "") ? Colors.black45 : Colors.blue)),
                      ),
                    ),
                  ],
                ),
              ),
              const Flexible(
                flex:5,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
