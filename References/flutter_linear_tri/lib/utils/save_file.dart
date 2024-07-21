import 'dart:io';

import '/res/string/string.dart';

saveFile(String fileName) async {
  File file = File(fileDir + '/${fileName.split('.md').first}.md');
  try {
    // 向文件写入字符串
    await file.writeAsString(mds);
  } catch (e) {
    // print(e);
  }
}
