import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart' as mail;
import 'package:launch_app/page_for_image_show.dart';
import "package:launch_app/notes.dart";
import 'package:math_expressions/math_expressions.dart';// importing math expression (for evaluating expression)
import "package:launch_app/uiForCalculator.dart";
import "contact_icons.dart";
import "package:path/path.dart" as path;

import 'notes_add.dart';

class ContactFunction{
  static var mainDirectory = "storage/emulated/0";
  static onPressedAddButtonOfContact({context}) {
    var nameController = TextEditingController();
    var numController = TextEditingController();
    var emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    var themeUI;
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
    return showDialog(context:context,builder: (context) =>
      AlertDialog(
        title:Text(
            "Add Contact",
          style:themeUI.addContactPopUpTxtStyle,
        ),
        scrollable: true,
        content:Container(
          child: Form(
            key:formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:MainAxisSize.min,
            children: [
              Text(
                  "Name",
                style:themeUI.addContactSubTxtPopUpTxtStyle,
              ),
              TextFormField(
                cursorColor: Colors.blue,
                  controller:nameController,
                  keyboardType: TextInputType.text,
                 decoration:InputDecoration(
                   focusedBorder: const UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.blue),
                   ),
                   prefixIcon: Icon(
                       Icons.contact_page_outlined,
                     color:themeUI.contactAddPopUpIconColor,
                     size:themeUI.contactAddPopUpIconSize,
                   ),
                 ),
                 validator:(value){
                    if(value!.isEmpty){
                      return "this field is required";
                    }
                    else if(value.length < 3){
                      return "Name is too short";
                    }
                    else {
                      return null;
                    }
                 }
              ),
              const SizedBox(height:10),
              Text("Mobile no.",style:themeUI.addContactSubTxtPopUpTxtStyle),
              TextFormField(
                cursorColor: Colors.blue,
                  controller:numController,
                keyboardType:TextInputType.phone,
                decoration:InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(
                      Icons.phone,
                    color:themeUI.contactAddPopUpIconColor,
                    size:themeUI.contactAddPopUpIconSize,
                  ),
                  prefixText: '+91',
                ),
                validator: (value){
                    if(value!.isEmpty){
                      return "this field is required";
                    }
                    else if(value.length <6){
                      return "invalid mobile number";
                    }
                    else if(value.contains(RegExp(r'[A-Za-z]'))){
                      return "it contains characters";
                    }
                    else {
                      return null;
                    }
                },
                maxLength: 10,
              ),
              const SizedBox(height:10),
              Text("E-mail (optional)",style:themeUI.addContactSubTxtPopUpTxtStyle),
              const SizedBox(height:10),
              TextFormField(
                cursorColor: Colors.blue,
                  controller:emailController,
                keyboardType:TextInputType.emailAddress,
                decoration:InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color:themeUI.contactAddPopUpIconColor,
                    size:themeUI.contactAddPopUpIconSize,
                  ),
                ),
                validator:(value){
                    if(value!.isEmpty || value == null){
                      return null;
                    }
                    else if(value.contains(RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$'))){
                      return null;
                    }
                    else{
                      return "invalid email address";
                    }
                }
              ),
            ],
        ),
          ),
        ),
        actions: [
          TextButton(
            onPressed:(){
              Navigator.pop(context);
            },
            child:const Text("CANCEL",style:TextStyle(color:Colors.blue)),
          ),
          TextButton(
            onPressed:() async {
              if(formKey.currentState!.validate()){
                var cInfo = File("$mainDirectory/.hmf/!important folder/cInfo.json");
                var cInfoList = await jsonDecode(cInfo.readAsStringSync());
                await cInfoList.add({'name':nameController.text,'number':'+91 ${numController.text}','email':emailController.text});
                cInfo.writeAsStringSync(jsonEncode(cInfoList));
                Navigator.pop(context);
              }
            },
            child:const Text("SAVE",style:TextStyle(color:Colors.blue)),
          ),
        ]
      ),
    );
  }
  static onPressedDeleteButtonOfContact({selectedList}){
    var cInfoList = jsonDecode( File("$mainDirectory/.hmf/!important folder/cInfo.json").readAsStringSync());
    print("Before delete : $cInfoList");
    print(selectedList);
    print(cInfoList);
    for(int i = 0;i<selectedList.length;i++){
      for(int j = 0;j<cInfoList.length;j++){
        if(selectedList[i]['name'] == cInfoList[j]['name'] && selectedList[i]['number'] == cInfoList[j]['number'] && selectedList[i]['email'] == cInfoList[j]['email']){
          cInfoList.remove(cInfoList[j]);
          break;
        }
      }
    }
    File("$mainDirectory/.hmf/!important folder/cInfo.json").writeAsStringSync(jsonEncode(cInfoList));
  }
  static showContactInfo({contactInfo,context}){
    var themeUI;
    var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
    var mainJson = jsonDecode(mainInfo.readAsStringSync());
    if(mainJson["theme"] == "blue and black"){
      themeUI = BlueBlackTheme();
    }
    else if(mainJson["theme"] == "dark"){
      themeUI = DarkTheme();
    }
    else if(mainJson["theme"] == "light") {
      themeUI = LightTheme();
    }
      return showDialog(context:context,builder:
    (context) => AlertDialog(
      title:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
                contactInfo['name'],
              style:themeUI.viewContactPopUpTxtStyle,
            ),
          ),
          Icon(
            Contact.user,
            color:themeUI.contactAddPopUpIconColor,
            size:themeUI.contactAddPopUpIconSize,
          ),
        ],
      ),
      content:Column(
        mainAxisSize: MainAxisSize.min,
        children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Flexible(
              child:Text(
                contactInfo['number'],
              style:themeUI.viewContactSubTxtPopUpTxtStyle,
            ),
            ),
            TextButton(
              onPressed:() async {
                var url = Uri.parse('sms:${contactInfo['number']}');
                if(await canLaunchUrl(url)){
                  await launchUrl(url);
                }
              },
              child:const Text("MESSAGE",style:TextStyle(color:Colors.blue)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Flexible(
              child: Text((contactInfo['email'] != '') ? contactInfo['email'] : 'email address is not provided',
                style:themeUI.viewContactSubTxtPopUpTxtStyle,
                overflow: TextOverflow.visible,
              ),
            ),
            TextButton(
              onPressed:(contactInfo['email'] == "") ? null : () async {
                var mailto = mail.Mailto(
                  to:[contactInfo['email']],
                  cc:[contactInfo['email']],
                  body:'',
                  subject:'',
                );
                await launchUrl(Uri.parse('$mailto'));
              },
              child:Text("EMAIL",style:TextStyle(color:(contactInfo['email'] == "") ? Colors.black45 :Colors.blue)),
            ),
          ],
        ),
      ],
      ),
      actions:[
        TextButton(
          onPressed:(){
            Navigator.pop(context);
          },
          child:const Text("CANCEL",style:TextStyle(color:Colors.blue)),
        ),
        TextButton(
          onPressed:() async {
            var url = Uri.parse('tel:${contactInfo['number']}');
            if(await canLaunchUrl(url)){
              await launchUrl(url);
            }
          },
          child:const Text("CALL",style:TextStyle(color:Colors.blue)),
        ),
      ],
    )
    );
  }
}

