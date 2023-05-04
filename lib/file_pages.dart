import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//for UI
import 'package:launch_app/ui_for_file_pages.dart';

//for file operations
import 'package:launch_app/file_functions.dart';
import "dart:io";//for Files and its operation
import 'dart:convert';//for json parsing
import 'package:path/path.dart';// providing name and extension from path
import 'package:flutter/foundation.dart';

import 'app_icons.dart';


class FilePages extends StatefulWidget {//main stateful widget
  final String pageType;
  const FilePages({Key? key, required this.pageType}) : super(key: key);

  @override
  State<FilePages> createState() => _FilePagesState();
}

class _FilePagesState extends State<FilePages> {//main state
  static var mainDirectory = "storage/emulated/0";
  // this properties are accessed globally
  //main function goes here
  //no of files in imgFolder ==> this is not from json files taken directly from folder
  List selectedFilesList = [];
  var showCheckBox = false;//this is for checkBox selection
  var jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
  var isSelected = List.filled(jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync()).length,false);//this is for selecting the checkbox
  var floatActBtn = null;// this is the widget when the file is null (floating action btn)
  var contentWidget = null;
  var restoreBtnState = null;
  var deleteBtnState = null;
  var cmnCheckBoxValue = false;
  var cmnCheckBoxTxt = "select all";
  var onNoFilesTxt;
  var leadingIcon;
  var heading;
  var themeUI;
  
  @override
  void initState(){
    if(widget.pageType == "images"){
      leadingIcon = const Icon(Icons.image,color:Color(0xaabf00c9),size:35);
      onNoFilesTxt = "Images";
      heading = "Images";
    }
    else if(widget.pageType == "videos"){
      leadingIcon = const Icon(Icons.video_collection_sharp,color:Color(0xff9ea100),size:35);
      onNoFilesTxt = "Videos";
      heading = "Videos";
    }
    else if(widget.pageType == "audios"){
      leadingIcon= const Icon(Icons.library_music_rounded,color:Color(0xff004bab),size:35);
      onNoFilesTxt = "Audio";
      heading = "Audio files";
    }
    else if(widget.pageType == "all files"){
      leadingIcon= const Icon(Icons.file_copy_rounded,color:Color(0xff00a13e),size:35);
      onNoFilesTxt = "Files";
      heading = "Files";
    }
    else if (widget.pageType == "pdf"){
      leadingIcon= const Icon(Icons.picture_as_pdf_sharp,color:Color(0xff8c0056),size:35);
      onNoFilesTxt = "PDF files";
      heading = "PDF";
    }
    else if(widget.pageType == "excel"){
      leadingIcon=const Icon(Excel.file_excel,color:Color(0xff65008c),size:35);
      onNoFilesTxt = "Excel files";
      heading = "Excel";
    }
    
    // for themes
    
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
    jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
    var jsonToUiList = FilePageSupport.jsonToUiList(pageType:widget.pageType);
    print(jsonList.length);
    print(isSelected.length);
    print("selectedFilesList $selectedFilesList");
    // pseudo code
    //files 0
    //files non 0
    //first two state ==> showCheckBox aah illaya
    //second if showcheckbox ==> 0 files naa button disable karo
    //next uh flexible karonga

    if(jsonToUiList.length == 0){
      floatActBtn = null;
      contentWidget = Center(//center
        child: Column(//children goes inside this
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            ElevatedButton(//plus button
                onPressed:() async {
                  await FilePageSupport.onPressedAddButton(context: context,fileType:widget.pageType,origin:"file");
                  jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
                  jsonToUiList = FilePageSupport.jsonToUiList(pageType:widget.pageType);
                  isSelected = List.generate(jsonToUiList.length, (index) => false);
                  setState((){});
                },// Here we are doing the file operation
                style:themeUI.styleForAddBtn(context),
                child:Icon(Icons.add,size:MediaQuery.of(context).size.height * 0.1,color:Colors.white60,)
            ),
            const SizedBox(height:25),//gap
            Text(//text
                "No $onNoFilesTxt added",
              style:themeUI.filesNoFilesTxtStyle,
            ),
          ],
        ),
      );
    }
    else{
      if(!showCheckBox){
        floatActBtn = FloatingActionButton(
          backgroundColor: FilePageSupport.floatingActionButtonColor,
          child: FilePageSupport.floatingActionButtonIcon,
          onPressed: () async {
            await FilePageSupport.onPressedAddButton(context: context,fileType:widget.pageType,origin:"file");
            jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
            jsonToUiList = FilePageSupport.jsonToUiList(pageType:widget.pageType);
            isSelected = List.generate(jsonToUiList.length, (index) => false);
            setState(() {});
          }, // Here we are doing the file operation
        ); //floating action button will be visible
        contentWidget = Container(//content widget will be listTile
            child: Column(
                children:[
                  Flexible(
                    child: Container(//listTile goes here
                      child: ScrollConfiguration(// here is the list
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: GlowingOverscrollIndicator(
                          color: const Color(0xff32324f),
                          axisDirection: AxisDirection.down,
                          child: ListView.builder(//builder for listView
                              itemCount:jsonToUiList.length,//total Length is from jsonList
                              itemBuilder:(context,index){
                                var encryptionTxt;
                                if(jsonToUiList[index]['encryptionType'] == "no encryption"){
                                  encryptionTxt = "no encryption";
                                }
                                else if(jsonToUiList[index]['encryptionType'] == "secure encryption"){
                                  encryptionTxt = "secure";
                                }
                                else if(jsonToUiList[index]['encryptionType'] == "ultra secure encryption"){
                                  encryptionTxt = "ultra secure";
                                }
                                return InkWell(
                                  onLongPress:(){
                                    setState((){
                                      showCheckBox = true;
                                    });
                                  },
                                  child: Column(
                                    children:[
                                      ListTile(
                                        isThreeLine:true,
                                        leading: showCheckBox ?
                                        Checkbox(
                                          activeColor:Colors.blue,
                                          value:isSelected[index],
                                          onChanged:(bool? val){
                                            isSelected[index] = !isSelected[index];
                                            FilePageSupport.onFileSelectionForRestore(index:index,isSelected: isSelected,selectedFilesList: selectedFilesList,showCheckBox:showCheckBox,origin:"file");
                                            setState((){});
                                          },
                                        )
                                            : leadingIcon,
                                        title:Text(jsonToUiList[index]['name'],overflow: TextOverflow.ellipsis,style:themeUI.fileListTitleTxtStyle),
                                        subtitle:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("size: ${jsonToUiList[index]['size']}",style:themeUI.fileListSubtitleTxtStyle),
                                            Container(padding:const EdgeInsets.symmetric(vertical: 2.0,horizontal: 4.0),decoration: BoxDecoration(color:const Color.fromARGB(205, 227, 227, 227),borderRadius: BorderRadius.circular(15)),child:Center(child: Text(" $encryptionTxt ",style:themeUI.fileListAlgTxtStyle)),),
                                          ],
                                        ),
                                        trailing:Text(jsonToUiList[index]['extension'],style:themeUI.fileListTrailingTxtStyle),
                                        textColor: Colors.white60,
                                        onTap:(showCheckBox) ? (){
                                          isSelected[index] = !isSelected[index];
                                          FilePageSupport.onFileSelectionForRestore(index:index,isSelected: isSelected,selectedFilesList: selectedFilesList,showCheckBox:showCheckBox,origin:"file");
                                          setState((){});
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
                                      const SizedBox(height:10),
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
      else {
        if(listEquals(isSelected,List.generate(isSelected.length,(i) => true))){
          cmnCheckBoxValue = true;
          cmnCheckBoxTxt = "deselect all";
          setState(() {});
        }
        else if(listEquals(isSelected,List.generate(isSelected.length,(i) => false))){
          cmnCheckBoxValue = false;
          cmnCheckBoxTxt = "select all";
          setState(() {});
        }
        if (selectedFilesList.isEmpty) {
          restoreBtnState = null;
          deleteBtnState = null;
          setState(() {});
        }
        else {
          restoreBtnState = () {
            Navigator.of(context).pop();
            FilePageSupport.onPressedRestoreButton(context:context,selectedFilesList: selectedFilesList,origin:"file");
            jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
            jsonToUiList = FilePageSupport.jsonToUiList(pageType:widget.pageType);
            isSelected = List.generate(jsonToUiList.length, (index) => false);
            selectedFilesList = [];
          };
          deleteBtnState = (){
            Navigator.of(context).pop();
            FilePageSupport.onPressedDeleteButton(selectedFilesList: selectedFilesList,origin:"file");
            jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());//list from json file here
            jsonToUiList = FilePageSupport.jsonToUiList(pageType:widget.pageType);
            isSelected = List.generate(jsonToUiList.length, (index) => false);
            selectedFilesList = [];
          };
        }
        floatActBtn = null;
        contentWidget = Container( //content widget will be listTile
            child: Column(
                children: [
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
                                  for(int i = 0;i<jsonToUiList.length;i++) {
                                    selectedFilesList.add(jsonToUiList[i]['path']);
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
                  ), //this will pop up when files are selected
                  Flexible(
                    flex: 16,
                    child: Container( //listTile goes here
                      child: ScrollConfiguration( // here is the list
                        behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false),
                        child: GlowingOverscrollIndicator(
                          color:const Color(0xff32324f),
                          axisDirection: AxisDirection.down,
                          child: ListView.builder( //builder for listView
                              itemCount: jsonToUiList.length,
                              //total Length is from jsonList
                              itemBuilder: (context, index) {
                                var encryptionTxt;
                                if(jsonToUiList[index]['encryptionType'] == "no encryption"){
                                  encryptionTxt = "no encryption";
                                }
                                else if(jsonToUiList[index]['encryptionType'] == "secure encryption"){
                                  encryptionTxt = "secure";
                                }
                                else if(jsonToUiList[index]['encryptionType'] == "ultra secure encryption - 1"){
                                  encryptionTxt = "ultra secure 1";
                                }
                                else if(jsonToUiList[index]['encryptionType'] == "ultra secure encryption - 2"){
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
                                          activeColor: Colors.blue,
                                          value: isSelected[index],
                                          onChanged: (bool? val) {
                                            isSelected[index] =
                                            !isSelected[index];
                                            FilePageSupport
                                                .onFileSelectionForRestore(
                                                index: index,
                                                isSelected: isSelected,
                                                selectedFilesList: selectedFilesList,
                                                showCheckBox: showCheckBox,
                                              origin: "file"
                                            );
                                            setState(() {});
                                          },
                                        )
                                            : const Icon(
                                            Icons.image, color: Color(0xff25a2e6),
                                            size: 40),
                                        title: Text(jsonToUiList[index]['name'],overflow: TextOverflow.ellipsis,style:themeUI.fileListTitleTxtStyle),
                                        subtitle: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("size: ${jsonToUiList[index]['size']}",style:themeUI.fileListSubtitleTxtStyle),
                                            Container(padding:EdgeInsets.symmetric(vertical: 2.0,horizontal: 4.0),decoration: BoxDecoration(color:const Color.fromARGB(205, 227, 227, 227),borderRadius: BorderRadius.circular(15)),child:Center(child: Text(" $encryptionTxt ",style:themeUI.fileListAlgTxtStyle)),),
                                          ],
                                        ),
                                        trailing: Text(
                                            jsonToUiList[index]['extension'],style:themeUI.fileListTrailingTxtStyle),
                                        onTap:() {
                                          isSelected[index] = !isSelected[index];
                                          FilePageSupport
                                              .onFileSelectionForRestore(
                                              index: index,
                                              isSelected: isSelected,
                                              selectedFilesList: selectedFilesList,
                                              showCheckBox: showCheckBox,
                                            origin:"file"
                                          );
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
                ]
            )
        );
      }
    }
    return SafeArea(// here we are building the UI
      child:Scaffold(
          appBar:AppBar(//appBar
            title:Text(
              heading,
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
            backgroundColor: themeUI.appBarColor,
            elevation:4,
          ),
          body:Container(//main container
            decoration:themeUI.filePageContainerDecoration(),
            height:MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child: contentWidget,
          ),
          floatingActionButton: floatActBtn //floating action button
      ),
    );
  }
}























