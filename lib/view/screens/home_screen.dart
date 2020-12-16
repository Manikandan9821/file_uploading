import 'dart:io';

import '../../logics/providers/file_provider.dart';
import 'file_screen.dart';
import '../widgets/failure.dart';
import '../widgets/file_button.dart';
import '../widgets/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _showDialog(String msg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(status: msg));
  }

  _downloadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'pdf',
        'doc',
        'png',
        'xsl',
        'txt',
        'docx',
        'csv',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      try {
        _showDialog('Uploading File...');
        await Provider.of<FileProvider>(context, listen: false)
            .uploadFile(File(result.files.single.path), file.name);
        Navigator.of(context).pop();
        _showSnackBar('File is successfully Uploaded');
      } on Failure catch (e) {
        Navigator.of(context).pop();
        _showSnackBar(e.toString());
      }
    } else {
      print('user cancel file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FileButton(
              color: Colors.red,
              title: 'Upload File',
              iconData: Icons.upload_file,
              onPressed: _downloadFile,
            ),
            SizedBox(
              height: 20.0,
            ),
            FileButton(
              color: Colors.green,
              title: 'View File',
              iconData: Icons.download_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
