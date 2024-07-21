import 'package:ml_linalg/linalg.dart';

// dependencies:
//   ml_linalg: ^13.3.3

///
///
///
Matrix changeRow(Matrix mat, int row, Vector vector) {
  ///
  /// 异常处理
  /// 泛型
  ///
  return Matrix.fromList(List.generate(
      mat.rowsNum,
      (rowIndex) => List.generate(mat.columnsNum, (columnIndex) {
            return (row == rowIndex)
                ? vector.toList()[columnIndex]
                : mat[rowIndex][columnIndex];
          })));
}

Matrix changeValueAt(Matrix mat, int row, int column, double data) {
  ///
  /// 异常处理
  /// 泛型
  ///
  return Matrix.fromList(List.generate(
      mat.rowsNum,
      (rowIndex) => List.generate(mat.columnsNum, (columnIndex) {
            return (rowIndex == row && columnIndex == column)
                ? data
                : mat[rowIndex][columnIndex];
          })));
}

Matrix reg(Matrix matrix) {
  for (var i = 0; i < matrix.columnsNum; i++) {
    ///
    /// 遍历矩阵的(i, i)元素，若为0，.....
    ///
    if (matrix[i][i] == 0) {
      ///
      /// 从第一行遍历
      ///
      for (var j = 0; j < matrix.columnsNum; j++) {
        ///
        /// 若遍历到i行，跳过；
        /// 遍历到(j, i)不为0的元素时，将此行(j)行加到i行，使(i, i)元素不为0；
        /// 完成遍历后，若i列元素都为零，表示行列式为0，返回[[0]];
        ///
        if (j == i || (matrix[j][i] == 0 && j < matrix.columnsNum)) {
          continue;
        } else if (matrix[j][i] != 0) {
          ///
          /// matrix的第i行元素
          ///
          var vect = matrix[j] + matrix[i];
          // print(vect);

          ///
          /// 遍历到第一个(j, i)不为0的元素时，提取此行，构造rowsNum * columnsNum的
          /// 矩阵，将该行放在第i行，其余行元素都为0
          ///

          //
          // Matrix matTemp = Matrix.fromList(List.generate(
          //     matrix.columnsNum,
          //     (index) => index == i
          //         ? vect.toList()
          //         : List.filled(matrix.rowsNum, 0.0)));

          ///
          /// 原矩阵`matrix`加·`matTemp`使matrix[i][i]不为0；
          /// 退出循环
          ///
          // print("matrix $matrix");
          // print("matTemp $matTemp");
          //
          // matrix += matTemp;
          matrix = changeRow(matrix, i, vect);
          print(matrix);
          break;
        } else {
          return Matrix.fromList([
            [0]
          ]);
        }
      }
    }
  }
  return matrix;
}

double det(Matrix matrix) {
  var det = 1.0;

  matrix = reg(matrix);

  final lu = matrix.decompose(Decomposition.LU);
  for (var i = 0; i < lu.first.columnsNum; i++) {
    det *= lu.first[i][i];
  }
  for (var i = 0; i < lu.last.columnsNum; i++) {
    det *= lu.last[i][i];
  }

  return det;
}

main(List<String> args) {
  var xi = 18.4776;
  var yi = 7.6537;
  var xj = 24.0;
  var yj = 9.9411;
  var xm = 19.9553;
  var ym = 13.3337;

  Matrix area = Matrix.fromList([
    [1, xi, yi],
    [1, xj, yj],
    [1, xm, ym]
  ]);

  print(2 * det(area) * (1 - 0.25 * 0.25));
}
