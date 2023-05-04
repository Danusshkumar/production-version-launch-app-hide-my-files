import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_app/ui_for_home.dart';
import "package:permission_handler/permission_handler.dart";

//these packages are included for icons

import 'package:launch_app/app_icons.dart';
import 'package:launch_app/images_icons.dart';
import 'package:launch_app/contact_icons.dart';
import 'package:swipe/swipe.dart';
import "contact_calender_icons.dart";
import "dot_icons.dart";


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return const [
      BottomNavigationBarItem(
          icon: Icon(Dot.dot),
      ),
      BottomNavigationBarItem(
        icon: Icon(Dot.dot),
      ),
      BottomNavigationBarItem(
          icon: Icon(Dot.dot),
      )
    ];
  }
  
  PageController pageController = PageController(initialPage: 0,keepPage:false);
  var slideNumber = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(//main body
          decoration:UiForHome.homeContainerDecoration(),//main body ui
          child: Column(
            children:[
              Flexible(
                flex:4,
                child: Container(// this children is for top design
                  height:UiForHome.infoBoxContHeight(context),//height of top design
                  width:UiForHome.infoBoxContWidth(context),//width of top design
                  child:CustomPaint(//top design
                    painter:Bezier(context),//painter
                    child:Container(
                      padding:const EdgeInsets.all(5),//padding for inner item
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Container(//container for heading and settings button
                            margin:UiForHome.headingTxtMargin(),
                            child: Row(//row for heading and settings icon
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hide My Files",
                                  textAlign: TextAlign.center,
                                  style:UiForHome.headingTxtStyle(context),
                                ),
                                IconButton(
                                  onPressed:(){
                                      UiForHome.settingOnPressed(context);
                                  },
                                  icon:Icon(
                                    Icons.settings,
                                    size:MediaQuery.of(context).size.height * 0.04,
                                  ),
                                  color:Colors.white70,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height:UiForHome.headingInfoSizedBoxHeight(context)),//gap between heading and info
                          Container(
                            width:MediaQuery.of(context).size.width,
                            height:MediaQuery.of(context).size.height * 0.15,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (OverscrollIndicatorNotification overscroll) {
                                overscroll.disallowIndicator();
                                return false;
                              },
                              child: Column(
                                children: [
                                  Flexible(
                                    flex:9,
                                    child: PageView(
                                      controller:pageController,
                                      onPageChanged: (val){
                                        slideNumber = val;
                                        setState(() {});
                                      },
                                      children:[
                                        Container(
                                          padding: const EdgeInsets.only(right:15),
                                          child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          color:const Color.fromARGB(180, 65, 65, 102),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex:1,
                                                child: Container(
                                                  padding:const EdgeInsets.all(10),
                                                    child: ClipRRect(borderRadius:BorderRadius.circular(13),child: const Image(image:AssetImage("assets/logo.jpg"))))),
                                              Flexible(
                                                flex:3,
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                                                  child: const Text(
                                                      "answering all the security question will help you when you forgot the password",
                                                      style:TextStyle(
                                                        color:Colors.white60,
                                                        fontWeight:FontWeight.w400,
                                                      ),

                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(right:15),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            color:const Color.fromARGB(180, 65, 65, 102),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                    flex:1,
                                                    child: Container(
                                                        padding:const EdgeInsets.all(10),
                                                        child: ClipRRect(borderRadius:BorderRadius.circular(13),child: const Image(image:AssetImage("assets/logo.jpg"))))),
                                                Flexible(
                                                  flex:3,
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                                                    child: const Text(
                                                      "prefer secure algorithm to ensure good encryption speed and considerable amount of encryption strength",
                                                      style:TextStyle(
                                                        color:Colors.white60,
                                                        fontWeight:FontWeight.w400,
                                                      ),

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(right:15),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            color:const Color.fromARGB(180, 65, 65, 102),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                    flex:1,
                                                    child: Container(
                                                        padding:const EdgeInsets.all(10),
                                                        child: ClipRRect(borderRadius:BorderRadius.circular(13),child: const Image(image:AssetImage("assets/logo.jpg"))))),
                                                Flexible(
                                                  flex:3,
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                                                    child: const Text(
                                                      "type 112233 and press equal to ( = ) in calculator when you forgot the password",
                                                      style:TextStyle(
                                                        color:Colors.white60,
                                                        fontWeight:FontWeight.w400,
                                                      ),

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(right:15),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            color:const Color.fromARGB(180, 65, 65, 102),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                    flex:1,
                                                    child: Container(
                                                        padding:const EdgeInsets.all(10),
                                                        child: ClipRRect(borderRadius:BorderRadius.circular(13),child: const Image(image:AssetImage("assets/logo.jpg"))))),
                                                Flexible(
                                                  flex:3,
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                                                    child: const Text(
                                                      "Images and videos restored from camera will be stored in CameraByHMF in DCIM folder",
                                                      style:TextStyle(
                                                        color:Colors.white60,
                                                        fontWeight:FontWeight.w400,
                                                      ),

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(right:15),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            color:const Color.fromARGB(180, 65, 65, 102),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                    flex:1,
                                                    child: Container(
                                                        padding:const EdgeInsets.all(10),
                                                        child: ClipRRect(borderRadius:BorderRadius.circular(13),child: const Image(image:AssetImage("assets/logo.jpg"))))),
                                                Flexible(
                                                  flex:3,
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                                                    child: const Text(
                                                      "Your files are stored in .hmf folder in root storage, don't delete the folder and its files",
                                                      style:TextStyle(
                                                        color:Colors.white60,
                                                        fontWeight:FontWeight.w400,
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
                                  Flexible(
                                    flex:1,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                   children:[
                                     Icon(Dot.dot,color:(slideNumber == 0) ? Colors.white : Colors.white60,size: 20),
                                     Icon(Dot.dot,color:(slideNumber == 1) ? Colors.white : Colors.white60,size:20),
                                     Icon(Dot.dot,color:(slideNumber == 2) ? Colors.white : Colors.white60,size:20),
                                     Icon(Dot.dot,color:(slideNumber == 3) ? Colors.white : Colors.white60,size:20),
                                     Icon(Dot.dot,color:(slideNumber == 4) ? Colors.white : Colors.white60,size:20),
                                  ])
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              ),
              Flexible(
                flex:7,
                child: Container(//this children is for grid view //the children is scrollView
                  height:UiForHome.scrollViewContHeight(context),//scrollView height
                  width:UiForHome.scrollViewContWidth(context),//scrollView width
                  padding:EdgeInsets.symmetric(horizontal:UiForHome.scrollViewHorPadding),
                  child: ScrollConfiguration(//scrollView (for hiding scroll)
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowIndicator();
                        return false;
                      },
                      child: SingleChildScrollView(//scrollView main
                        child:Column(//column
                          children:[
                            Row(//1st row
                              children: [
                                UiForHome.cardDesign(context,icon:Images.picture,text:"images",onTap:"images",color:const Color(0xffbf00c9),),//image
                                SizedBox(width:UiForHome.rowGapSizedBoxWidth(context)),//gap
                                UiForHome.cardDesign(context,icon:Icons.video_collection_sharp,text:"videos",onTap:"videos",color:const Color(0xff9ea100),),//video
                              ],
                            ),
                            SizedBox(height:UiForHome.columnGapSizedBoxHeight),
                            Row(
                              children:[
                                UiForHome.cardDesign(context,icon:Icons.library_music_rounded,text:"audio",onTap:"audios",color: const Color(0xff004bab),),//music
                                SizedBox(width:UiForHome.rowGapSizedBoxWidth(context)),//gap
                                UiForHome.cardDesign(context,icon:Icons.file_copy_rounded,text:"all files",onTap:"all files",color:const Color(0xff00a13e),),//all files
                              ],
                            ),
                            SizedBox(height:UiForHome.columnGapSizedBoxHeight),
                            Row(
                              children: [
                                UiForHome.cardDesign(context,icon:Icons.picture_as_pdf_sharp,text:"pdf",onTap:"pdf",color:const Color(0xff8c0056)),//pdf
                                SizedBox(width:UiForHome.rowGapSizedBoxWidth(context)),//gap
                                UiForHome.cardDesign(context,icon:Excel.file_excel,text:"excel",onTap:"excel",color:const Color(0xff65008c),)//excel
                              ],
                            ),
                            SizedBox(height:UiForHome.columnGapSizedBoxHeight),
                            Row(
                              children: [
                                UiForHome.cardDesign(context,icon:ContactCalender.perm_contact_calendar,text:"contacts",onTap:"contacts",color:const Color(0xffb56a00),),//contact
                                SizedBox(width:UiForHome.rowGapSizedBoxWidth(context)),//gap
                                UiForHome.cardDesign(context,icon:Icons.event_note_sharp,text:"secret diary",onTap:"secret diary",color:const Color(0xff44753f),),//diary
                              ],
                            ),
                            SizedBox(height:UiForHome.columnGapSizedBoxHeight),
                            Row(
                              children: [
                                UiForHome.cardDesign(context,icon:Icons.camera_alt_rounded,text:"camera",onTap:"camera",color:const Color(0xff85424c),),//camera
                                SizedBox(width:UiForHome.rowGapSizedBoxWidth(context)),//gap
                                UiForHome.cardDesign(context,icon:"",text:"about",onTap:"about",color:const Color(0xff918b50),),//notes
                              ],
                            ),
                          ],
                        ),
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
}