import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_app/ui_for_file_pages.dart';
import 'package:launch_app/other_functions.dart';
import "package:launch_app/universalProperties.dart";

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static var mainDirectory = "storage/emulated/0";
  static var cInfo = File("$mainDirectory/.hmf/!important folder/cInfo.json");
  static var cInfoList = jsonDecode(cInfo.readAsStringSync());
  static var showCheckBox = false;
  static var selectedList = [];
  static var selected = 0;
  var floatActBtn;
  var contentWidget;
  var isSelected = List.generate(cInfoList.length, (index) => false);
  var deleteBtnState = null;
  var themeUI;

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
    print(cInfoList);
    ///if zero entries
    ///then non zero entries
    ///non zero ==> select state and non-select state
    ///if non select state
    ///if select state
    ///in select state if zero selected btn disable else enable
    cInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/cInfo.json").readAsStringSync());
    if(cInfoList.isEmpty){
      floatActBtn = null;
      contentWidget = Center(//center
          child: Column(//children goes inside this
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              ElevatedButton(//plus button
                  onPressed:() async {
                    await ContactFunction.onPressedAddButtonOfContact(context:context);
                    cInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/cInfo.json").readAsStringSync());
                    isSelected = List.generate(cInfoList.length, (index) => false);
                    setState((){});
                  },// Here we are doing the file operation
                  style:UiForFilePages.styleForAddBtn(context),
                  child:Icon(Icons.add,size:MediaQuery.of(context).size.height * 0.1,color:Colors.white60,)
              ),
              const SizedBox(height:25),//gap
              Text(//text
                  "No Contacts added",
                  style:themeUI.noContactAddedTxtStyle),
            ],
          ),
        );
    }
    else{
      if(!showCheckBox){
        floatActBtn = FloatingActionButton(
          onPressed:() async {
            await ContactFunction.onPressedAddButtonOfContact(context:context);
            cInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/cInfo.json").readAsStringSync());
            isSelected = List.generate(cInfoList.length, (index) => false);
            setState(() {});
          },
          backgroundColor: themeUI.floatingActionButtonColor,
          child:Icon(
            Icons.add,
            size:themeUI.floatingActionIconSize,
            color:themeUI.floatingActionIconColor,
          ),
        );
        contentWidget = Container(
          child:ScrollConfiguration( // here is the list
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: GlowingOverscrollIndicator(
              color:const Color(0xff32324f),
              axisDirection: AxisDirection.down,
              child: ListView.builder( //builder for listView
                  itemCount: cInfoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onLongPress:(){
                        showCheckBox = true;
                        setState(() {});
                      },
                      leading:const Icon(Icons.contact_page_outlined, color: Color(0xff25a2e6), size: 40),
                      title: Text("${cInfoList[index]['name']}",style:themeUI.contactListNameTxtStyle),
                      subtitle: Text("${cInfoList[index]['number']}", style:themeUI.contactListNoTxtStyle),
                      onTap: () {
                        ContactFunction.showContactInfo(contactInfo:cInfoList[index],context:context);
                      },
                    );
                  }
              ),
            ),
          ),
        );
      }
      else{
        if(selected == 0){
          deleteBtnState = null;
          setState(() {});
        }
        else{
          deleteBtnState = (){
            ContactFunction.onPressedDeleteButtonOfContact(selectedList:selectedList);
            showCheckBox = false;
            selectedList = [];
            selected = 0;
            Navigator.pop(context);
            print("After delete $cInfoList");
          };
          setState(() {});
        }
        floatActBtn = null;
        contentWidget = Container(
          child:Column(
            children: [
              Flexible(
                  flex:1,
                  child: Container(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon:const Icon(Icons.close,color:Colors.white60),
                              onPressed:(){
                                showCheckBox = false;
                                isSelected = List.generate(isSelected.length,(i)=> false);
                                selectedList = [];
                                selected = 0;
                                setState(() {});
                              },
                            ),
                            const SizedBox(width:10,),
                            Text("$selected contact selected",style:const TextStyle(color:Colors.white60)),
                          ],
                        ),

                        TextButton(
                          onPressed:deleteBtnState,
                          child:Text("DELETE",style:TextStyle(color:(selectedList.isEmpty) ? Colors.black45:Colors.blue)),
                        ),
                      ],
                    ),
                  )
              ),
              Flexible(
                flex:9,
                child: ScrollConfiguration( // here is the list
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: GlowingOverscrollIndicator(
                    color:const Color(0xff32324f),
                    axisDirection:AxisDirection.down,
                    child: ListView.builder( //builder for listView
                        itemCount: cInfoList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onLongPress:(){
                              showCheckBox = true;
                              setState(() {});
                            },
                            leading: Checkbox(
                              activeColor: Colors.blue,
                              value: isSelected[index],
                              onChanged: (bool? val) {
                                isSelected[index] = !isSelected[index];
                                if(isSelected[index]){
                                  selectedList.add(cInfoList[index]);
                                  print(selectedList);
                                  selected++;
                                }
                                else{
                                  selectedList.remove(cInfoList[index]);
                                  print(selectedList);
                                  selected--;
                                }
                                setState(() {});
                              },
                            ),
                            title: Text(
                                "${cInfoList[index]['name']}",
                              style:themeUI.contactListNameTxtStyle,
                            ),
                            subtitle: Text("${cInfoList[index]['number']}", style:themeUI.contactListNoTxtStyle),
                            onTap: () {
                              isSelected[index] = !isSelected[index];
                              if(isSelected[index]){
                                selectedList.add(cInfoList[index]);
                                print(selectedList);
                                selected++;
                              }
                              else{
                                selectedList.remove(cInfoList[index]);
                                print(selectedList);
                                selected--;
                              }
                              setState(() {});
                            },
                          );
                        }
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return SafeArea(
      child:Scaffold(
        appBar:AppBar(//appBar
          title:Text(
            "Contacts",
            style:themeUI.appBarTxtStyle,
          ),
          leading:IconButton(//backIcon
            onPressed:(){
              showCheckBox = false;
              selectedList = [];
              selected = 0;
              Navigator.pop(context);
            },
            icon:const Icon(
              Icons.arrow_back_ios_new_sharp,
              size:18,
              color:Colors.white60,
            ),
          ),
          backgroundColor: UiForFilePages.appBarColor,
          elevation:4,
        ),
        body:Container(//main container
          decoration:UiForFilePages.filePageContainerDecoration(),
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: contentWidget,
        ),
        floatingActionButton: floatActBtn,
      ),
    );
  }
}
