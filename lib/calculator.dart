import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:math_expressions/math_expressions.dart';// importing math expression (for evaluating expression)
import 'package:launch_app/uiForCalculator.dart';

import 'package:launch_app/other_functions.dart';//uiForCalculator import
import "package:launch_app/universalProperties.dart";


class CalculatorPage extends StatefulWidget {//basic calculator stateful widget
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorState();
}

class _CalculatorState extends State<CalculatorPage> {

  static var exp = "0";
  static var expView = "0";
  static var solved = "0";
  static var theme = "black";
  static var expAndExpView = ["0","0"];
  static var pwdReaderMode = 0;
  static var pwdContContent = "";
  static var tempPwdStore;
  static var pwdNumCount = 0;
  static var popUp;
  static var mainDirectory = "storage/emulated/0";
  static var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
  Map mainInfoMap = jsonDecode(mainInfo.readAsStringSync());

  @override
  void initState(){
    if(mainInfoMap['password'] == "null"){
      popUp = "your password was stored successfully";
      pwdContContent = "set your password";
      expAndExpView[1] = "_ _ _ _ ";
      pwdReaderMode = 1;
      solved = "";
      print(expAndExpView);
    }
    else if(mainInfoMap['password'] == "newNull"){
      popUp = "your password was updated successfully";
      pwdContContent = "enter your new password";
      expAndExpView[1] = "_ _ _ _ ";
      pwdReaderMode = 1;
      solved = "";
      print(expAndExpView);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {//builder widget
      exp = expAndExpView[0];
      expView = expAndExpView[1];
      print("here ${expAndExpView[1]}");
    Container buttonView({type,btnTxt}){
      return Container(
        padding:EdgeInsets.all(CalcUI.buttonViewPadding(context)),
        child: TextButton(
          onPressed:() {
            if (pwdReaderMode == 0) {
              if (type == "number") {
                expAndExpView =
                    CalculatorFunction.numberFunc(exp, expView, btnTxt);
              }
              else if (type == "operator") {
                expAndExpView =
                    CalculatorFunction.operatorFunc(exp, expView, btnTxt);
              }
              else if (type == "clear") {
                expAndExpView =
                    CalculatorFunction.clearFunc(exp, expView, btnTxt);
                if (btnTxt == "AC") {
                  solved = "0";
                }
              }
              else if (type == "dot") {
                expAndExpView = CalculatorFunction.dotFunc(exp, expView);
              }
              else if (type == "equal") {
                solved = CalculatorFunction.equalFunc(exp, solved, context);
                setState(() {});
              }
            }
            else if(pwdReaderMode == 1){
              print(pwdNumCount);
              if(pwdNumCount < 4 ) {
                if (type == "number" && btnTxt != "00") {
                  pwdNumCount++;
                  expAndExpView = CalculatorFunction.numberPwdFunc(exp, expView, btnTxt,pwdNumCount);
                }
              }
              else {
                if(type != "equal") {
                  Fluttertoast.showToast(
                    msg: "press = to save the password",
                    toastLength: Toast.LENGTH_SHORT,
                    // length
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                    textColor: const Color(0xffdbdbdb), // location
                  );
                }
                else{
                  tempPwdStore = expAndExpView[1];
                  pwdContContent = "re-enter your password";
                  expAndExpView = ["_ _ _ _","_ _ _ _ "];
                  pwdReaderMode = 2;
                  pwdNumCount = 0;
                }
              }
            }
            else if(pwdReaderMode == 2){
              if(pwdNumCount < 4) {
                if (type == "number" && btnTxt != "00") {
                  pwdNumCount++;
                  expAndExpView = CalculatorFunction.numberPwdFunc2(exp, expView, btnTxt,pwdNumCount);
                }
              }
              else {
                print(pwdNumCount);
                if(type != "equal") {
                  Fluttertoast.showToast(
                    msg: "press = to save the password",
                    toastLength: Toast.LENGTH_SHORT,
                    // length
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                    textColor: const Color(0xffdbdbdb), // location
                  );
                }
                else{
                  if(expAndExpView[1] == tempPwdStore) {
                      Navigator.pushReplacementNamed(context,"home");
                    mainInfoMap['password'] = expView.replaceAll(" ","");
                    mainInfo.writeAsStringSync(jsonEncode(mainInfoMap));
                    Fluttertoast.showToast(
                      msg: popUp,
                      toastLength: Toast.LENGTH_SHORT,
                      // length
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                      textColor: const Color(0xffdbdbdb), // location
                      );
                  }
                  else {
                    Fluttertoast.showToast(
                      msg: "password mismatch found, try again",
                      toastLength: Toast.LENGTH_SHORT,
                      // length
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                      textColor: const Color(0xffdbdbdb), // location
                    );
                    pwdContContent = "please enter your password";
                    pwdNumCount = 0;
                    pwdReaderMode = 1;
                    expAndExpView = ["_ _ _ _ ","_ _ _ _ "];
                    tempPwdStore = "";
                    CalculatorFunction.restoreAgain();
                  }
                }
              }
            }
            setState(() {});
          },
          style:CalcUI.numPadTxtBtnStyle(btnTxt, context, theme),
          child:CalculatorFunction.btnChildContent(type:type,btnTxt:btnTxt,context: context),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
          body:Container(
        padding:EdgeInsets.fromLTRB(CalcUI.calcContPadding(context), 0, CalcUI.calcContPadding(context), 0),
        color:CalcUI.calcContColor(theme),
        child: Column(
          children:[
            Flexible(
              flex:1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:IconButton(
                      icon:Icon(
                          Icons.brightness_6,
                      size:MediaQuery.of(context).size.height*0.05,
                      color:CalcUI.iconColor(theme),
                      ),
                      onPressed:(){
                        if(theme == "black") {
                          theme = "white";
                        }
                        else{
                          theme = "black";
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    child:Text(pwdContContent,style:CalcUI.pwdContTxtStyle(theme)),
                  )
                ],
              ),
            ),
            Flexible(
              flex:1,
              child: Container(
                alignment: Alignment.centerRight,
                child:NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return false;
                  },
                  child: ListView(
                  scrollDirection: Axis.horizontal,
                  reverse:true,
                  children: [
                    Text(
                      expView,
                    style:CalcUI.eqnStyle(context, theme, pwdReaderMode),
                  ),],
                ),
                ),
              ),
            ),
            Flexible(
              flex:1,
              child:Container(
              alignment: Alignment.centerRight,
              child:NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: ListView(
                  scrollDirection:Axis.horizontal,
                    reverse:true,
                  children: [
                    Text(
                      solved,
                    style:CalcUI.resultStyle(context, theme),
                  ),
                  ]
                ),
              ),),
            ),
            Divider(color:CalcUI.dividerColor(theme),height:20),
            Flexible(
              flex:6,
              child: Container(
                child:NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return false;
                  },
                  child: GridView.count(
                     crossAxisCount: 4,
                     children: [
                       buttonView(btnTxt: "AC",type: "clear"),
                       buttonView(btnTxt: "%",type: "operator"),
                       buttonView(btnTxt: "<",type: "clear"),
                       buttonView(btnTxt: "÷",type: "operator"),
                       buttonView(btnTxt: "7",type:"number"),
                       buttonView(btnTxt: "8",type:"number"),
                       buttonView(btnTxt: "9",type:"number"),
                       buttonView(btnTxt: "×",type: "operator"),
                       buttonView(btnTxt: "4",type:"number"),
                       buttonView(btnTxt: "5",type:"number"),
                       buttonView(btnTxt: "6",type:"number"),
                       buttonView(btnTxt: "-",type: "operator"),
                       buttonView(btnTxt: "1",type:"number"),
                       buttonView(btnTxt: "2",type:"number"),
                       buttonView(btnTxt: "3",type:"number"),
                       buttonView(btnTxt: "+",type: "operator"),
                       buttonView(btnTxt: "0",type:"number"),
                       buttonView(btnTxt: "00",type:"number"),
                       buttonView(btnTxt: ".",type: "dot"),
                       buttonView(btnTxt: "=",type: "equal"),
                     ],
                      ),
                )
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}