class DiaryFunction {
  static var mainDirectory = "storage/emulated/0";

  static initFunction({indexNumberToDate, formattedIndexNumberToDate, currentPageNo, noOfDays, currentDate, initDate}) {
    for (int i = 0; i < noOfDays; i++) {
      indexNumberToDate.add(initDate);
      initDate = initDate.add(const Duration(days: 1));
      formattedIndexNumberToDate.add(
          DateFormat("dd MMM yyyy").format(indexNumberToDate[i]));
      if (formattedIndexNumberToDate[i] == currentDate) {
        currentPageNo = i;
      }
    }
    return [formattedIndexNumberToDate, currentPageNo];
  }

  static onChangedUpdation({currentPageNo, index, value, year, sInfoCurrentList}) {
    var sInfoList = jsonDecode(
        File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
    sInfoCurrentList = sInfoList[currentPageNo];
    sInfoCurrentList[index] = {'type': 'text', 'info': value};
    sInfoList[currentPageNo] = sInfoCurrentList;
    File("$mainDirectory/.hmf/!important folder/sInfo$year.json").writeAsStringSync(jsonEncode(sInfoList));
  }

  static Future<int> onPressedAddImage({result, year, currentPageNo, controllerList}) async {
    print("controller length ${controllerList.length}");
    var pltFile = result.files.first;
    var imgPath = pltFile.path;
    var onlyName = path.basenameWithoutExtension(imgPath);
    var origFile = await File("${pltFile.path}").copy(
        "$mainDirectory/.hmf/!important folder/sInfoForImages/$onlyName.enc");
    var sInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
    var sInfoCurrentList = sInfoList[currentPageNo];
    await sInfoCurrentList.add({'type': 'image', 'info': origFile.path});
    // if first textField is not filled then remove it
    if (sInfoCurrentList[sInfoCurrentList.length - 2]['info'] ==
        '') { //before the last
      await controllerList.removeAt(sInfoCurrentList.length - 2);
      await sInfoCurrentList.removeAt(sInfoCurrentList.length - 2);
    }
    sInfoList[currentPageNo] = sInfoCurrentList;
    File("$mainDirectory/.hmf/!important folder/sInfo$year.json").writeAsStringSync(jsonEncode(sInfoList));

    //this is for adding textField
    await sInfoCurrentList.add({'type': 'text', 'info': ""});
    sInfoList[currentPageNo] = sInfoCurrentList;
    //sInfoList = List.generate(noOfDays,(index) => []);
    File("$mainDirectory/.hmf/!important folder/sInfo$year.json").writeAsStringSync(jsonEncode(sInfoList));
    print("completely executed");
    return 0;
  }

  static textFieldWidget({index, controllerList, sInfoCurrentList, currentPageNo, year}) {
    return TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText:"write your today's incident here . . .",
          border:InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        autofocus: false,

        controller: controllerList[index],
        onChanged: (value) {
          onChangedUpdation(currentPageNo: currentPageNo,
              index: index,
              value: value,
              year: year,
              sInfoCurrentList: sInfoCurrentList);
        });
  }

