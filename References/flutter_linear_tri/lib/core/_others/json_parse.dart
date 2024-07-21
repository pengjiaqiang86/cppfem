import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  print('---------------------------------------------------------');
  print('请输入<当前目录>下的文件名：');
  print('不需要添加.json后缀，且文件名<仅支持英文>字符！');
  print('程序执行结束后，将在当前目录生成一个同名的txt文件。');
  print('---------------------------------------------------------');
  print('Please enter the name of the file in the current directory.');
  print('And the file name only supports English without adding a suffix!');
  print(
      'After the program is executed, a txt file with the same name will be generated in the current directory.');
  print('---------------------------------------------------------');
  String file_name = stdin.readLineSync().toString();
  var file_name_json = './' + file_name + '.json';
  var json_file = File(file_name_json);
  var file = File('$file_name.txt');
  var json = jsonDecode(await json_file.readAsString());
  var clear = file.openWrite();
  clear.write('');
  var pen = file.openWrite(mode: FileMode.append);
  pen.write(json['points'].length);
  pen.write(',');
  pen.write(json['elements'].length);
  pen.write(',');
  pen.write(json['constraints'].length);
  pen.write(',');
  pen.write(json['forces'].length);
  pen.write(',');
  pen.write(json['Type']);
  pen.write('\r\n');
  pen.write(json['ElasticModulus']);
  pen.write(',');
  pen.write(json['Poisson']);
  pen.write(',');
  pen.write(json['Thickness']);
  pen.write(',');
  pen.write(json['VolumetricWeight']);
  pen.write('\r\n');
  for (var index = 0; index < json['elements'].length; index++) {
    for (var i = 0; i < json['elements'][index].length; i++) {
      int data = json['elements'][index][i] + 1;
      pen.write(data);
      if ((i + 1) != json['elements'][index].length) {
        pen.write(',');
      }
    }
    pen.write('\r\n');
  }

  for (var index = 0; index < json['points'].length; index++) {
    for (var i = 0; i < json['points'][index].length; i++) {
      pen.write(json['points'][index][i]);
      if ((i + 1) != json['points'][index].length) {
        pen.write(',');
      }
    }
    pen.write('\r\n');
  }

  for (var index = 0; index < json['constraints'].length; index++) {
    for (var i = 0; i < json['constraints'][index].length; i++) {
      pen.write(i == 0
          ? json['constraints'][index][i] + 1
          : json['constraints'][index][i]);
      if ((i + 1) != json['constraints'][index].length) {
        pen.write(',');
      }
    }
    pen.write('\r\n');
  }

  for (var index = 0; index < json['forces'].length; index++) {
    for (var i = 0; i < json['forces'][index].length; i++) {
      pen.write(
          i == 0 ? json['forces'][index][0] + 1 : json['forces'][index][i]);
      if ((i + 1) != json['forces'][index].length) {
        pen.write(',');
      }
    }
    // if ((index + 1) != json['forces'].length) {
    //   pen.write('\r\n');
    // }
    pen.write('\r\n');
  }

  await pen.flush();
  await pen.close();
}
