import "package:flutter/material.dart";

class UiForFilePages {
  static var appBarColor = const Color(0xff32324f);
  static styleForAddBtn(c){
    return ElevatedButton.styleFrom(
        shape:const CircleBorder(),
        padding:EdgeInsets.all(MediaQuery.of(c).size.height * 0.03),
        primary:const Color(0xff32324f)
    );
  }
  static filePageContainerDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.2, 0.4, 0.6, 0.8, 1.0],
        colors: [
          Color(0xff2e2e30),
          Color(0xff2b2c36),
          Color(0xff2a2752),
          Color(0xff1e1a54),
          Color(0xff0c093d),
        ],
      ),
    );
  }
}

class BlueBlackTheme {
  double floatingChildSize = 65.0;
  double? floatingActionIconSize = 30;
  var floatingActionButtonColor = const Color(0xff32324f);
  var floatingActionIconColor = Colors.white60;
  var cameraOverlayColor = Colors.black;
  var appBarColor = const Color(0xff32324f);
  styleForAddBtn(c){
    return ElevatedButton.styleFrom(
        shape:const CircleBorder(),
        padding:EdgeInsets.all(MediaQuery.of(c).size.height * 0.03),
        primary:const Color(0xff32324f)
    );
  }
  filePageContainerDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.2, 0.4, 0.6, 0.8, 1.0],
        colors: [
          Color(0xff2e2e30),
          Color(0xff2b2c36),
          Color(0xff2a2752),
          Color(0xff1e1a54),
          Color(0xff0c093d),
        ],
      ),
    );
  }
}
class DarkTheme{
  var settingTipTxtStyle = const TextStyle(color:Colors.white60, fontSize: 20);
  var settingTipSubTxtStyle = const TextStyle(color:Colors.white60,);
  var settingPgTxtStyle = const TextStyle(color:Colors.white60,);
  var addContactPopUpTxtStyle = const TextStyle(fontSize:18, color:Colors.black,);
  var addContactSubTxtPopUpTxtStyle = const TextStyle(color:Colors.black, fontSize:15);
  var viewContactPopUpTxtStyle = const TextStyle(color:Colors.blue, fontSize:20);
  var viewContactSubTxtPopUpTxtStyle = const TextStyle(color:Colors.black, fontSize:15);
  var contactListNameTxtStyle = const TextStyle(color:Colors.white60,fontSize:17,fontWeight: FontWeight.w700);
  var contactListNoTxtStyle = const TextStyle(color:Colors.white60,fontSize:15);
  double floatingChildSize = 55.0;
  double floatingChildIconSize = 28.0;
  double? floatingActionIconSize = 35;
  var floatingActionButtonColor = const Color(0xff32324f);
  var floatingActionIconColor = Colors.white60;
  var cameraOverlayColor = Colors.black;
  var appBarColor = const Color(0xff32324f);
  var contactAddPopUpIconColor = Colors.blue;
  double? contactAddPopUpIconSize = 28;
  var cameraNoFilesTextStyle = const TextStyle(
    color:Colors.white60,
    fontSize: 19,
  );
  var filesNoFilesTxtStyle = const TextStyle(color:Colors.white60,fontSize:28);
  var appBarTxtStyle = const TextStyle(color:Colors.white60,fontSize: 20);
  var noContactAddedTxtStyle = const TextStyle(color:Colors.white60, fontSize:30,);
  var fileListTitleTxtStyle = const TextStyle(color:Colors.white60);
  var fileListSubtitleTxtStyle = const TextStyle(color:Colors.white60);
  var fileListTrailingTxtStyle = const TextStyle(color:Colors.white60);
  var fileListAlgTxtStyle = const TextStyle(color:Colors.black);

  styleForAddBtn(c){
    return ElevatedButton.styleFrom(
        shape:const CircleBorder(),
        padding:EdgeInsets.all(MediaQuery.of(c).size.height * 0.03),
        primary:const Color(0xff32324f)
    );
  }
  filePageContainerDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.2, 0.4, 0.6, 0.8, 1.0],
        colors: [
          Color(0xff2e2e30),
          Color(0xff2b2c36),
          Color(0xff2a2752),
          Color(0xff1e1a54),
          Color(0xff0c093d),
        ],
      ),
    );
  }
}
class LightTheme{
  double floatingChildSize = 65.0;
  double? floatingActionIconSize = 30;
  var floatingActionButtonColor = const Color(0xff32324f);
  var floatingActionIconColor = Colors.white60;
  var cameraOverlayColor = Colors.white;
  var appBarColor = const Color(0xff262626);
  static styleForAddBtn(c){
    return ElevatedButton.styleFrom(
        shape:const CircleBorder(),
        padding:EdgeInsets.all(MediaQuery.of(c).size.height * 0.03),
        primary:const Color(0xff32324f)
    );
  }
  static filePageContainerDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.2, 0.4, 0.6, 0.8, 1.0],
        colors: [
          Color(0xff2e2e30),
          Color(0xff2b2c36),
          Color(0xff2a2752),
          Color(0xff1e1a54),
          Color(0xff0c093d),
        ],
      ),
    );
  }
}