  static imageWidget({context, sInfoCurrentList, index, currentPageNo,year}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ImageShower(
                    imgPath: sInfoCurrentList[index]['info'],
                    currentPageNo: currentPageNo,
                    sInfoCurrentListIndex: index,
                    year:year
                )));
          },
          child: Container(
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.file(File(sInfoCurrentList[index]['info']))
          ),
        ),
        const SizedBox(height:30),
      ],
    );
  }

  static List<Widget> actualList({sInfoCurrentList, sInfoList, year, currentPageNo, context, controllerList}) {
    return List.generate(sInfoCurrentList.length, (index) {
      if (sInfoCurrentList[index]['type'] == "text") {
        return textFieldWidget(
            index: index,
            controllerList: controllerList,
            sInfoCurrentList: sInfoCurrentList,
            currentPageNo: currentPageNo,
            year: year);
      }
      else {
        return imageWidget(context: context,
            sInfoCurrentList: sInfoCurrentList,
            index: index,
            currentPageNo: currentPageNo,year:year);
      }
    });
  }
}

class NotesFunction{
  static var mainDirectory = "storage/emulated/0";
  static var nInfo = File("$mainDirectory/.hmf/!important folder/nInfo.json");
  static var nInfoList = jsonDecode(nInfo.readAsStringSync());
  static bool showCheckBox = false;
  static var showCheckBoxListAtFunction = List.generate(nInfoList.length,(index)=> false);
  static set setCheckBox(value){
    showCheckBox = value;
  }
  static set setCheckBoxList(value){
    showCheckBoxListAtFunction = value;
  }

  static onPressedForTodo({context}) async {
    await Navigator.push(context,MaterialPageRoute(builder:(context) => const TodoAdd(aim:'add',noteIndex:null)));
    nInfoList = jsonDecode(nInfo.readAsStringSync());
    if (nInfoList.last['title'] == "" && (nInfoList.last['notes'].isEmpty || (nInfoList.last['notes'].length == 1 && nInfoList.last['notes'][0] == ""))){
      nInfoList.removeLast();
      nInfo.writeAsStringSync(jsonEncode(nInfoList));
    }
  }

  static onPressedForNotes({context}) async {
    await Navigator.push(context,MaterialPageRoute(builder:(context) => const NotesAdd(aim:'add',noteIndex:null)));
    nInfoList = jsonDecode(nInfo.readAsStringSync());
    if(nInfoList.last['title'] == "" && (nInfoList.last['notes'] == "")){
      nInfoList.removeLast();
      nInfo.writeAsStringSync(jsonEncode(nInfoList));
    }
  }

