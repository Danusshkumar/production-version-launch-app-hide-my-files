import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import "package:file_picker/file_picker.dart";
import "dart:io";
import "dart:math";
import 'dart:convert';
import "dart:typed_data";
import 'package:path/path.dart' as path;// providing name and extension from path
import "package:file_picker/file_picker.dart";
import 'package:launch_app/myFilePicker.dart';
import "package:image_picker/image_picker.dart";
import "package:media_scanner/media_scanner.dart";
import "package:launch_app/universalProperties.dart";
import "encryption_algorithms.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import 'loader.dart';
import 'other_functions.dart';

class FilePageSupport{
  static var mainDirectory = "storage/emulated/0";
  static late double fileSizeInKB;
  static late double fileSizeInMB;
  static late double fileSizeInGB;
  static String fileSize = "";

  static late File ogFile;//original file
  static late File hdFile;//hidden file
  static var selectedFilesPathList = [];
  static late List imgFolderList = Directory("$mainDirectory/.hmf/!important folder/fileInfo.json").listSync();//list of files from imgFolder
  static late int noOfFile = imgFolderList.length;//no of files in imgFolder ==> this is not from json files taken directly from folder
  static var floatingActionButtonColor = const Color(0xff32324f);
  static var floatingActionButtonIcon = const Icon(
    Icons.add,
    size: 35,
    color: Colors.white60,
  );
  static var imgExtensions = ['JPG','PNG','GIF','WEBP','TIFF','PSD','RAW','BMP','HEIF','INDD','JPEG'];
  static var vidExtensions = ['MP4','MOV','WMV','AVI','AVHD','FLV','F4V''SWF','MKV','WEBM','HTML5','MPEG-2'];
  static var audExtensions = ['MP3','AAC','OGG','FLAC','ALAC','WAV','AIFF','DSD','PCM','M4A'];
  static var pdfExtensions = ['PDF'];
  static var excelExtensions =['XLSX'];
  static   bool allowedExtension({fileType,extension}){
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
  static jsonToUiList({pageType}){
    var jsonToUiList = [];
    var jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());
    for(int i = 0;i<jsonList.length;i++){
      if(allowedExtension(fileType:pageType,extension:jsonList[i]['extension'])){
        jsonToUiList.add(jsonList[i]);
      }
    }
    return jsonToUiList;
  }
  static String computeSize(File ogFile) {
    int sizeInBytes = ogFile.lengthSync();
    fileSize = "${sizeInBytes.toStringAsFixed(2)} B";
    if (sizeInBytes > 1024) {
      fileSizeInKB = sizeInBytes / 1024;
      fileSize = "${fileSizeInKB.toStringAsFixed(2)} KB";
      if (fileSizeInKB > 1024) {
        fileSizeInMB = fileSizeInKB / 1024;
        fileSize = "${fileSizeInMB.toStringAsFixed(2)} MB";
        if (fileSizeInMB > 1024) {
          fileSizeInGB = fileSizeInMB / 1024;
          fileSize = "${fileSizeInGB.toStringAsFixed(2)} GB";
        }
      }
    }
    return fileSize;
  }
  static randomNameGenerator(){
    return "!important file ${Random().nextInt(1000000000).toString()}_${String.fromCharCode(Random().nextInt(26)+97)}${String.fromCharCode(Random().nextInt(26)+97)}${Random().nextInt(10000)}";
  }
  static Future<int> onPressedAddButton({context,fileType,origin,cameraType}) async {
    var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
    var mainJson = jsonDecode(mainInfo.readAsStringSync());
    //adding files // this is returning an integer only for avoiding errors
    if(origin == "file") {
      selectedFilesPathList = await Navigator.push(context, MaterialPageRoute(
          builder: (context) => MyFilePicker(fileType: fileType)));
    }
    else if(origin == "camera") {
        var camFileName = "";
        mainJson = jsonDecode(mainInfo.readAsStringSync());
        var camFileNameOption = mainJson['camFileNameOption'];
        var result;
        if(cameraType == "photo") {
          try {
            result = await ImagePicker.platform.pickImage(
                source: ImageSource.camera);
          }
          catch(e){
            result = null;
         }
        }
        else if(cameraType == "video"){
          try {
            result =
            await ImagePicker.platform.pickVideo(source: ImageSource.camera);
          }
          catch(e){
            result = null;
          }
        }

        var randomName = "IMG_${Random().nextInt(1000000)}";
        if(result != null) {
          var camFile = File(result.path);
          var camFileExtension = path.extension(camFile.path);
          if(camFileNameOption == "self") {
            try {
              camFileName = await CameraFunction.NamingToFile(context: context);
            }
            catch(e){
              camFileName = randomName;
            }
            if(camFileName == ""){
              camFileName = randomName;
            }
          }
          else if(camFileNameOption == "auto"){
            camFileName = randomName;
          }          await camFile.copy("$mainDirectory/DCIM/CameraByHMF/$camFileName$camFileExtension");
          await camFile.delete();
          selectedFilesPathList = ["$mainDirectory/DCIM/CameraByHMF/$camFileName$camFileExtension"];
        }
      }
    print("Here at file functions.dart ==> $selectedFilesPathList");
    if(selectedFilesPathList.isNotEmpty) {
      await EasyLoading.show(status:"encrypting...");
      //await Navigator.push(context, MaterialPageRoute(builder: (context) => Loader(selectedFilesList: selectedFilesPathList,origin:origin)));
      for(int i = 0;i<selectedFilesPathList.length;i++){
        ogFile = File(selectedFilesPathList[i]);
        String fileSize = FilePageSupport.computeSize(ogFile);
        //this will calculate the size
        //code for calculating size ends here
        //entering the values into json file for UI updation ==> the info about file name,size and extension are sent from here
        var tempName = randomNameGenerator();
        await JsonOperation.jsonStore({"name":path.basenameWithoutExtension(ogFile.path),"extension":path.extension(ogFile.path).split(".").last.toUpperCase(),"path":ogFile.path,"size":fileSize,"tempName":tempName,"encryptionType":mainJson["encryptionType"]},origin:origin,);
        //extension ==> extension from file path ==> removing . ==> converting into uppercase
        //encryption goes here
        var encryptedFile;
        await ogFile.rename("$mainDirectory/.hmf/$tempName.hmf");

        if(mainJson["encryptionType"] == "no encryption"){
          encryptedFile = await NoEncryption.encryptFunc(File("$mainDirectory/.hmf/$tempName.hmf"));
        }
        else if(mainJson["encryptionType"] == "secure encryption"){
          encryptedFile = await MildEncryption.encryptFunc(File("$mainDirectory/.hmf/$tempName.hmf"));
        }
        else if(mainJson["encryptionType"] == "ultra secure encryption"){
          encryptedFile = await AESEncryption.encryptFunc(File("$mainDirectory/.hmf/$tempName.hmf"));
        }
        //await encryptedFile.copy("$mainDirectory/.hmf/$tempName.hmf");//copying encrypted file to imgFolder inside .hmf
        //await ogFile.delete();//deleting original file
        MediaScanner.loadMedia(path:selectedFilesPathList[i]);
      }
      EasyLoading.dismiss();
      Fluttertoast.showToast(
        msg: (selectedFilesPathList.length != 1) ? "${selectedFilesPathList.length} files added successfully" : "1 file added successfully",
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.SNACKBAR ,
        backgroundColor: const Color.fromARGB(80, 0, 0, 0),
        textColor: const Color(0xffdbdbdb),// location
      );
    }//if statement ends here
    //there is no else statement
    return 0;
  }
  static onFileSelectionForRestore({index,isSelected,selectedFilesList,showCheckBox,origin}){
    var jsonList;
    if(origin == "file") {
      jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync()); //list from json file here
    }
    else{
      jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync());
    }
    if(showCheckBox) {
      if (isSelected[index]) {
        selectedFilesList.add(jsonList[index]['path']);
      } //selection
      else {
        selectedFilesList.remove(jsonList[index]['path']);
      } //deselection
      print(selectedFilesList);
    }
  }
  static onPressedRestoreButton({context,selectedFilesList,origin}) async {
    await EasyLoading.show(status:"decrypting...");
    var jsonList;
    //Navigator.push(context,MaterialPageRoute(builder:(context)=> Loader(selectedFilesList: selectedFilesList,)));
    for(var i = 0;i < selectedFilesList.length;i++){
      if(origin == "file") {
        jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());
      }
      else if(origin == "camera"){
        jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync());
      }
      var hdFileName = "";
      var fileEncType;
      for(int j = 0;j<jsonList.length;j++){
        if(jsonList[j]["path"]==selectedFilesList[i]){
          hdFileName = jsonList[j]["tempName"];
          fileEncType = jsonList[j]["encryptionType"];
        }
      }
      var decryptedFile;
      if(fileEncType == "no encryption"){
        decryptedFile = await NoEncryption.decryptFunc(File("$mainDirectory/.hmf/$hdFileName.hmf"));
      }
      else if(fileEncType == "secure encryption"){
        decryptedFile = await MildEncryption.decryptFunc(File("$mainDirectory/.hmf/$hdFileName.hmf"));
      }
      else if(fileEncType == "ultra secure encryption"){
        decryptedFile = await AESEncryption.decryptFunc(File("$mainDirectory/.hmf/$hdFileName.hmf"));
      }
      if(origin == "file") {
        print(selectedFilesList[i]);
        await decryptedFile.copy(selectedFilesList[i]);
      }
      else{
        await decryptedFile.copy(selectedFilesList[i]);
      }
      await JsonOperation.jsonRemove(path.basenameWithoutExtension(selectedFilesList[i]),origin:origin);
      //await decryptedFile.copy(selectedFilesList[i]);//selectedFilesList contains original file's path
      await decryptedFile.delete();
      MediaScanner.loadMedia(path:selectedFilesList[i]);
      EasyLoading.dismiss();
    }
    Fluttertoast.showToast(
      msg: (selectedFilesList.length != 1) ? "${selectedFilesList.length} files restored successfully" : "1 file restored successfully",
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.SNACKBAR ,
      backgroundColor: const Color.fromARGB(80, 0, 0, 0),
      textColor: const Color(0xffdbdbdb),// location
    );
    selectedFilesList = [];
  }
  static onPressedDeleteButton({selectedFilesList,origin}) async {
    var jsonList;
    for(var i = 0;i<selectedFilesList.length;i++){
      if(origin == "file") {
        jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/fileInfo.json").readAsStringSync());
      }
      else if(origin == "camera"){
        jsonList = jsonDecode(File("$mainDirectory/.hmf/!important folder/camInfo.json").readAsStringSync());
      }
      var hdFileName = "";
      for(int j = 0;j<jsonList.length;j++){
        if(jsonList[j]['path'] == selectedFilesList[i]){
          hdFileName = jsonList[j]['tempName'];
        }
      }
      await JsonOperation.jsonRemove(path.basenameWithoutExtension(selectedFilesList[i]),origin:origin);
      var deleteFile = File("$mainDirectory/.hmf/$hdFileName.hmf");
      await deleteFile.delete();
    }
    Fluttertoast.showToast(
      msg: (selectedFilesList.length != 1) ? "${selectedFilesList.length} files deleted successfully" : "1 file deleted successfully",
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.SNACKBAR ,
      backgroundColor: const Color.fromARGB(80, 0, 0, 0),
      textColor: const Color(0xffdbdbdb),// location
    );
    selectedFilesList = [];
  }
}



