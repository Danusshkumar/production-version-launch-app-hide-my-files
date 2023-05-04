import 'dart:convert';
import 'dart:math';


import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import "package:launch_app/file_functions.dart";
import "package:permission_handler/permission_handler.dart";
import "package:image_picker/image_picker.dart";
import "dart:io";
import "package:launch_app/universalProperties.dart";
import "package:launch_app/ui_for_file_pages.dart";
import "video_icons.dart";
import "package:fluttertoast/fluttertoast.dart";

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  static var mainDirectory = "storage/emulated/0";
  static var camInfo = File("$mainDirectory/.hmf/!important folder/camInfo.json");
  static var camInfoList = jsonDecode(camInfo.readAsStringSync());
  var showCheckBox = false;
  var isSelected = List.filled(jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync()).length,false);
  var contentWidget;

  static var selectedFilesList = [];
  static var cmnCheckBoxValue = false;
  static var cmnCheckBoxTxt = "select all";
  static var deleteBtnState = null;
  static var restoreBtnState = null;
  var themeUI;
  var floatActBtn;
  //selectedFilesList passing is ignored for now
  
  @override
  void initState() {

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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    camInfoList =  jsonDecode(camInfo.readAsStringSync());
    floatActBtn = SpeedDial(
      childrenButtonSize: Size(themeUI.floatingChildSize,themeUI.floatingChildSize),
      buttonSize: Size(themeUI.floatingChildSize,themeUI.floatingChildSize),
      icon:Icons.add,
      backgroundColor: themeUI.floatingActionButtonColor,
      iconTheme: IconThemeData(color:themeUI.floatingActionIconColor,size:themeUI.floatingActionIconSize),
      overlayColor: themeUI.cameraOverlayColor,
      overlayOpacity: 0.5,
      children:[
        SpeedDialChild(
            backgroundColor: themeUI.floatingActionButtonColor,
            child:Icon(
              Icons.camera_alt_rounded,
              color:themeUI.floatingActionIconColor,
              size:themeUI.floatingChildIconSize,
            ),
            onTap: () async {
              await FilePageSupport.onPressedAddButton(context:context,origin:"camera",cameraType:"photo");
              camInfoList = jsonDecode(camInfo.readAsStringSync());
              isSelected =  List.filled(jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync()).length,false);
              setState(() {});
            }
        ),
        SpeedDialChild(
          backgroundColor: themeUI.floatingActionButtonColor,
          child:Icon(
              Video.videocam,
              color:themeUI.floatingActionIconColor,
              size:themeUI.floatingChildIconSize
          ),
          onTap:() async {
            await FilePageSupport.onPressedAddButton(context:context,origin:"camera",cameraType:"video");
            isSelected =  List.filled(jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync()).length,false);
            camInfoList = jsonDecode(camInfo.readAsStringSync());
            setState(() {});
          },
        )
      ],
    );
    if(camInfoList.isNotEmpty) {
      print(camInfoList);
      if(showCheckBox == false) {
        floatActBtn = SpeedDial(
          childrenButtonSize: Size(themeUI.floatingChildSize,themeUI.floatingChildSize),
          buttonSize: Size(themeUI.floatingChildSize,themeUI.floatingChildSize),
          icon:Icons.add,
          backgroundColor: themeUI.floatingActionButtonColor,
          iconTheme: IconThemeData(color:themeUI.floatingActionIconColor,size:themeUI.floatingActionIconSize),
          overlayColor: themeUI.cameraOverlayColor,
          overlayOpacity: 0.5,
          children:[
            SpeedDialChild(
                backgroundColor: themeUI.floatingActionButtonColor,
                child:Icon(
                  Icons.camera_alt_rounded,
                  color:themeUI.floatingActionIconColor,
                  size:themeUI.floatingChildIconSize,
                ),
                onTap: () async {
                  await FilePageSupport.onPressedAddButton(context:context,origin:"camera",cameraType:"photo");
                  camInfoList = jsonDecode(camInfo.readAsStringSync());
                  isSelected =  List.filled(jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync()).length,false);
                  setState(() {});
                }
            ),
            SpeedDialChild(
              backgroundColor: themeUI.floatingActionButtonColor,
              child:Icon(
                  Video.videocam,
                  color:themeUI.floatingActionIconColor,
                  size:themeUI.floatingChildIconSize
              ),
              onTap:() async {
                await FilePageSupport.onPressedAddButton(context:context,origin:"camera",cameraType:"video");
                isSelected =  List.filled(jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync()).length,false);
                camInfoList = jsonDecode(camInfo.readAsStringSync());
                setState(() {});
              },
            )
          ],
        );
        contentWidget = Container( //content widget will be listTile
            child: Column(
                children: [
                  Flexible(
                    child: Container( //listTile goes here
                      child: ScrollConfiguration( // here is the list
                        behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false),
                        child: GlowingOverscrollIndicator(
                          color:const Color(0xff32324f),
                          axisDirection: AxisDirection.down,
                          child: ListView.builder( //builder for listView
                              itemCount: camInfoList.length,
                              //total Length is from jsonList
                              itemBuilder: (context, index) {
                                var encryptionTxt;
                                if(camInfoList[index]['encryptionType'] == "no encryption"){
                                  encryptionTxt = "no encryption";
                                }
                                else if(camInfoList[index]['encryptionType'] == "secure encryption"){
                                  encryptionTxt = "secure";
                                }
                                else if(camInfoList[index]['encryptionType'] == "ultra secure encryption - 1"){
                                  encryptionTxt = "ultra secure 1";
                                }
                                else if(camInfoList[index]['encryptionType'] == "ultra secure encryption - 2"){
                                  encryptionTxt = "ultra secure 2";
                                }
                                return InkWell(
                                  onLongPress: () {
                                    setState(() {
                                      showCheckBox = true;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: showCheckBox ?
                                        Checkbox(
                                          activeColor:Colors.blue,
                                          value: isSelected[index],
                                          onChanged: (bool? val) {
                                            isSelected[index] =
                                            !isSelected[index];
                                            FilePageSupport
                                                .onFileSelectionForRestore(
                                                index: index,
                                                isSelected: isSelected,
                                                selectedFilesList: [],
                                                showCheckBox: showCheckBox,
                                              origin:"camera"
                                            );
                                            setState(() {});
                                          },
                                        )
                                            : const Icon(
                                            Icons.image, color: Color(0xff25a2e6),
                                            size: 40),
                                        title: Text(camInfoList[index]['name'],
                                          overflow: TextOverflow.ellipsis,),
                                        subtitle: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "size: ${camInfoList[index]['size']}"),
                                            Container(padding:EdgeInsets.symmetric(vertical: 2.0,horizontal: 4.0),decoration: BoxDecoration(color:const Color.fromARGB(205, 227, 227, 227),borderRadius: BorderRadius.circular(15)),child:Center(child: Text(" $encryptionTxt ",style:themeUI.fileListAlgTxtStyle)),),
                                          ],
                                        ),
                                        trailing: Text(
                                            camInfoList[index]['extension']),
                                        textColor: Colors.white60,
                                        onTap: (showCheckBox) ? () {
                                          isSelected[index] = !isSelected[index];
                                          FilePageSupport
                                              .onFileSelectionForRestore(
                                              index: index,
                                              isSelected: isSelected,
                                              selectedFilesList: [],
                                              showCheckBox: showCheckBox,
                                            origin:"camera"
                                          );
                                          setState(() {});
                                        } : (){
                                          Fluttertoast.showToast(
                                            msg: "you cannot preview the encrypted file",
                                            toastLength: Toast.LENGTH_SHORT, // length
                                            gravity: ToastGravity.SNACKBAR ,
                                            backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                                            textColor: const Color(0xffdbdbdb),// location
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            )
        );
      }
      else{
        floatActBtn = null;
        if(selectedFilesList.isEmpty){
          restoreBtnState = null;
          deleteBtnState = null;
        }
        else{
          restoreBtnState = () {
            Navigator.of(context).pop();
            FilePageSupport.onPressedRestoreButton(selectedFilesList: selectedFilesList,origin:"camera");
            camInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
            isSelected = List.generate(camInfoList.length, (index) => false);
            selectedFilesList = [];
          };
          deleteBtnState = (){
            Navigator.of(context).pop();
            FilePageSupport.onPressedDeleteButton(selectedFilesList: selectedFilesList,origin:"camera");
            camInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
            isSelected = List.generate(camInfoList.length, (index) => false);
            selectedFilesList = [];
          };
        }
        if(selectedFilesList.length == camInfoList.length){
          cmnCheckBoxValue = true;
          cmnCheckBoxTxt = "deselect all";
        }
        if(selectedFilesList.isEmpty){
          cmnCheckBoxValue = false;
          cmnCheckBoxTxt = "select all";
        }
        contentWidget = Column(
          children:[
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showCheckBox = false;
                          isSelected = List.generate(isSelected.length,(index)=> false);
                          selectedFilesList = [];
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear,color:Colors.white60),
                      ),
                      const SizedBox(width:10),
                      Text(
                        (selectedFilesList.length == 1) ? "1 file selected" : "${selectedFilesList.length} files selected",
                        style:const TextStyle(
                          color:Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor:Colors.blue,
                        value:cmnCheckBoxValue,
                        onChanged: (bool? val){
                          cmnCheckBoxValue = !cmnCheckBoxValue;
                          if(cmnCheckBoxValue) {
                            isSelected = List.generate(isSelected.length, (index) => true);
                            for(int i = 0;i<camInfoList.length;i++) {
                              selectedFilesList.add(camInfoList[i]['path']);
                            }
                          }
                          else{
                            isSelected = List.generate(isSelected.length, (index) => false);
                            selectedFilesList = [];
                          }
                          setState(() {});
                        },
                      ),
                      Text(cmnCheckBoxTxt,style:const TextStyle(color:Colors.white60,)),
                      const SizedBox(width:5),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex:16,
            child:Container(child:Column(
                  children: [
                    Flexible(
                      child: Container( //listTile goes here
                        child: ScrollConfiguration( // here is the list
                          behavior: ScrollConfiguration.of(context).copyWith(
                              scrollbars: false),
                          child: GlowingOverscrollIndicator(
                            color:const Color(0xff32324f),
                            axisDirection: AxisDirection.down,
                            child: ListView.builder( //builder for listView
                                itemCount: camInfoList.length,
                                //total Length is from jsonList
                                itemBuilder: (context, index) {
                                  var encryptionTxt;
                                  if(camInfoList[index]['encryptionType'] == "no encryption"){
                                    encryptionTxt = "no encryption";
                                  }
                                  else if(camInfoList[index]['encryptionType'] == "secure encryption"){
                                    encryptionTxt = "secure";
                                  }
                                  else if(camInfoList[index]['encryptionType'] == "ultra secure encryption - 1"){
                                    encryptionTxt = "ultra secure 1";
                                  }
                                  else if(camInfoList[index]['encryptionType'] == "ultra secure encryption - 2"){
                                    encryptionTxt = "ultra secure 2";
                                  }
                                  return InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        showCheckBox = true;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: showCheckBox ?
                                          Checkbox(
                                            activeColor:Colors.blue,
                                            value: isSelected[index],
                                            onChanged: (bool? val) {
                                              isSelected[index] = !isSelected[index];
                                              FilePageSupport.onFileSelectionForRestore(
                                                  index: index,
                                                  isSelected: isSelected,
                                                  selectedFilesList: selectedFilesList,
                                                  showCheckBox: showCheckBox,
                                                origin: "camera"
                                              );
                                              setState(() {});
                                            },
                                          )
                                              : const Icon(
                                              Icons.image, color: Color(0xff25a2e6),
                                              size: 40),
                                          title: Text(camInfoList[index]['name'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "size: ${camInfoList[index]['size']}"),
                                              Container(padding:EdgeInsets.symmetric(vertical: 2.0,horizontal: 4.0),decoration: BoxDecoration(color:const Color.fromARGB(205, 227, 227, 227),borderRadius: BorderRadius.circular(15)),child:Center(child: Text(" $encryptionTxt ",style:themeUI.fileListAlgTxtStyle)),),
                                            ],
                                          ),
                                          trailing: Text(
                                              camInfoList[index]['extension']),
                                          textColor: Colors.white60,
                                          onTap:() {
                                            isSelected[index] = !isSelected[index];
                                            FilePageSupport
                                                .onFileSelectionForRestore(
                                                index: index,
                                                isSelected: isSelected,
                                                selectedFilesList: selectedFilesList,
                                                showCheckBox: showCheckBox,
                                              origin:"camera"
                                            );
                                            print(selectedFilesList);
                                            setState(() {});
                                          }
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),),
            ),
            Flexible(
              flex:1,
              child:Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed:deleteBtnState,
                      child:Text("DELETE",style:TextStyle(color:(selectedFilesList.isEmpty) ? Colors.black45:Colors.blue)),
                    ),
                    TextButton(
                        onPressed:restoreBtnState,
                        child:Text("RESTORE",style:TextStyle(color:(selectedFilesList.isEmpty) ? Colors.black45:Colors.blue))
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }
    else{
      print("worked");
      contentWidget = Center(
        child:Text(
            "No photos or videos added",
          style:themeUI.cameraNoFilesTextStyle,
        ),
      );
    }
    return SafeArea(
      child:Scaffold(
        appBar:AppBar(//appBar
          title:Text(
            "Camera",
            style:themeUI.appBarTxtStyle,
          ),
          leading:IconButton(
            icon:const Icon(Icons.arrow_back_ios,size:18),
            onPressed:(){
              selectedFilesList = [];
              Navigator.pop(context);
            }
          ),
          backgroundColor: UiForFilePages.appBarColor,
          elevation:4,
        ),
        body:Container(//main container
          decoration:UiForFilePages.filePageContainerDecoration(),
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: Container(
              child:contentWidget,
          ),
        ),
        floatingActionButton:floatActBtn
      ),
    );
  }
}

