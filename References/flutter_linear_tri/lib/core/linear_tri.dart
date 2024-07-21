import 'dart:io';
import 'dart:convert';
import 'package:ml_linalg/linalg.dart';
import 'det.dart';

///
/// @Author: Abandoft Studio
/// @Date: 2022年2月17日21:42:13
///
/// 线弹性三角形单元有限元分析

/// main函数，程序入口
///
Future<void> main(List<String> arguments) async {
  var json = await parseJson();

  /// =================================================================
  /// ========================== 初始化参数 ============================
  /// =================================================================
  ///
  ///
  /// 1.问题类型信息，单元弹性模量、泊松比
  /// 平面应力问题   E   u
  /// 平面应变问题  E' = E / (1-u*u)   u' = u / (1 - u)
  ///
  var type = json["Type"];
  var poisson = (type == 0
      ? json["Poisson"].toDouble()
      : json["Poisson"].toDouble() / (1 - json["Poisson"].toDouble()));
  var elasticModulus = (type == 0
      ? json["ElasticModulus"].toDouble()
      : json["ElasticModulus"].toDouble() /
          (1 - json["Poisson"].toDouble() * json["Poisson"].toDouble()));
  var thickness = json["Thickness"];

  /// 2.节点坐标
  var points = json["points"];

  /// 3.单元
  List elements = json["elements"];

  /// 4.约束信息
  var constraints = json["constraints"];

  /// 5.节点荷载信息
  var forces = json["forces"];

  ///
  /// 节点是否有位移 的标记
  ///
  /// 例：
  /// flag = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0]，则
  /// flagIndex = [0, 0, 0, 0, 4, 5, 6, 7, 8, 9]
  ///
  ///
  List flag = List.generate(points.length * 2, (index) => 0);
  for (var sublist in constraints) {
    flag[sublist[0] * 2] = sublist[1];
    flag[sublist[0] * 2 + 1] = sublist[2];
  }

  /// ===================================================================
  /// ========================== 节点力列向量 ============================
  /// ===================================================================
  ///
  /// {F} 完整节点力列向量
  /// 元素初始化为0
  ///
  List nodeForce = List.generate(points.length * 2, (index) => 0.0);
  // 将JSON数据赋值给node_force
  for (var sublist in forces) {
    nodeForce[sublist[0] * 2] = sublist[1];
    nodeForce[sublist[0] * 2 + 1] = sublist[2];
  }

  ///
  /// 利用边界条件对`nodeForce`节点力列向量进行处理
  /// 返回用于`{F}=[K]{d}`的{F}向量calcNodeForce
  ///
  List<double> nodeForce2 = [];
  for (int i = 0; i < flag.length; i++) {
    if (flag[i] == 0) {
      nodeForce2.add(nodeForce[i].toDouble());
    }
  }
  Matrix calcNodeForce = Matrix.fromList([nodeForce2]);
  // Matrix calcNodeForce = Matrix([nodeForce2]).transpose();

  /// ===================================================================
  /// ========================== 结构刚度矩阵 ============================
  /// ===================================================================
  ///
  /// 1.初始化总刚度矩阵（未处理边界条件）
  /// 矩阵大小 节点数points数量 * 2， 元素全部赋初始值0.0
  ///
  Matrix stiffnessMatrix =
      Matrix.diagonal(List.generate(points.length * 2, (index) => 0.0));

  for (int i = 0; i < elements.length; i++) {
    var element = elements[i];

    /// 2.生成定位向量
    /// 例：
    ///
    /// quad.json
    /// [0, 1, 2, 3, 6, 7]
    /// [2, 3, 4, 5, 6, 7]

    List temp = List.generate(
        6,
        (index) => index % 2 == 0
            ? element[index ~/ 2] * 2
            : element[index ~/ 2] * 2 + 1);
    List elementPointsList = [...temp];

    /// 3.调用calcElementMatrix计算单元刚度矩阵
    ///
    Matrix elementStiffnessMatrix = calcElementMatrix(
        points[element[0]][0].toDouble(),
        points[element[0]][1].toDouble(),
        points[element[1]][0].toDouble(),
        points[element[1]][1].toDouble(),
        points[element[2]][0].toDouble(),
        points[element[2]][1].toDouble(),
        elasticModulus.toDouble(),
        poisson.toDouble(),
        thickness.toDouble());

    print("*********************************************");
    print("\n单刚矩阵[$i]\n$elementStiffnessMatrix");
    print("\n定位向量[$i]\n$elementPointsList");
    print("*********************************************");

    /// 4.组装总刚矩阵
    ///
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        // stiffnessMatrix[elementPointsList[i]][elementPointsList[j]] +=
        //     elementStiffnessMatrix[i][j];
        stiffnessMatrix = changeValueAt(
            stiffnessMatrix,
            elementPointsList[i],
            elementPointsList[j],
            stiffnessMatrix[elementPointsList[i]][elementPointsList[j]] +
                elementStiffnessMatrix[i][j]);
      }
    }
  }

  /// 5.根据边界条件处理总刚矩阵
  ///
  Matrix calcStiffnessMatrix = crossRowAndColumn(stiffnessMatrix, flag);

  ///
  /// =================================================================
  /// ============================= 求解 ==============================
  /// =================================================================
  ///
  /// `{x} = [K]^(-1) * {F}`求解未知节点位移
  ///
  var disp = reg(calcStiffnessMatrix).inverse() * calcNodeForce.transpose();

  print("\n总刚矩阵\n$stiffnessMatrix");
  print("\n缩减总刚矩阵\n$calcStiffnessMatrix");
  print("\n缩减总刚矩阵的逆\n${reg(calcStiffnessMatrix).inverse()}");
  print("\n缩减节点力列向量\n$calcNodeForce");
  print("\n缩减节点位移\n$disp");

  /// 写入文件
  ///
  // File file = File("text.txt");
  // var clear = file.openWrite();
  // clear.write('');
  // var pen = file.openWrite(mode: FileMode.append);
  // for (int i = 0; i < disp.rowsNum; i++) {
  //   for (int j = 0; j < disp.columnsNum; j++) {
  //     pen.write(disp[i][j]);
  //     pen.write(", ");
  //   }
  //   pen.write("\n");
  // }

  /// 完整节点位移
  ///
  // int pointer = 0;
  // var dispAll = Matrix.fromData(
  //     rows: points.length * 2,
  //     columns: 1,
  //     data: List.generate(points.length * 2,
  //         (index) => flag[index] == 1 ? [0.0] : [disp.call(pointer++, 1)]));

  /// 节点力
  ///
  ///
  // var nodeForceAll = stiffnessMatrix * dispAll;

  /// 单元主应力及应力主向
  ///
  //
  //
}

