import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:equations/equations.dart';

///
/// `Structural mechanics problem solver`
/// 矩阵位移法（后处理法）计算简单结构力学问题
///
/// 梁单元受节点荷载(暂不支持跨中受荷载及分布荷载)
///
/// 固定铰支座、可动铰支座、定向支座、固定支座（仅沿x、y方向）
///
/// 节点力以与坐标轴正向一致为正；以逆时针旋转为正；JSON文件中，节点、单元均以0开始编号
///
/// @Version: 1.0
///
/// @Author: Abandoft Studio
///
/// @Date: 2022/2/6 19:14:46
///

/// ***************************************************************************
/// ****************************** 函数入口 ************************************
/// ***************************************************************************
main(List<String> args) async {
  // 解析JSON文件
  var json = await parseJson();

  /// 初始化参数
  ///
  ///
  var materials = json["materials"];
  var points = json["points"];
  var elements = json["elements"];
  var release = json["release"];
  var constraints = json["constraints"];
  var forces = json["forces"];

  // print(materials);                    // [[1, 1, 1], [2, 2, 2]]
  // print(materials.runtimeType);        // List<dynamics>
  // print(materials[0]);                 // [1, 1, 1]
  // print(materials[0].runtimeType);     // List<dynamics>
  // print(materials[0][0]);              // 1
  // print(materials[0][0].runtimeType);  // int

  ///
  /// 整体坐标系下结构刚度矩阵
  ///
  /// 赋空值
  RealMatrix structureStiffnessMatrix =
      RealMatrix(rows: points.length * 3, columns: points.length * 3);

  List<RealMatrix> elementStiffnessMatrix =
      List.generate(elements.length, (index) {
    // 点i的索引值
    int pointI = elements[index][0];
    // 点i的坐标
    List pointICoor = points[pointI];
    // 点j索引值
    int pointJ = elements[index][1];
    // 点j坐标值
    List pointJCoor = points[pointJ];
    // 材料参数
    List material = materials[elements[index][2]];
    return calcElementStiffnessMatrix(pointICoor[0], pointICoor[1],
        pointJCoor[0], pointJCoor[1], material[0], material[1], material[2]);
  });

  ///
  /// 组装总刚矩阵
  ///
  ///
  for (int i = 0; i < elementStiffnessMatrix.length; i++) {
    // 获取单元刚度矩阵
    RealMatrix stiffnessMatrix = elementStiffnessMatrix[i];

    for (var re in release) {
      if (re[0] == i) {
        List flag = re.sublist(1);
        stiffnessMatrix = elementStiffnessRelease(stiffnessMatrix, flag);
      }
    }

    structureStiffnessMatrix = assembleStiffnessMatrix(structureStiffnessMatrix,
        stiffnessMatrix, elements[i][0], elements[i][1]);
  }

  print("structureStiffnessMatrix\n$structureStiffnessMatrix");

  ///
  /// 处理边界条件
  ///
  /// 是否有位移的标记
  List<int> constraintFlag = List.filled(points.length * 3, 0);
  for (var constraint in constraints) {
    int index = constraint[0];
    constraintFlag[index * 3] = constraint[1];
    constraintFlag[index * 3 + 1] = constraint[2];
    constraintFlag[index * 3 + 2] = constraint[3];
  }
  int count = 0;
  for (var i in constraintFlag) {
    if (i == 0) {
      count++;
    }
  }

  // 节点力向量
  List<double> nodeForce = List.generate(points.length * 3, (index) => 0.0);
  for (var force in forces) {
    int index = force[0];
    nodeForce[index * 3] = force[1];
    nodeForce[index * 3 + 1] = force[2];
    nodeForce[index * 3 + 2] = force[3];
  }
  // 根据边界条件处理节点力列向量
  RealMatrix calcForce = crossElement(nodeForce, constraintFlag);
  print("\ncalcForce\n$calcForce");

  structureStiffnessMatrix =
      crossRowAndColumn(structureStiffnessMatrix, constraintFlag);

  print("\nstructureStiffnessMatrix\n$structureStiffnessMatrix");

  ///
  /// 求解结构坐标系下节点位移
  ///

  RealMatrix calcStiffnessMatrix = structureStiffnessMatrix.inverse();

  RealMatrix displacement = calcStiffnessMatrix * calcForce as RealMatrix;
  print("\ndisplacement\n$displacement");
  // print(calcStiffnessMatrix);
  // print("structureStiffnessMatrix\n$structureStiffnessMatrix");
  // print(calcForce);
}

/// ***************************************************************************
/// ****************************** 其他函数 ************************************
/// ***************************************************************************

///
/// 解析JSON文件
///
/// 返回Map对象
///
Future<Map> parseJson() async {
  /// 解析JSON文件
  print('---------------------------------------------------------');
  print('请输入<当前目录>下的文件名：');
  print('不需要添加.json后缀，且文件名<仅支持英文>字符！');
  String file_name = stdin.readLineSync().toString();
  print('---------------------------------------------------------');

  var file_name_json = './' + file_name + '.json';
  var json_file = File(file_name_json);
  var json = jsonDecode(await json_file.readAsString());

  return new Map.from(json);
}

///
/// 计算旋转矩阵
///

RealMatrix calcRotationMatrix(double sinTheta, double cosTheta) {
  return RealMatrix.fromData(rows: 6, columns: 6, data: [
    [cosTheta, sinTheta, 0, 0, 0, 0],
    [-sinTheta, cosTheta, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0],
    [0, 0, 0, cosTheta, sinTheta, 0],
    [0, 0, 0, -sinTheta, cosTheta, 0],
    [0, 0, 0, 0, 0, 1]
  ]);
}

