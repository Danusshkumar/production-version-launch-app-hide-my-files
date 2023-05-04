import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_manager/file_manager.dart';

import 'app_icons.dart';

class MyFilePicker extends StatefulWidget {
  final String fileType;
  const MyFilePicker({Key? key, required this.fileType}) : super(key: key);

  @override
  State<MyFilePicker> createState() => _MyFilePickerState();
}

class _MyFilePickerState extends State<MyFilePicker> {
  static late FileManagerController controller ;
  var previousDirectoryEntity;
  var selectedFilesPath = [];
  static var imgExtensions = ['JPG','PNG','GIF','WEBP','TIFF','PSD','RAW','BMP','HEIF','INDD','JPEG'];
  static var vidExtensions = ['MP4','MOV','WMV','AVI','AVHD','FLV','F4V''SWF','MKV','WEBM','HTML5','MPEG-2'];
  static var audExtensions = ['MP3','AAC','OGG','FLAC','ALAC','WAV','AIFF','DSD','PCM','M4A'];
  static var pdfExtensions = ['PDF'];
  static var excelExtensions =['XLSX'];
  var leadingIcon;

  bool allowedExtension({fileType,extension}){
    bool returningBool = false;
    var allowedExtensions;
    if(fileType == "images"){
     allowedExtensions = imgExtensions;
    }
    else if(fileType == "videos"){
      allowedExtensions = vidExtensions;
    }
    else if(fileType == "audios"){
      allowedExtensions = audExtensions;
    }
    else if(fileType == "all files"){
      allowedExtensions = [];
    }
    else if(fileType == "pdf"){
      allowedExtensions = pdfExtensions;
    }
    else if(fileType == "excel"){
      allowedExtensions = excelExtensions;
    }
    for(int i = 0;i<allowedExtensions.length;i++){
      if(extension == allowedExtensions[i]){
        returningBool = true;
      }
    }
    if(fileType == "all files"){returningBool = true;}
    return returningBool;
  }

