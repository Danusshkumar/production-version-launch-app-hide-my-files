import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_app/diary_page.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import "package:launch_app/universalProperties.dart";
import "package:unicons/unicons.dart";


class DiarySelector extends StatefulWidget {
  const DiarySelector({Key? key}) : super(key: key);

  @override
  State<DiarySelector> createState() => _DiarySelectorState();
}

class _DiarySelectorState extends State<DiarySelector> {

  static var mainDirectory = "storage/emulated/0";
  static var sInfoManager = File("$mainDirectory/.hmf/!important folder/sInfoManager.json");
  var sInfoManagerList = jsonDecode(sInfoManager.readAsStringSync());

  @override
  Widget build(BuildContext context) {
    var diaryList = List.generate(sInfoManagerList.length,(i)=>
      InkWell(
        onTap:(){
          Navigator.push(context,MaterialPageRoute(builder:(context)=> DiaryPage(year:sInfoManagerList[i])));
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          padding:const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:const Color(0x1e000000),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
              child:Icon(
                  UniconsLine.notes,
                size:MediaQuery.of(context).size.height*0.18,
                color:const Color(0xff32324f),
                ),
              ),
              Align(
                alignment: Alignment.center,
                  child:Text("YEAR\n${sInfoManagerList[i]}",textAlign:TextAlign.center,style:TextStyle(color:Colors.white60,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height*0.03)),
              ),
          ],
          ),
        ),
      ),
    );
    return SafeArea(
      child:Scaffold(
        appBar:AppBar(
          title:const Text("Select Diary",style:TextStyle(color:Colors.white60)),
          backgroundColor:const Color(0xff32324f),
          leading: IconButton(
            onPressed:(){
              Navigator.pop(context);
            },
            icon:const Icon(
              Icons.arrow_back_ios_new_sharp,
              size:18,
              color:Colors.white60,
            ),
          ),
          actions:[
            IconButton(
              icon:const Icon(Icons.add),
              onPressed:() async {
                var year = sInfoManagerList[sInfoManagerList.length-1]+1;
                sInfoManagerList.add(year);
                //sInfoManagerList = [2022];
                var nInfo = await File("$mainDirectory/.hmf/!important folder/sInfo$year.json").create();
                var noOfDays = DateTime(year+1,1,1).difference(DateTime(2022,1,1)).inDays;
                var nInfoList = [];
                for(int i = 0;i<noOfDays;i++){
                  nInfoList.add([{'type': 'text', 'info':''}]);
                }
                sInfoManager.writeAsStringSync(jsonEncode(sInfoManagerList));
                nInfo.writeAsStringSync(jsonEncode(nInfoList));
                setState(() {});
              },
            )
          ]
        ),
        body:Container(
          decoration: UiForFilePages.filePageContainerDecoration(),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: GridView.count(
              crossAxisCount: 2,
              children:diaryList
            ),
          ),
        ),
      ),
    );
  }
}