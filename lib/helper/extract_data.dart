import 'package:mysql_client/mysql_client.dart';

class ExtractData {

  final IResultSet rowsData;

  ExtractData({required this.rowsData});

  /// Extracts a list of [String] values from the specified [columnName].
  /// 
  /// Assumes the column values are non-null strings.

  List<String> extractStringColumn(String columnName) {
    return rowsData.rows.map((row) {
      return row.assoc()[columnName]!;
    }).toList();
  }

  /// Extracts a list of [int] values from the specified [columnName].
  /// 
  /// Parses string values to integers, defaulting to 0 if parsing fails.
   
  List<int> extractIntColumn(String columnName) {
    return rowsData.rows.map((row) {
      final value = row.assoc()[columnName]!;
      return int.tryParse(value) ?? 0;
    }).toList();
  }
  
}