  static contentWidget({context,onScreenList,callBack}){
    return Container(
      child:Column(
        children: [
          Flexible(
              flex:9,
              child: Container(
                  child:GridView.count(
                      crossAxisCount:2,
                      mainAxisSpacing:5,
                      crossAxisSpacing: 5,
                      children: onScreenList,
                  )
              )),
          (showCheckBox) ?
          Flexible(
              flex:1,child:Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  TextButton(
                    onPressed:(){
                      showCheckBox = false;
                      callBack;
                    },
                    child:const Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed:(){},
                    child:const Text("DELETE"),
                  ),
                ],
              ),
            ),
          ) :
          Flexible(
            flex:1,
            child: Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex:3,
                    child: GestureDetector(
                      onTap:() async {
                        onPressedForNotes(context:context);
                      },
                      child: Container(
                        child:const Text("Take a note..."),
                      ),
                    ),
                  ),
                  Flexible(
                    flex:1,
                    child:IconButton(
                        onPressed:() async {
                          onPressedForTodo(context:context);
                        },
                        icon:const Icon(Icons.view_list_rounded)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static routeToEditingPage({context,index}) async {
    await Navigator.push(context,MaterialPageRoute(builder:(context) => (nInfoList[index]['notes'] is List) ? TodoAdd(aim:'edit',noteIndex:index) : NotesAdd(aim:'edit',noteIndex:index)));
    nInfoList = jsonDecode(nInfo.readAsStringSync());
  }

  static onScreenList({context,required Function callBack,showCheckBoxList}){
    print(showCheckBox);
    print("On screen list worked once");
    var myList =  List.generate(nInfoList.length, (index) =>
        GestureDetector(
            child:Container(
              padding:const EdgeInsets.all(5),
              margin:const EdgeInsets.all(5),
              decoration:BoxDecoration(
                color:Colors.white,
                border:Border.all(
                  color:(showCheckBoxList[index]) ? const Color(0xff2d99f7) : const Color.fromRGBO(0, 0, 0, 0),
                  width:4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(flex:1,child: Text(nInfoList[index]['title'])),
                  Flexible(
                    flex:5,
                    child:(nInfoList[index]['notes'] is List ) ? ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        itemCount:(nInfoList[index]['notes'].length <= 7) ? nInfoList[index]['notes'].length : 7,
                        itemBuilder: (context,i) => Text("${i+1} ${nInfoList[index]['notes'][i] ?? ""}")
                    ) :Text(nInfoList[index]['notes'] ?? ""),
                  ),
                ],
              ),
            ),
            onTap:() {
              if(!showCheckBox) {
                () async {
                  await routeToEditingPage(context: context, index: index);
                };
              }
              else {
                showCheckBoxListAtFunction[index] = true;
              }
              callBack;
            },
            onLongPress:(){
              showCheckBox = true;
              print("Done");
              callBack;
          },
        )
    );
    return myList;
  }
}

class NotesAddFunction{
  static var mainDirectory = "storage/emulated/0";
  static var nInfo =  File("$mainDirectory/.hmf/!important folder/nInfo.json");
  static var nInfoList = jsonDecode(nInfo.readAsStringSync());
  static initFunction({aim,noteIndex,textOfTitleController,textOfNoteController}){
    if(aim == 'add') {
      nInfoList.add({'title': '', 'notes': ''});
      nInfo.writeAsStringSync(jsonEncode(nInfoList));
      return ["",""];
    }
    else {
      textOfTitleController = nInfoList[noteIndex]['title'];
      textOfNoteController = nInfoList[noteIndex]['notes'];
      return [textOfTitleController,textOfNoteController];
    }
  }
  static onChangedTitleFunction({aim,noteIndex,value}){
    if (aim == 'add') {
      nInfoList = jsonDecode(nInfo.readAsStringSync());
      nInfoList.last['title'] = value;
    }
    else {
      nInfoList = jsonDecode(nInfo.readAsStringSync());
      nInfoList[noteIndex]['title'] = value;
    }
    nInfo.writeAsStringSync(jsonEncode(nInfoList));
  }

  static onChangedNotesFunction({aim,noteIndex,value}){
    if (aim == 'add') {
      nInfoList = jsonDecode(nInfo.readAsStringSync());
      nInfoList.last['notes'] = value;
    }
    else {
      nInfoList = jsonDecode(nInfo.readAsStringSync());
      nInfoList[noteIndex]['notes'] = value;
    }
    nInfo.writeAsStringSync(jsonEncode(nInfoList));
  }

}

class TodoAddFunction{
  static var mainDirectory = "storage/emulated/0";
  static var nInfo = File("$mainDirectory/.hmf/!important folder/nInfo.json");
  static var nInfoList = jsonDecode(nInfo.readAsStringSync());

  static singleListItem({index,controllerElement,showList,controller,checkBoxList,noteIndex}){
    var singleListItem =  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Flexible(
          flex: 1,
          child: Icon(
            Icons.drag_indicator_outlined,
          ),
        ),
        Flexible(
          flex: 1,
          child: Checkbox(
            value: false,
            onChanged: (bool? val) {
            },
          ),
        ),
        Flexible(
          flex: 9,
          child: TextField(
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                nInfoList = jsonDecode(nInfo.readAsStringSync());
                nInfoList[noteIndex]['notes'][index] = value;
                nInfo.writeAsStringSync(jsonEncode(nInfoList));
              },
              controller: controllerElement,
          ),
        ),
        Flexible(
          flex:1,
          child:
          GestureDetector(
            onTap:(){
              nInfoList[noteIndex]['notes'].removeAt(index);
              showList.removeAt(index);
              controller.removeAt(index);
              checkBoxList.removeAt(index);
              nInfo.writeAsStringSync(jsonEncode(nInfoList));
            },
            child:const Icon(Icons.close),
          ),
        )
      ],
    );
    return [singleListItem];
  }
}

