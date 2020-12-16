import '../../logics/helper/db_helper.dart';
import '../../logics/model/file_model.dart';
import '../../logics/providers/file_provider.dart';
import '../widgets/failure.dart';
import '../widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FileScreen extends StatefulWidget {
  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _showDialog(
    String msg,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(status: msg));
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  _downloadFile(String fileName, String fileUrl) async {
    if (await _requestPermission(Permission.storage)) {
      try {
        _showDialog('Downloading File...');
        await Provider.of<FileProvider>(context, listen: false)
            .downloadFile(fileUrl, fileName);
        Navigator.of(context).pop();
        _showSnackBar('File is successfully Downloaded');
      } on Failure catch (e) {
        Navigator.of(context).pop();
        _showSnackBar(e.toString());
      }
    } else {
      _showSnackBar('Please Enable Storage Permission');
    }
  }

  void _deleteFile(int id) async {
    await DBHelper.db.deletefile(id);
    _showSnackBar('Item is Deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('File Download'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<FileModel>>(
            future: DBHelper.db.getAllFiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                );
              }
              if (snapshot.hasError) {
                return Text('No Data Availble Here');
              }
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, i) {
                    return Divider(
                        height: 5.0, thickness: 0.5, color: Colors.black45);
                  },
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    var index = i + 1;
                    return Dismissible(
                      key: Key(snapshot.data[i].toString()),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        _deleteFile(snapshot.data[i].id);
                      },
                      child: ListTile(
                        leading: Text(index.toString()),
                        title: Text(snapshot.data[i].fileName),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.file_download,
                            color: Colors.green,
                            size: 20.0,
                          ),
                          onPressed: () => _downloadFile(
                              snapshot.data[i].fileName,
                              snapshot.data[i].fileUrl),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
