import 'package:flutter/material.dart';

class CalcUI{

  static  calcContColor(theme) {//used
    return (theme == "black") ? const Color(0xff121212) : const Color(0xfaededf0);
  }

  static iconAndOprColor(theme){//used
    return (theme == "black") ? const Color(0xfa45ed83) : const Color(0xfa00610d);

  }

  static numPadTxtAndIconSize(c){//used
    return MediaQuery.of(c).size.height * 0.040;
  }

  static iconColor(theme){//used
    return (theme == "black") ? const Color(0xffe3e6e4): const Color(0xff121212);
  }

  static dividerColor(theme){//used
    return (theme == "black")? Colors.grey : Colors.black;
  }

  static buttonViewPadding(c){
    return MediaQuery.of(c).size.width*0.02;
  }

  static calcContPadding(c){//used
    return MediaQuery.of(c).size.width * 0.03;
  }

  static  numPadShadowColor(theme){//used
    return (theme == "black") ? Colors.white : Colors.black;
  }

    static Color? numPadTxtColor;

    static Color? numPadBgColor ;// we have to add 0x(ff - 255) before color, bcz its opacity

    static const double numPadBtnElevation = 7;

    static pwdContTxtStyle(theme){
      return TextStyle(color:(theme == "black") ? Colors.white : Colors.black,fontWeight: FontWeight.bold,);
    }

    static eqnStyle(c,theme, mode){//used
      return TextStyle(
        color:(theme == "black") ? const Color(0xfaa9f4f5) : const Color(0xfa003233),
        fontFamily:(mode != 0) ? "monospace" : "roboto",
        fontSize:MediaQuery.of(c).size.height * 0.04,//to be optimised
      );
    }
    static resultStyle(c,theme){// when the limit is exceeded //used
        return TextStyle(
          color: (theme == "black") ? const Color(0xfa45ed83) : const Color(0xfa00610d),
          fontSize: MediaQuery.of(c).size.height * 0.06,
        );
    }//result style ends here

    static numPadTxtBtnStyle(btnTxt,c,theme){//used
      if(theme == "black") {
        numPadBgColor = const Color(0xfa3b3b3b);
        numPadTxtColor = const Color(0xfaa9f4f5);
      }//condition for black theme
      if(theme == "white"){
        numPadBgColor = const Color(0xfab5b5b5);
        numPadTxtColor = const Color(0xfa003233);
      }//condition for white theme
      if (btnTxt == "+" || btnTxt == "-" || btnTxt == "×" || btnTxt == "÷" ||
          btnTxt == "%" || btnTxt == "<") {
        numPadTxtColor = iconAndOprColor(theme);
      }
      else if (btnTxt == "0" || btnTxt == "1" || btnTxt == "4" || btnTxt == "7") {
        numPadTxtColor = (theme == "black") ? const Color(0xfaa9f4f5) : const Color(0xfa003233);
      } //light blue
      else if (btnTxt == "AC") {
        numPadTxtColor = Colors.red;
      }//condition for different colors

      if (btnTxt == "=") {
        numPadBgColor = (theme == "black") ? Colors.green :  const Color(0xfa00610d);
        numPadTxtColor = Colors.white;
      } else {
        numPadBgColor = numPadBgColor;
      }//UI for equal to button
      return TextButton.styleFrom(
        primary:numPadTxtColor,
        backgroundColor: numPadBgColor,
        textStyle:TextStyle(
          fontSize:numPadTxtAndIconSize(c),
        ),
        elevation:numPadBtnElevation,
        shadowColor: numPadShadowColor(theme),
        shape: const CircleBorder(),
      );// the original style is returned here
    }
  }