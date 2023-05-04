import 'package:flutter/material.dart';
import 'package:launch_app/file_pages.dart';

class PDF extends StatelessWidget {
  const PDF({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FilePages(pageType: 'pdf');
  }
}
