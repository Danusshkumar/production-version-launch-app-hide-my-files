import 'package:flutter/material.dart';
import 'package:launch_app/file_pages.dart';

class Excel extends StatelessWidget {
  const Excel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FilePages(pageType: 'excel');
  }
}
