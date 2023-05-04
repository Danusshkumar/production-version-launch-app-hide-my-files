import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:file_picker/file_picker.dart';
import 'package:swipe/swipe.dart';
import 'package:launch_app/page_for_image_show.dart';
import 'package:launch_app/other_functions.dart';
import "package:launch_app/universalProperties.dart";

class DiaryPage extends StatefulWidget {
  final year;
  const DiaryPage({Key? key,required this.year}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  var currentPageNo = 0;
  var indexNumberToDate = [];
  var formattedIndexNumberToDate = [];
  var noOfDays;
  static var controllerList;
  static var sInfoList;
  static var sInfoCurrentList;
  static var mainDirectory = "storage/emulated/0";
  static var year;
  @override
  void initState(){
    year = widget.year;
    print(year);
    var initDate = DateTime(year,1,1);
    noOfDays = DateTime(year+1,1,1).difference(DateTime(year,1,1)).inDays;
    var currentDate = DateFormat("dd MMM yyyy").format(DateTime.now());
    List initFunctionList = DiaryFunction.initFunction(indexNumberToDate:indexNumberToDate,formattedIndexNumberToDate:formattedIndexNumberToDate,currentPageNo:currentPageNo,noOfDays:noOfDays,currentDate:currentDate,initDate:initDate);
    formattedIndexNumberToDate = initFunctionList[0];
    currentPageNo = initFunctionList[1];
    sInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
    sInfoCurrentList = sInfoList[currentPageNo];
    controllerList = List.generate(sInfoCurrentList.length,(index)=> TextEditingController(text:sInfoCurrentList[index]['info']));
    super.initState();
  }

  Future<int> onPressedAddImg(currentPageNo,context) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      controllerList.add(TextEditingController());
      await DiaryFunction.onPressedAddImage(result: result,year: year, currentPageNo: currentPageNo, controllerList: controllerList);
      controllerList.add(TextEditingController(text: ""));
      actualList(currentPageNo, context).add(
          TextField(
            decoration: const InputDecoration(
              hintText:"write something here",
              border:InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controllerList.last,
            onChanged: (value) {DiaryFunction.onChangedUpdation(currentPageNo:currentPageNo,index:sInfoCurrentList.length-1,value:value,year:year,sInfoCurrentList:sInfoCurrentList);},
          ));
      //this is for actualList updation
      displayListFunc(currentPageNo);
    }
    return 0;
  }

    List<Widget> actualList(currentPageNo,context){
      sInfoList = sInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
      sInfoCurrentList = sInfoList[currentPageNo];
      List<Widget> actualList = DiaryFunction.actualList(sInfoCurrentList: sInfoCurrentList,sInfoList:sInfoList,year:year,currentPageNo:currentPageNo,context:context,controllerList:controllerList);
      return actualList;
    }

    List<Widget> displayListFunc(currentPageNo){
    return actualList(currentPageNo,context);
    }

  @override
  Widget build(BuildContext context) {
    List<Widget> displayList = displayListFunc(currentPageNo);

    return SafeArea(
        child: Scaffold(
          appBar:AppBar(
            backgroundColor: const Color(0xffff40cf),
            title:const Text("Diary"),
            leading:IconButton(
              icon:const Icon(Icons.arrow_back_ios,size:18),
              onPressed:(){
                Navigator.pop(context);
              },
            ),
            actions:[
              IconButton(
                icon:const Icon(Icons.calendar_month_outlined),
                onPressed:() async {
                  var selectedDate = await showDatePicker(
                    builder:(context,Widget? child){
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xffff40cf), // <-- SEE HERE
                            onPrimary: Colors.white, // <-- SEE HERE
                            onSurface: Color(0xffff40cf), // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: const Color(0xffff40cf), // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context:context,
                    firstDate:DateTime(year,1,1),
                    lastDate:DateTime(year,12,31),
                    initialDate:DateTime(year,1,1),
                  );
                  if(selectedDate != null) {
                    var formattedSelectedDate = DateFormat("dd MMM yyyy")
                        .format(selectedDate);
                    for (int i = 0; i < noOfDays; i++) {
                      if (formattedSelectedDate ==
                          formattedIndexNumberToDate[i]) {
                        currentPageNo = i;
                      }
                    }
                    //creating new controller
                    controllerList.clear();
                    sInfoList = jsonDecode(
                        File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
                    sInfoCurrentList = sInfoList[currentPageNo];
                    controllerList = List.generate(
                        sInfoCurrentList.length, (index) => TextEditingController(text: sInfoCurrentList[index]['info']));
                    setState(() {});
                  }
                },
              ),
              IconButton(
                icon:const Icon(Icons.add_photo_alternate_outlined),
                onPressed:() async {
                  await onPressedAddImg(currentPageNo,context);
                  setState(() {});
                }
              ),
            ]
          ),
          body:Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin:Alignment.topCenter,
                  end:Alignment.bottomCenter,
                  stops:[0.2,0.4,0.6,0.8,1.0],
                  colors:[Color(0xffff82e2),Color(0xfffa8cd7),Color(0xffffade5),Color(0xffffc9ee),Color(0xffffdef5)],
                )
            ),
            padding:const EdgeInsets.all(16.0),
            child:Swipe(
              onSwipeLeft:(){
                currentPageNo++;
                if(currentPageNo > noOfDays-1){
                  currentPageNo = noOfDays-1;
                }
                controllerList.clear();
                //creating new controller
                sInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
                sInfoCurrentList = sInfoList[currentPageNo];
                controllerList = List.generate(sInfoCurrentList.length,(index)=> TextEditingController(text:sInfoCurrentList[index]['info']));
                setState(() {});
              },
              onSwipeRight:(){
                currentPageNo--;
                if(currentPageNo < 0){
                  currentPageNo = 0;
                }
                //creating new controller
                controllerList.clear();
                sInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
                sInfoCurrentList = sInfoList[currentPageNo];
                controllerList = List.generate(sInfoCurrentList.length,(index)=> TextEditingController(text:sInfoCurrentList[index]['info']));
                setState(() {});
              },
              child: Material(
                borderRadius: BorderRadius.circular(25),
                elevation: 15,
                child: Container(
                  padding:const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                  decoration: BoxDecoration(
                    border:Border.all(
                      width: 1,
                      color:Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    color:const Color(0xfffadef9),
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        flex:1,
                        child: NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowIndicator();
                            return false;
                          },
                          child: SingleChildScrollView(
                            child: Container(
                              //decoration:
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children:[
                                  Text(formattedIndexNumberToDate[currentPageNo],style:const TextStyle(fontWeight: FontWeight.bold)),
                                  const Divider(height:30,color:Color(0xff000000)),
                                  Column(
                                    children:displayList,
                                    //this is where the diary writing and pictures are saved to
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
