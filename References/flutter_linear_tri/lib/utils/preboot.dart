import '/res/string/string.dart';
import '/utils/platform.dart';
import '/utils/read_data.dart';
import '/utils/set_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import '../res/i18n/lang.dart';
import '../res/i18n/zh_json.dart';
import '../res/i18n/en_json.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

preBoot() async {
  final _prefs = await SharedPreferences.getInstance();

  // 设置语言
  bool isFirstBoot = _prefs.getBool('first_boot') ?? true;

  // 设置用户协议
  isFirstBootForUser = _prefs.getBool('first_boot_user') ?? true;

  // 设置编辑器文本
  mds = _prefs.getString('mds') ?? mds;

  // 检测webdav是否登录
  webdavUrl = _prefs.getString('webdav_url') ?? '';
  webdavUser = _prefs.getString('webdav_account') ?? '';
  webdavPassword = _prefs.getString('webdav_key') ?? '';

  if (!(webdavUrl.isEmpty || webdavUrl.isEmpty || webdavUrl.isEmpty)) {
    isBind = true;
  }

  if (isFirstBoot) {
    String getLang = Get.deviceLocale?.languageCode ?? 'en';
    if (getLang == 'zh') {
      lang = zhJson;
      _prefs.setString('lang', 'zh');
    } else {
      lang = enJson;
      _prefs.setString('lang', 'en');
    }
    _prefs.setBool('first_boot', false);
  } else if (_prefs.getString('lang') == 'zh') {
    lang = zhJson;
  } else {
    lang = enJson;
  }

  // 读取主题数据
  int theme = _prefs.getInt('theme') ?? 0;
  setTheme(theme);

  // 读取Markdown文件
  readData();

  if (isAndroid()) {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
  }

  // You can request multiple permissions at once.
  // Map<Permission, PermissionStatus> statuses = await [
  //   Permission.storage,
  // ].request();
}