///
/// 解析JSON文件
///
/// 返回Map对象
///
Future<Map> parseJson() async {
  /// 解析JSON文件
  print('---------------------------------------------------------');
  print('请输入<当前目录>下的文件名:');
  print('不需要添加.json后缀，且文件名<仅支持英文>字符!');
  String fileName = stdin.readLineSync().toString();
  print('---------------------------------------------------------');

  var fileNameJson = './' + fileName + '.json';
  var jsonFile = File(fileNameJson);
  var json = jsonDecode(await jsonFile.readAsString());

  return Map.from(json);
}

///
/// 计算单元刚度矩阵
///
/// 返回单元刚度矩阵
///
/// 逆时针输入节点坐标信息，输入弹性模量 泊松比 厚度
///
Matrix calcElementMatrix(double xi, double yi, double xj, double yj, double xm,
    double ym, double elasticModulus, double poisson, double thickness) {
  // 计算面积的矩阵
  // Matrix area = Matrix.fromList([
  //   [1, xi, yi],
  //   [1, xj, yj],
  //   [1, xm, ym]
  // ]);
  double area = xj * ym + xi * yj + xm * yi - xj * yi - xi * ym - xm * yj;
  // 刚度矩阵参数
  // var ai = xj * ym - xm * yj;
  // var aj = xm * yi - xi * ym;
  // var am = xi * yj - xj * yi;
  var bi = yj - ym;
  var bj = ym - yi;
  var bm = yi - yj;
  var ci = xm - xj;
  var cj = xi - xm;
  var cm = xj - xi;

  // 刚度矩阵子块
  double type1(double br, double bs, double cr, double cs) {
    return br * bs + 0.5 * (1 - poisson) * cr * cs;
  }

  // 刚度矩阵子块
  double type2(double br, double bs, double cr, double cs) {
    return poisson * br * cs + 0.5 * (1 - poisson) * cr * bs;
  }

  // 刚度矩阵子块
  double type3(double br, double bs, double cr, double cs) {
    return poisson * cr * bs + 0.5 * (1 - poisson) * br * cs;
  }

  // 刚度矩阵子块
  double type4(double br, double bs, double cr, double cs) {
    return cr * cs + 0.5 * (1 - poisson) * br * bs;
  }

  // 系数
  double factor =
      elasticModulus * thickness / (2 * (1 - poisson * poisson) * area);

  // 数据
  var data = [
    [
      type1(bi, bi, ci, ci),
      type2(bi, bi, ci, ci),
      type1(bi, bj, ci, cj),
      type2(bi, bj, ci, cj),
      type1(bi, bm, ci, cm),
      type2(bi, bm, ci, cm)
    ],
    [
      type3(bi, bi, ci, ci),
      type4(bi, bi, ci, ci),
      type3(bi, bj, ci, cj),
      type4(bi, bj, ci, cj),
      type3(bi, bm, ci, cm),
      type4(bi, bm, ci, cm)
    ],
    [
      type1(bj, bi, cj, ci),
      type2(bj, bi, cj, ci),
      type1(bj, bj, cj, cj),
      type2(bj, bj, cj, cj),
      type1(bj, bm, cj, cm),
      type2(bj, bm, cj, cm)
    ],
    [
      type3(bj, bi, cj, ci),
      type4(bj, bi, cj, ci),
      type3(bj, bj, cj, cj),
      type4(bj, bj, cj, cj),
      type3(bj, bm, cj, cm),
      type4(bj, bm, cj, cm)
    ],
    [
      type1(bm, bi, cm, ci),
      type2(bm, bi, cm, ci),
      type1(bm, bj, cm, cj),
      type2(bm, bj, cm, cj),
      type1(bm, bm, cm, cm),
      type2(bm, bm, cm, cm)
    ],
    [
      type3(bm, bi, cm, ci),
      type4(bm, bi, cm, ci),
      type3(bm, bj, cm, cj),
      type4(bm, bj, cm, cj),
      type3(bm, bm, cm, cm),
      type4(bm, bm, cm, cm)
    ],
  ];

  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[0].length; j++) {
      data[i][j] *= factor;
    }
  }

  // 返回6*6的单元刚度矩阵
  return Matrix.fromList(data);
}

///
/// 矩阵Matrix对象划行划列，用于根据边界条件，处理总刚矩阵
///
/// 输入原始总刚矩阵`initialMatrix`、和标记列表`indexList`
///
/// 返回处理后的Matrix刚度矩阵对象
Matrix crossRowAndColumn(Matrix initialMatrix, List indexList) {
  // indexList非零元素的个数
  int flagCount = 0;
  for (var index in indexList) {
    if (index == 0) {
      flagCount++;
    }
  }

  // Matrix result = Matrix(rows: flagCount, columns: flagCount);
  Matrix result = Matrix.diagonal(List.generate(flagCount, (index) => 0.0));
  // 给result赋值需要的位置标记
  int pointerX = 0;
  int pointerY = 0;
  for (int i = 0; i < indexList.length; i++) {
    if (indexList[i] == 1) {
      continue;
    } else {
      for (int j = 0; j < indexList.length; j++) {
        if (indexList[j] == 1) {
          continue;
        } else {
          result =
              changeValueAt(result, pointerX, pointerY, initialMatrix[i][j]);
          pointerY++;
        }
      }
      pointerX++;
      pointerY = 0;
    }
  }

  return result;
}
