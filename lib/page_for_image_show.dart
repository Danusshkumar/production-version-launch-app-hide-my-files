import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class ImageShower extends StatelessWidget {
  final imgPath;
  final currentPageNo;
  final sInfoCurrentListIndex;
  final year;
  const ImageShower({Key? key, this.imgPath,this.currentPageNo,this.sInfoCurrentListIndex,this.year}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainDirectory = "storage/emulated/0";
    return SafeArea(
      child: Scaffold(
        body: Container(
          color:Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex:1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon:const Icon(Icons.arrow_back_ios,color:Colors.white),
                          onPressed:(){
                            Navigator.pop(context);
                          },
                        ),
                        Text(" HMF Image Viewer",style:TextStyle(color:Colors.white,fontSize:MediaQuery.of(context).size.height*0.02)),
                      ],
                    ),
                    IconButton(
                      icon:const Icon(Icons.delete_outline_outlined,color:Colors.white),
                      onPressed:(){
                        var sInfoList = jsonDecode(File("$mainDirectory/.hmf/!important folder/sInfo$year.json").readAsStringSync());
                        var sInfoCurrentList = sInfoList[currentPageNo];
                        sInfoCurrentList.removeAt(sInfoCurrentListIndex);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        sInfoList[currentPageNo] = sInfoCurrentList;
                        File("$mainDirectory/.hmf/!important folder/sInfo$year.json").writeAsStringSync(jsonEncode(sInfoList));
                        Fluttertoast.showToast(
                          msg: "image removed from diary",
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.SNACKBAR ,
                          backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                          textColor: const Color(0xffdbdbdb),// location
                        );
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                flex:9,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.file(File(imgPath)),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
