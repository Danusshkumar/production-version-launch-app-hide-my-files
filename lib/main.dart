import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_app/ask_security_questions.dart';
import 'package:launch_app/images.dart';
import 'package:launch_app/home.dart';
import 'dart:io';
import 'package:launch_app/contact_page.dart';
import 'package:launch_app/myFilePicker.dart';
import 'package:launch_app/file_pages.dart';
import 'package:launch_app/images.dart';
import 'package:launch_app/security_questions.dart';
import 'package:launch_app/videos.dart';
import 'package:launch_app/audios.dart';
import 'package:launch_app/allFiles.dart';
import 'package:launch_app/pdf.dart';
import 'package:launch_app/excel.dart';
import 'package:launch_app/notes.dart';
import 'package:launch_app/diary_page.dart';
import 'package:launch_app/diary_selection_page.dart';
import 'package:launch_app/camera.dart';
import "package:launch_app/settings.dart";
import "package:launch_app/calculator.dart";
import 'package:permission_handler/permission_handler.dart';
import "themes and modes.dart";
import 'developer_contact.dart';
import 'about.dart';
import 'package:flutter/services.dart';
import "myFilePicker.dart";
import "loader.dart";

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black.withOpacity(0.5)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

fileCreation() async  {
  var mainDirectory = "storage/emulated/0";
  await Directory("$mainDirectory/.hmf").create();
  await Directory("$mainDirectory/DCIM/CameraByHMF").create();
  await Directory("$mainDirectory/.hmf/!important folder").create();
  var mainInfo = await File("$mainDirectory/.hmf/!important folder/mainInfo.json").create();
  mainInfo.writeAsStringSync("{}");
  var mainInfoMap = jsonDecode(mainInfo.readAsStringSync());
  mainInfoMap = {
    "password":"null",
    "encryptionType":"secure encryption",
    "theme":"dark",
    "camFileNameOption":"auto",
    "security questions":["", "", "",""],
  };
  mainInfo.writeAsStringSync(jsonEncode(mainInfoMap));
  var json = await File("$mainDirectory/.hmf/!important folder/fileInfo.json").create();
  json.writeAsStringSync("[]");
  var cInfo = await File("$mainDirectory/.hmf/!important folder/cInfo.json").create();
  cInfo.writeAsStringSync("[]");
  var nInfo = await File("$mainDirectory/.hmf/!important folder/nInfo.json").create();
  nInfo.writeAsStringSync("[]");
  var sInfoManager = await File("$mainDirectory/.hmf/!important folder/sInfoManager.json").create();
  sInfoManager.writeAsStringSync("[2022]");
  var sInfo2022 = await File("$mainDirectory/.hmf/!important folder/sInfo2022.json").create();
  var noOfDays = DateTime(2023,1,1).difference(DateTime(2022,1,1)).inDays;
  var sInfoList = [];
  for(int i = 0;i<noOfDays;i++){
    sInfoList.add([{'type':'text','info':''}]);
  }
  sInfo2022.writeAsStringSync(jsonEncode(sInfoList));
  await Directory("$mainDirectory/.hmf/!important folder/sInfoForImages").create();

  //
  var camInfo = await File("$mainDirectory/.hmf/!important folder/camInfo.json").create();
  camInfo.writeAsStringSync("[]");
  return 0;
}

permissionHandling() async {
  var mainDirectory = "storage/emulated/0";
  var status1 = await Permission.storage.status;
  var status2 = await Permission.manageExternalStorage.status;
  if (!status1.isGranted) {
    await Permission.storage.request();
  }
  if (!status2.isGranted) {
    await Permission.manageExternalStorage.request();
  }
  status1 = await Permission.storage.status;
  status2 = await Permission.manageExternalStorage.status;
  if(status1.isGranted && status2.isGranted){
    if(!(await Directory("$mainDirectory/.hmf").exists())) {
      await fileCreation();
      Fluttertoast.showToast(
        msg: "run the app again",
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.SNACKBAR ,
        backgroundColor: const Color.fromARGB(80, 0, 0, 0),
        textColor: const Color(0xffdbdbdb),// location
      );
      exit(0);
    }
    return true;
  }
  else {
    return false;
  }
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  var mainDirectory = "storage/emulated/0";
  //in android(Android SDK built for *86) 'storage/emulated/0'
  //for any other android device the File path will be 'storage/emulated/0'
  //in windows 'D:\\.hmf\\'
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]
  );
  if(await permissionHandling()) {
    await Future.delayed(const Duration(milliseconds:10));
    runApp(const MyApp());
  }
  else {
    Fluttertoast.showToast(
      msg: "access is denied",
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.SNACKBAR ,
      backgroundColor: const Color.fromARGB(80, 0, 0, 0),
      textColor: const Color(0xffdbdbdb),// location
    );
    exit(0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"Calculator",
      routes:{
        "calculator":(context) => const CalculatorPage(),
        "home":(context) => const Home(),
        "images":(context) => const Images(),
        "videos":(context) => const Videos(),
        "audios":(context) => const Audios(),
        "all files":(context) => const AllFiles(),
        "pdf":(context) => const PDF(),
        "excel":(context) => const Excel(),
        "contacts":(context) => const ContactPage(),
        'notes':(context) => const Notes(),
        "secret diary":(context) => const DiarySelector(),
        "camera":(context) => const Camera(),
        "settings":(context) => const Settings(),
        "themes and modes":(context) => const UiAndModeChange(),
        "set security question":(context) => const SetSecurityQuestion(),
        "developer contact":(context) => const DeveloperContact(),
        "about":(context) => const About(),
        "forgot password":(context) => const AskQuestions(),
      },
      debugShowCheckedModeBanner: false,
      home:const CalculatorPage(),
      theme:ThemeData(primaryColor: Colors.blue,primarySwatch: Colors.blueGrey),
      builder: EasyLoading.init(),
    );
  }
}

