import 'dart:io';

import 'package:dio/dio.dart';
import '../constants/app_url.dart';
import '../helper/db_helper.dart';
import '../model/file_model.dart';
import '../../view/widgets/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class FileProvider extends ChangeNotifier {
  Future<void> uploadFile(File files, String fileName) async {
    final url =
        '${AppUrl.BASE_URL}${AppUrl.API_KEY}${AppUrl.APP_ID}files/testing/$fileName';

    try {
      final dio = Dio();
      FormData data = FormData.fromMap({
        "upload": await MultipartFile.fromFile(
          files.path,
        ),
      });
      final response = await dio.post(url, data: data);
      print(response);
      print(
          'Response : ${response.data} \n FileUrl : ${response.data['fileURL']}');

      final file = FileModel(
        fileName: fileName.toString(),
        fileUrl: response.data['fileURL'].toString(),
      );

      await DBHelper.db.insertData(
        file,
      );
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(message: 'No Internet Connection');
      }
      throw Failure(message: e.error.toString());
    }
  }

  downloadFile(String fileUrl, String fileName) async {
    Directory directory;
    directory = await getExternalStorageDirectory();
    String newPath = "";
    print(directory);
    List<String> paths = directory.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      newPath += "/" + folder;
    }
    newPath = newPath + "/File App";
    directory = Directory(newPath);

    File saveFile = File(directory.path + "/$fileName");
    try {
      final dio = Dio();
      await dio.download(fileUrl, saveFile.path);
      final image = await ImageGallerySaver.saveFile(saveFile.path);
      print('image $image');
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(message: 'No Internet Connection');
      }
      throw Failure(message: e.error.toString());
    }
  }
}
