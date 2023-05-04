import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';
import 'dart:io';

import 'other_functions.dart';

class NotesAdd extends StatefulWidget {
  final aim,noteIndex;
  const NotesAdd({Key? key, required this.aim,required this.noteIndex}) : super(key: key);

  @override
  State<NotesAdd> createState() => _NotesAddState();
}

class _NotesAddState extends State<NotesAdd> {
  static var mainDirectory = "storage/emulated/0";
  static var nInfo =  File("$mainDirectory/.hmf/!important folder/nInfo.json");
  var titleController = TextEditingController();
  var noteController = TextEditingController();
  var nInfoList = jsonDecode(nInfo.readAsStringSync());
  var index;

  @override
  initState(){
    var controllerTextList = NotesAddFunction.initFunction(aim:widget.aim,noteIndex:widget.noteIndex,textOfTitleController:titleController.text,textOfNoteController: noteController.text);
    titleController.text = controllerTextList[0];
    noteController.text = controllerTextList[1];
    super.initState();
  }

  onDispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title:const Text("Add Notes"),
          leading:IconButton(
            icon:const Icon(Icons.arrow_back_ios),
            onPressed:(){
              Navigator.pop(context);
            },
          ),
        ),
        body:Container(
          child:Column(
            children: [
              Flexible(
                flex:1,
                child: Container(
                  child: TextField(
                    onChanged:(value) {
                      NotesAddFunction.onChangedTitleFunction(aim:widget.aim,noteIndex:widget.noteIndex,value:value);
                      setState(() {});
                    },
                    decoration:const InputDecoration(hintText:'Title',),
                    controller:titleController,
                  ),
                ),
              ),
              Flexible(
                flex:9,
                child:Container(
                  child: TextField(
                    onChanged: (value){
                      NotesAddFunction.onChangedNotesFunction(aim:widget.aim,noteIndex:widget.noteIndex,value:value);
                      setState(() {});
                    },
                  decoration:const InputDecoration(
                    hintText:'notes',
                  ),
                    controller: noteController,
                    keyboardType: TextInputType.multiline,
                    minLines:1,
                    maxLines:null,
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

class TodoAdd extends StatefulWidget {
  final aim,noteIndex;
  const TodoAdd({Key? key,required this.aim,required this.noteIndex}) : super(key: key);

  @override
  State<TodoAdd> createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  static var mainDirectory = "storage/emulated/0";
  var onPressedAddListItemBtn;
  static var controller;
  static var showList= [];
  static var nInfo = File("$mainDirectory/.hmf/!important folder/nInfo.json");
  static var nInfoList = jsonDecode(nInfo.readAsStringSync());
  static var checkBoxList;
  static var commonIndex;

  initState(){
    if(widget.aim == "add") {
      nInfoList = jsonDecode(nInfo.readAsStringSync());
      nInfoList.add({'title': '', 'notes': [""]});
      nInfo.writeAsStringSync(jsonEncode(nInfoList));
      commonIndex = nInfoList.length - 1;
      checkBoxList = List.generate(1, (index) => false);
      controller = List.generate(1, (index) => TextEditingController(text: nInfoList.last['notes'][index]),);
      var singleListItem = TodoAddFunction.singleListItem(index:0,controllerElement:controller[0],showList:showList,controller:controller,checkBoxList:checkBoxList,noteIndex:nInfoList.length-1);
      showList = [singleListItem[0]];
    }
    else {
      nInfoList = jsonDecode(nInfo.readAsStringSync());
      var recoveredList = nInfoList[widget.noteIndex]['notes'];
      commonIndex = widget.noteIndex;
      checkBoxList = List.generate(recoveredList.length,(index) => false );
      controller = List.generate(recoveredList.length,(index) => TextEditingController());
      for(int i = 0;i<recoveredList.length;i++){
        controller[i].text = recoveredList[i];
      }
      var singleListItem = List.generate(recoveredList.length, (index) =>
          TodoAddFunction.singleListItem(index:index,controllerElement:controller[index],showList:showList,controller:controller,checkBoxList:checkBoxList,noteIndex:widget.noteIndex)
      );
      var tempList = [];
      for(int i = 0;i<singleListItem.length;i++) {
        tempList.add(singleListItem[i][0]);
      }
      showList = tempList;
    }
    super.initState();
  }
  onDispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:Scaffold(
        appBar:AppBar(
          title:const Text("Add todo list"),
        ),
        body:Container(
          child:Column(
            children: [
              Flexible(
                flex:1,
                child: TextField(
                  onChanged:(value){
                    nInfoList = jsonDecode(nInfo.readAsStringSync());
                    if(widget.aim == "add") {
                      nInfoList[nInfoList.length - 1]['title'] = value;
                    }
                    else{
                      nInfoList[widget.noteIndex]['title'] = value;
                    }
                    nInfo.writeAsStringSync(jsonEncode(nInfoList));
                  },
                  decoration:const InputDecoration(
                      hintText:"Title"
                  ),
                ),
              ),
              Flexible(
                flex:8,
              child:Container(
                height:MediaQuery.of(context).size.height,
                child: ReorderableListView(
                    onReorder:(oldIndex,newIndex){
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      var draggedItem = showList.removeAt(oldIndex);
                      showList.insert(newIndex,draggedItem);
                      var draggedController = controller.removeAt(oldIndex);
                      controller.insert(newIndex,draggedController);
                      nInfoList = jsonDecode(nInfo.readAsStringSync());
                      for(int i = 0;i<controller.length;i++){
                        nInfoList[commonIndex]['notes'][i] = controller[i].text;
                      }
                      nInfo.writeAsStringSync(jsonEncode(nInfoList));
                      setState(() {});
                    },
                  footer: Row(
                    children: [
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 9,
                        child: TextButton(
                          onPressed: () {
                            checkBoxList.add(false);
                            controller.add(TextEditingController());
                            showList.add(
                                Row(
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
                                        onChanged: (bool? val) {},
                                      ),
                                    ),
                                    Flexible(
                                      flex: 9,
                                      child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          onChanged: (value) {
                                            nInfoList = jsonDecode(nInfo.readAsStringSync());
                                            if(widget.aim == "add") {
                                              nInfoList[nInfoList.length - 1]['notes'].last = value;
                                            }
                                            else {
                                              nInfoList[widget.noteIndex]['notes'].last = value;
                                            }
                                            nInfo.writeAsStringSync(jsonEncode(nInfoList));
                                            setState(() {});
                                          },
                                          controller: controller.last,
                                      ),
                                    ),
                                    Flexible(
                                      flex:1,
                                      child:GestureDetector(
                                        onTap:(){
                                          showList.removeLast();
                                          controller.removeLast();
                                          checkBoxList.removeLast();
                                          nInfoList.last['notes'] = List.generate(controller.length, (i) => controller[i].text);
                                          nInfo.writeAsStringSync(jsonEncode(nInfoList));
                                          setState(() {});
                                        },
                                        child:const Icon(Icons.close),
                                      ),
                                    )
                                  ],
                                )
                            );
                            if(widget.aim == "add"){
                              nInfoList.last['notes'] = List.generate(controller.length, (index) => controller[index].text);
                            }
                            else{
                              nInfoList[widget.noteIndex]['notes'] = List.generate(controller.length, (index) => controller[index].text);
                            }
                            nInfo.writeAsStringSync(jsonEncode(nInfoList));
                            setState(() {});
                          },
                          child: const Text("+ ADD LIST ITEM"),),
                      ),
                    ],
                  ),
                    children:[
                      for(int i = 0;i<showList.length;i++)
                        Card(
                          key:ValueKey(i),
                          child:showList[i],
                        ),
                    ],
                 ),
              ),
                  ),
              ],
              ),
      ),
    )
    );
  }
}


