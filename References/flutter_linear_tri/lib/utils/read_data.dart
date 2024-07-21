import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../res/string/string.dart';

readData() async {
  mdFiles = [];
  // 读取Markdown文件

  var filePath = Directory('');
  // if (isAndroid()) {
  //   filePath = Directory('/storage/emulated/0/Documents//Meditor');
  // } else if (isDesktop()) {
  //   Directory? appDocDir = await getApplicationDocumentsDirectory();
  //   filePath =
  //       Directory(appDocDir.path + (isWindows() ? '\\' : '/') + 'Meditor');
  // }
  Directory? appDocDir = await getApplicationDocumentsDirectory();
  // /data/user/0/com.moluopro.meditor/app_flutter/Meditor/111.md
  // C:\Users\MoLuo\Documents/Meditor/111.md

  // Directory? appDocDir = await getApplicationSupportDirectory();
  // /data/user/0/com.moluopro.meditor/files/Meditor/111.md
  // C:\Users\MoLuo\AppData\Roaming\com.moluopro\meditor/Meditor/111.md

  filePath = Directory(appDocDir.path + '/Meditor');
  fileDir = filePath.path;

  if ((await filePath.exists())) {
  } else {
    filePath.create();
  }
  filePath
      .list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) {
    if (entity.path.contains('.md')) {
      mdFiles.add(entity.path);
    }
  });

}
