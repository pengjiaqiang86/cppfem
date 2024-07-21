import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'page/myapp.dart';
import 'utils/preboot.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preBoot();

  runApp(Phoenix(child: MyApp()));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}