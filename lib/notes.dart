import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_app/other_functions.dart';
import 'dart:io';
import 'package:launch_app/ui_for_file_pages.dart';
import 'package:launch_app/notes_add.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  static var mainDirectory = "storage/emulated/0";
  var contentWidget;
  var floatActBtn;
  static var nInfo = File("$mainDirectory/.hmf/!important folder/nInfo.json");
  static var nInfoList = jsonDecode(nInfo.readAsStringSync());
  var showCheckBox = false;
  static var showCheckBoxList = List.generate(nInfoList.length,(index)=> false);
  var selectedNotesList = [];
  var deleteBtnState = null;
  callBack(){
    return setState((){
      NotesFunction.setCheckBox = false;
      print("I worked");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Here below build $showCheckBox");
    print(nInfoList);
    nInfoList = jsonDecode(nInfo.readAsStringSync());

    var onScreenList = NotesFunction.onScreenList(context:context,callBack:callBack,showCheckBoxList:showCheckBoxList);
    showCheckBoxList = NotesFunction.showCheckBoxListAtFunction;

    if(!showCheckBox){
        contentWidget = NotesFunction.contentWidget(context:context, onScreenList: onScreenList,callBack:callBack);
      }
    else{

        if(selectedNotesList.isEmpty){
          deleteBtnState = null;
          setState(() {});
        }
        else{
          deleteBtnState = (){};
          setState(() {});
        }
      }

    return SafeArea(
      child:Scaffold(
        appBar:AppBar(
          title:const Text("Notes"),
          leading:IconButton(
            icon:const Icon(Icons.arrow_back_ios_new_sharp, size:18, color:Colors.white60,),
            onPressed:(){
              Navigator.pop(context);
            },
          ),
          backgroundColor: UiForFilePages.appBarColor,
        ),
        body:Container(
          decoration:UiForFilePages.filePageContainerDecoration(),
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: contentWidget,
        ),
      ),
    );
  }
}