/*
static Future<int> onPressedAddButton({context,fileType}) async {//adding files // this is returning an integer only for avoiding errors

    selectedFilesPathList = await Navigator.push(context,MaterialPageRoute(builder: (context) => MyFilePicker(fileType:fileType)));
    print("Here at file functions.dart ==> $selectedFilesPathList");
    if(selectedFilesPathList.isNotEmpty) {
      for(int i = 0;i<selectedFilesPathList.length;i++){
        ogFile = File(selectedFilesPathList[i]);
        String fileSize = FilePageSupport.computeSize(ogFile);
        //this will calculate the size
        //code for calculating size ends here
        //entering the values into json file for UI updating ==> the info about file name,size and extension are sent from here
        var tempName = randomNameGenerator();
        await MyEncryption.jsonStore({"name":basenameWithoutExtension(ogFile.path),"extension":extension(ogFile.path).split(".").last.toUpperCase(),"path":ogFile.path,"size":fileSize,"tempName":tempName});
        //extension ==> extension from file path ==> removing . ==> converting into uppercase
        //encryption goes here
        var encryptedFile = await MyEncryption.encryptFunc(ogFile);
        await encryptedFile.copy("$mainDirectory/.hmf/$tempName.hmf");//copying encrypted file to imgFolder inside .hmf
        await ogFile.delete();//deleting original file
      }
    }//if statement ends here
    //there is no else statement
    return 0;
  }
 */






