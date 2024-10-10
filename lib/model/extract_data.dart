import 'package:mysql_client/mysql_client.dart';

class ExtractData {

  final IResultSet rowsData;

  ExtractData({
    required this.rowsData
  });

  List<String> extractStringColumn(String columnName) {
    return rowsData.rows.map((row) {
      return row.assoc()[columnName]!;
    }).toList();
  }

  List<int> extractIntColumn(String columnName) {
    return rowsData.rows.map((row) {
      final value = row.assoc()[columnName]!;
      return int.tryParse(value) ?? 0;
    }).toList();
  }
  
}