  @override
  void initState(){
    controller = FileManagerController();
    if(widget.fileType == "images"){
      leadingIcon = const Icon(Icons.image,color:Color(0xffa333ff),size:35);
    }
    else if(widget.fileType == "videos"){
      leadingIcon = const Icon(Icons.video_collection_sharp,color:Color(0xffa333ff),size:35);
    }
    else if(widget.fileType == "audios"){
      leadingIcon= const Icon(Icons.library_music_rounded,color:Color(0xffa333ff),size:35);
    }
    else if(widget.fileType == "all files"){
      leadingIcon= const Icon(Icons.file_copy_rounded,color:Color(0xffa333ff),size:35);
    }
    else if (widget.fileType == "pdf"){
      leadingIcon= const Icon(Icons.picture_as_pdf_sharp,color:Color(0xffa333ff),size:35);
    }
    else if(widget.fileType == "excel"){
      leadingIcon=const Icon(Excel.file_excel,color:Color(0xffa333ff),size:35);
    }
    super.initState();
  }
  var isSelected = List.generate(50,(index)=> false);
  var noOfItemsSelected = 0;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar:AppBar(
            backgroundColor: const Color(0xffa333ff),
            title:const Text(
                "File Picker",
              style:TextStyle(color:Colors.white),
            ),
            leading:IconButton(
              icon:const Icon(Icons.arrow_back_ios_sharp,color:Colors.white),
              onPressed:(){
                Navigator.pop(context,[]);
              },
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Flexible(
                  flex:1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8,0,0,0),
                          child: TextButton.icon(
                              icon:const Icon(Icons.arrow_back_ios_sharp,size:18,color:Color(0xffa333ff)),
                              label:const Text("BACK",style:TextStyle(color:Color(0xffa333ff))),
                              onPressed:(){
                                if(previousDirectoryEntity == null){
                                  Navigator.pop(context,[]);
                                }
                                else {
                                  controller.openDirectory(previousDirectoryEntity);
                                }
                                setState((){});
                              }
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,8,0),
                          child: Row(
                            children: [
                              TextButton(onPressed:(){
                                Navigator.pop(context,selectedFilesPath);
                              },child:const Text("SELECT",style:TextStyle(color:Color(0xffa333ff)))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex:9,
                  child: Container(
                    child:FileManager(
                      controller: controller,
                      builder: (context, snapshot) {
                        List<FileSystemEntity> entities = [];
                        for(int i = 0;i<snapshot.length;i++){
                          if(FileManager.isDirectory(snapshot[i]) && ( FileManager.basename(snapshot[i]) != "data" && FileManager.basename(snapshot[i]) != "obb" )){
                            entities.add(snapshot[i]);
                          }
                          else if(FileManager.isFile(snapshot[i])){
                            var extension = snapshot[i].absolute.toString().split(".").last.substring(0,snapshot[i].absolute.toString().split(".").last.length-1).toUpperCase();
                            if(allowedExtension(fileType:widget.fileType,extension:extension)){
                              print(widget.fileType);
                              entities.add(snapshot[i]);
                            }
                          }
                        }
                        return  GlowingOverscrollIndicator(
                          color:const Color(0xffa333ff),
                          axisDirection: AxisDirection.down,
                          child: ListView.builder(
                            itemCount: entities.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: FileManager.isFile(entities[index])
                                      ? leadingIcon
                                      : Icon(Icons.folder,color:const Color(0xffe8da15),size:MediaQuery.of(context).size.height*0.04),//30),
                                  title: Text(FileManager.basename(entities[index])),
                                  subtitle:(FileManager.isFile(entities[index])) ? Text(entities[index].absolute.toString().split(".").last.substring(0,entities[index].absolute.toString().split(".").last.length-1).toUpperCase()) : Text("FOLDER"),
                                  onTap: () {
                                    if (FileManager.isDirectory(entities[index])) {
                                      previousDirectoryEntity = entities[index];
                                      controller.openDirectory(entities[index]);   // open directory
                                    } else {
                                      isSelected[index] = !isSelected[index];
                                      if(isSelected[index]){
                                        noOfItemsSelected++;
                                        var absolutePath = entities[index].absolute.toString();
                                        selectedFilesPath.add(absolutePath.substring(7,absolutePath.length-1));//actually it is 6 for removing single
                                        //quotation it's 7 and length - 1
                                      }
                                      else{
                                        noOfItemsSelected--;
                                        var absolutePath = entities[index].absolute.toString();
                                        selectedFilesPath.remove(absolutePath.substring(7,absolutePath.length-1));
                                      }
                                      print(selectedFilesPath);
                                      var initPath = controller.getCurrentPath;
                                      controller.setCurrentPath  = "";
                                      if(initPath != "/storage/emulated/0") {// if the directory is main directory
                                        controller.openDirectory(previousDirectoryEntity);
                                      }
                                      else {
                                        setState((){});
                                      }
                                    }
                                  },
                                  trailing:(FileManager.isFile(entities[index])) ? Checkbox(
                                    activeColor: Color(0xffa333ff),
                                    value:isSelected[index],
                                    onChanged:(bool? val){
                                      isSelected[index] = !isSelected[index];
                                      if(isSelected[index]){
                                        noOfItemsSelected++;
                                        var absolutePath = entities[index].absolute.toString();
                                        selectedFilesPath.add(absolutePath.substring(7,absolutePath.length-1));//actually it is 6 for removing single
                                        //quotation it's 7 and length - 1
                                      }
                                      else{
                                        noOfItemsSelected--;
                                        var absolutePath = entities[index].absolute.toString();
                                        selectedFilesPath.remove(absolutePath.substring(7,absolutePath.length-1));
                                      }
                                      print(selectedFilesPath);
                                      var initPath = controller.getCurrentPath;
                                      controller.setCurrentPath  = "";
                                      if(initPath != "/storage/emulated/0") {// if the directory is main directory
                                        controller.openDirectory(previousDirectoryEntity);
                                      }
                                      else {
                                        setState((){});
                                      }
                                    },
                                  ) : null,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      emptyFolder: const Center(child:Text("This folder is empty"),),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