class CameraFunction{
  static var mainDirectory = "storage/emulated/0";
  static NamingToFile({context}) {
    var nameController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return showDialog(context:context,builder: (context) =>
        AlertDialog(
            title:const Text("Name your file"),
            scrollable: true,
            content:Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:MainAxisSize.min,
                children: [
                  const Text("Name"),
                  TextFormField(
                    cursorColor: Colors.blue,
                      controller:nameController,
                      keyboardType: TextInputType.text,
                      decoration:const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.edit),
                      ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed:(){
                  Navigator.pop(context);
                },
                child:const Text("CANCEL",style:TextStyle(color:Colors.blue)),
              ),
              TextButton(
                onPressed:() async {
                  Navigator.pop(context,nameController.text);
                },
                child:const Text("SAVE",style:TextStyle(color:Colors.blue)),
              ),
            ]
        ),
    );
  }
}

class CalculatorFunction{
  static bool opInitCheck(exp,expView){
    bool errorFunc() {
      try {
        var myBool = exp.substring(exp.length - 5, exp.length) == "/100*";
        return myBool;
      }
      catch (e) {
        return false;
      }
    }
    if(errorFunc() && expView.substring(expView.length - 2,expView.length) == "%*"){
      return false;
    }
    else if(exp[exp.length - 1] == "+" || exp[exp.length - 1] == "-" || exp[exp.length - 1] == "*" || exp[exp.length - 1] == "/"){
      return false;
    }
    else {
      return true;
    }
  }
  static bool dotInitCheck(exp){
    var canDo = 1;// the variable that tells that can we put dot here
    /// next dot will be considered if there exists a operator after previous dot
    for(var i=0;i<exp.length;i++){
      if(exp[i] == "."){
        canDo = 0;
      }
      if(exp[i] == "+" ||exp[i] == "-" ||exp[i] == "*" ||exp[i] == "/" ||exp[i] == "%"){
        canDo = 1;
      }
    }
    if(canDo == 1){
      return true;
    }
    else{
      return false;
    }
  }
  static bool equalInitCheck(exp){
    return (exp[exp.length - 1] == "+" || exp[exp.length - 1] == "-" || exp[exp.length - 1] == "*" || exp[exp.length - 1] == "/" || exp[exp.length - 1] == "/" || exp[exp.length - 1] == "." ) ? false : true;
  }
  static var expViewListForm = ["_ ","_ ","_ ","_ "];
  static var expViewListForm2 = ["_ ","_ ","_ ","_ "];
  static List<String> numberPwdFunc(exp,expView,btnTxt,pwdNumCount){
    expViewListForm[pwdNumCount-1] = "$btnTxt ";
    expView = "${expViewListForm[0]}${expViewListForm[1]}${expViewListForm[2]}${expViewListForm[3]}";
    print(expView);
    return [exp,expView];
  }