///
/// 输入i、j点坐标信息、弹性模量、面积、惯性矩
///
/// 计算并返回`单元刚度矩阵`，考虑角度
///

RealMatrix calcElementStiffnessMatrix(
    double xi, double yi, double xj, double yj, double e, double i, double a) {
  // x、y方向的坐标变化量
  double xDisp = xj - xi;
  double yDisp = yj - yi;

  // 杆长
  double length = sqrt(pow(xDisp, 2) + pow(yDisp, 2));
  assert(length != 0);

  // 杆的角度 正余弦值
  double sinTheta = 0.0;
  double cosTheta = 0.0;
  if (yDisp == 0 && xj > xi) {
    sinTheta = 0.0;
    cosTheta = 1.0;
  } else if (yDisp == 0 && xj < xi) {
    sinTheta = 0.0;
    cosTheta = -1.0;
  } else if (xDisp == 0 && yj > yi) {
    sinTheta = 1.0;
    cosTheta = 0.0;
  } else if (xDisp == 0 && yj < yi) {
    sinTheta = -1.0;
    cosTheta = 0.0;
  } else {
    sinTheta = yDisp / length;
    cosTheta = xDisp / length;
  }

  //
  // 计算杆件单元刚度矩阵，不考虑角度
  //
  // ````````````````````太丑了````````````````````
  //
  RealMatrix elementStiffnessMatrix =
      RealMatrix.fromData(rows: 6, columns: 6, data: [
    [e * a / length, 0, 0, -e * a / length, 0, 0],
    [
      0,
      12 * e * i / pow(length, 3),
      6 * e * i / pow(length, 2),
      0,
      -12 * e * i / pow(length, 3),
      6 * e * i / pow(length, 2)
    ],
    [
      0,
      6 * e * i / pow(length, 2),
      4 * e * i / length,
      0,
      -6 * e * i / pow(length, 2),
      2 * e * i / length
    ],
    [-e * a / length, 0, 0, e * a / length, 0, 0],
    [
      0,
      -12 * e * i / pow(length, 3),
      -6 * e * i / pow(length, 2),
      0,
      12 * e * i / pow(length, 3),
      -6 * e * i / pow(length, 2)
    ],
    [
      0,
      6 * e * i / pow(length, 2),
      2 * e * i / length,
      0,
      -6 * e * i / pow(length, 2),
      4 * e * i / length
    ]
  ]);

  RealMatrix rotationMatrix = calcRotationMatrix(sinTheta, cosTheta);

  // print("--------------------------------");
  // print("elementStiffnessMatrix -> $elementStiffnessMatrix");
  // print("--------------------------------");
  // print("rotationMatrix -> $rotationMatrix");

  return rotationMatrix.transpose() * elementStiffnessMatrix * rotationMatrix
      as RealMatrix;
}

///
/// 组装总刚矩阵
///

RealMatrix assembleStiffnessMatrix(RealMatrix stiffnessMatrix,
    RealMatrix elementStiffnessMatrix, int indexI, int indexJ) {
  /// 将一个单刚矩阵组装到总刚矩阵

  /// -----------------------------------------------------
  /// -------------------验证数据合法性---------------------
  /// -----------------------------------------------------

  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 6; j++) {
      int posX = (i < 3 ? indexI : indexJ) * 3 + (i < 3 ? i : i - 3);
      int posY = (j < 3 ? indexI : indexJ) * 3 + (j < 3 ? j : j - 3);
      double data = elementStiffnessMatrix.call(i, j);
      stiffnessMatrix = changeValue(stiffnessMatrix, posX, posY, data);
    }
  }

  return stiffnessMatrix;
}

///
/// 改矩阵的值
///
///
RealMatrix changeValue(RealMatrix mat, int posX, int posY, double data) {
  var mat2List = mat.toListOfList();
  mat2List[posX][posY] += data;

  return RealMatrix.fromData(
      rows: mat.rowCount, columns: mat.columnCount, data: mat2List);
}

///
/// 矩阵Matrix对象划行划列，用于根据边界条件，处理总刚矩阵
///
/// 输入原始总刚矩阵`initialMatrix`、和标记列表`indexList`
///
/// 返回处理后的Matrix刚度矩阵对象
RealMatrix crossRowAndColumn(RealMatrix initialMatrix, List indexList) {
  // indexList非零元素的个数
  int flagCount = 0;
  for (var index in indexList) {
    if (index == 0) {
      flagCount++;
    }
  }
  // print("flagCount\n" + "$flagCount");

  RealMatrix result = RealMatrix(rows: flagCount, columns: flagCount);
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
              changeValue(result, pointerX, pointerY, initialMatrix.call(i, j));
          pointerY++;
        }
      }
      pointerX++;
      pointerY = 0;
    }
  }

  return result;
}

RealMatrix crossElement(List<double> force, List<int> flag) {
  List<List<double>> forces = [[]];
  int num = 0;
  for (int i = 0; i < flag.length; i++) {
    if (flag[i] == 0) {
      forces.add([force[i]]);
      num++;
      // print("num $num");
      // print("force[i] ${force[i]}");
    }
  }
  return RealMatrix.fromData(rows: num, columns: 1, data: forces);
}

RealMatrix elementStiffnessRelease(RealMatrix stiffnessMatrix, List flag) {
  for (int i = 0; i < flag.length; i++) {
    if (flag[i] == 1) {
      stiffnessMatrix = changeValue(stiffnessMatrix, i, 0, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, i, 1, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, i, 2, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, i, 3, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, i, 4, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, i, 5, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, 0, i, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, 1, i, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, 2, i, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, 3, i, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, 4, i, 0.0);
      stiffnessMatrix = changeValue(stiffnessMatrix, 5, i, 0.0);
    }
  }
  return stiffnessMatrix;
}
