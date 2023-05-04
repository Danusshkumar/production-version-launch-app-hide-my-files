import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:media_scanner/media_scanner.dart';

import 'encryption_algorithms.dart';
import 'package:path/path.dart' as path;

class Loader extends StatefulWidget {
  
  var selectedFilesList;
  var origin;
  Loader({Key? key,required this.selectedFilesList,required this.origin}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {

  var jsonList;
  static var mainDirectory = "storage/emulated/0";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Navigator.pop(context);
    return Container(
      color:Colors.white60,
      child:const Center(
        child:SpinKitRing(color:Color(0xff32324f)),
      ),
    );
  }
}
