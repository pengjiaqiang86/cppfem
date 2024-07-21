var version = 10405;

var mds = '# Markdown Editor : )';

var fileDir = '';

List<String> mdFiles = [];

bool isFirstBootForUser = false;

// 设置Markdown页面和文件管理页面切换
bool isFilePage = false;

// Webdav功能
bool isBind = false;
String webdavUrl = '';
String webdavUser = '';
String webdavPassword = '';
