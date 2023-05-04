import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class UiForHome{

  static var columnGapSizedBoxHeight = 25.0;
  static rowGapSizedBoxWidth(c){
    return MediaQuery.of(c).size.width * 0.07;
  }
  static var scrollViewHorPadding = 25.0;
  static headingTxtMargin(){
    return const EdgeInsets.fromLTRB(5, 5, 0, 0);
  }
  static headingTxtStyle(c){
    return TextStyle(
      fontSize:MediaQuery.of(c).size.height * 0.023,
      fontWeight:FontWeight.w800,
      color:Colors.white70,
    );
  }
  static scrollViewContHeight(c){
    return MediaQuery.of(c).size.height * 0.62;
  }
  static scrollViewContWidth(c){
    return MediaQuery.of(c).size.width;
  }
  static headingInfoSizedBoxHeight(c){
    return MediaQuery.of(c).size.height * 0.025;
  }
  static infoInfoSizedBoxHeight(c){
    return MediaQuery.of(c).size.height * 0.03;
  }
  static infoBoxContHeight(c){
    return MediaQuery.of(c).size.height * 0.38;
  }
  static infoBoxContWidth(c){
    return MediaQuery.of(c).size.width;
  }
  static var infoBoxBorderRadius = 20.0;
  static homeContainerDecoration(){
    return const BoxDecoration(
      gradient: LinearGradient(
        begin:Alignment.topLeft,
        end:Alignment.bottomRight,
        stops:[0.2,0.4,0.6,0.8,1.0],
        colors:[Color(0xff2e2e30),Color(0xff2b2c36),Color(0xff2e2959),Color(0xff2e267a),Color(0xff0c0459)],
      ),
    );
  }
  static infoDetailTxt(c,txt){
    return Text(
      "$txt\nno. of files:\nsize:",
      style:TextStyle(
        fontSize:MediaQuery.of(c).size.height * 0.018,
        color:Colors.white,
      ),
    );
  }
  static settingOnPressed(context) async {
    Navigator.pushNamed(context,"settings");
  }
  static cardDesign(c,{icon,text,onTap,color}){
    return Expanded(
      child: Card(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9)
        ),
        color:const Color(0xff32324f),
        elevation: 6,
        shadowColor:const Color(0xff5a88d2),
        child:InkWell(
          onTap:() {
            Navigator.pushNamed(c, onTap);
          },
          child:Container(
            height:MediaQuery.of(c).size.height * 0.15,
            width:100,
            alignment:Alignment.center,
            padding:const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children:[
                (icon != "") ? Icon(
                  icon,
                  color:color,
                  size:MediaQuery.of(c).size.height * 0.05,
                ) : Container(
                  width: MediaQuery.of(c).size.height * 0.05,
                  height: MediaQuery.of(c).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/logo.jpg"),
                    ),
                  ),
                ),
                const SizedBox(height:10),
                Text(
                  text,
                  style:TextStyle(
                    color:Colors.white60,
                    fontSize:MediaQuery.of(c).size.height * 0.025,
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}

class Bezier extends CustomPainter {
  BuildContext context;
  final double curveHeight = 70;
  Bezier(this.context);
  @override
  void paint(Canvas canvas, Size size){
    final p = Path();
    p.lineTo(0,MediaQuery.of(context).size.height*0.25);
    p.quadraticBezierTo(MediaQuery.of(context).size.width/2,MediaQuery.of(context).size.height*0.25 + 100,MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.25);
    p.lineTo(MediaQuery.of(context).size.width,0);
    p.close();
    canvas.drawPath(p,Paint()..color = const Color(0xff32324f));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
