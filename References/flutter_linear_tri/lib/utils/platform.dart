import 'dart:io';

bool isMobile() {
  if (Platform.isAndroid) {
    return true;
  }
  if (Platform.isIOS) {
    return true;
  }
  if (Platform.isFuchsia) {
    return true;
  }
  return false;
}

bool isDesktop() {
  if (Platform.isWindows) {
    return true;
  }
  if (Platform.isMacOS) {
    return true;
  }
  if (Platform.isLinux) {
    return true;
  }
  return false;
}

bool isAndroid() {
  if (Platform.isAndroid) {
    return true;
  } else {
    return false;
  }
}
isWindows(){
  if (Platform.isWindows) {
    return true;
  } else {
    return false;
  }
}