  static List<String> numberPwdFunc2(exp,expView,btnTxt,pwdNumCount){
    expViewListForm2[pwdNumCount-1] = "$btnTxt ";
    expView = "${expViewListForm2[0]}${expViewListForm2[1]}${expViewListForm2[2]}${expViewListForm2[3]}";
    print(expView);
    return [exp,expView];
  }

  static restoreAgain(){
    expViewListForm = ["_ ","_ ","_ ","_ "];
    expViewListForm2 = ["_ ","_ ","_ ","_ "];
  }

  static List<String> numberFunc(exp,expView,btnTxt){
    if(exp == "0" && expView == "0" && btnTxt == "00"){
      return [exp,expView];
    }
    if(exp == "0" && expView == "0"){
      expView = "";
      exp = "";
    }
    exp += btnTxt;
    expView +=btnTxt;
    return [exp,expView];
  }
  static List<String> operatorFunc(exp,expView,btnTxt){
    if(CalculatorFunction.opInitCheck(exp,expView)){
      //exp add
      if (btnTxt == "%") {
        exp += "/100*";
      }
      else if (btnTxt == "×") {
        exp += "*";
      }
      else if (btnTxt == "÷") {
        exp += "/";
      }
      else {
        exp += btnTxt;
      }
      //expView add
      if (btnTxt == "%") {
        expView += "%×";
      }
      else {
        expView += btnTxt;
      }
    }
    return [exp,expView];
  }
  static List<String> clearFunc(exp,expView,btnTxt){
    if(btnTxt == "AC"){
      exp = "0";
      expView = "0";
    }
    else if(btnTxt == "<"){
      errorFunc(){
        try{
          var myBool = exp.substring(exp.length-4,exp.length) == "/100";
          return myBool;
        }
        catch(e){
          return false;
        }
      }
      print("i am executed");
      if(errorFunc() && expView[expView.length-1] == "%"){
        print("i am executed here ");
        exp = exp.substring(0, exp.length - 4);
      }
      else {
        if(exp.isNotEmpty) {
          exp = exp.substring(0, exp.length - 1);
        }
      }
      if(expView.isNotEmpty) {
        expView = expView.substring(0, expView.length - 1);
      }
    }
    return [exp,expView];
  }
  static List<String> dotFunc(exp,expView){
    if(CalculatorFunction.dotInitCheck(exp)) {
      exp += ".";
      expView += ".";
    }
    return [exp,expView];
  }
  static String equalFunc(exp,solved,context) {
    var mainDirectory = "storage/emulated/0";
    var mainInfo = File("$mainDirectory/.hmf/!important folder/mainInfo.json");
    var mainJson = jsonDecode(mainInfo.readAsStringSync());
    if(exp == mainJson["password"]){
      Navigator.pushReplacementNamed(context, "home");
    }
    if(exp == "112233"){
      Navigator.pushReplacementNamed(context,"forgot password");
    }
    if(CalculatorFunction.equalInitCheck(exp)) {
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      solved = expression.evaluate(EvaluationType.REAL, cm).toString();
      if(double.parse(solved) > 1000000000000 || double.parse(solved) < 0.000000001){
        solved = double.parse(solved).toStringAsFixed(3);
        solved = double.parse(solved).toStringAsExponential();
      }
      if (solved[solved.length - 2] == "." &&
          solved[solved.length - 1] == "0") {
        solved = solved.substring(0, solved.length - 2);
      }
    }
    return solved;
  }

  static Widget btnChildContent({type,btnTxt,context}){
    var returnWidget;
    var iconType;
    if(type == "operator" && btnTxt != "÷" && btnTxt != "%" || type == "clear" && btnTxt == "<"){
      if(btnTxt == "+") {
        iconType = Icons.add;
      }
      else if(btnTxt == "-"){
        iconType = Icons.remove;
      }
      else if(btnTxt == "×"){
        iconType = Icons.close;
      }
      else if(btnTxt == "<"){
        iconType = Icons.backspace_outlined;
      }
      returnWidget = Icon(iconType,size:CalcUI.numPadTxtAndIconSize(context));
    }
    else if(btnTxt == "÷"){
      returnWidget = Text("÷",style:TextStyle(fontSize:CalcUI.numPadTxtAndIconSize(context)));
    }
    else {
      returnWidget = Text(btnTxt,style:TextStyle(fontSize:CalcUI.numPadTxtAndIconSize(context)));
    }
    return returnWidget;
  }
}



















