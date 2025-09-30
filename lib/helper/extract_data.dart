import 'package:mysql_client/mysql_client.dart';

class ExtractData {

  List<dynamic>? data;
  IResultSet? rowsData;

  ExtractData({this.data, this.rowsData});

// TODO: Get rid of these two and make data required

  /// Extracts a list of [String] values from the specified [columnName].
  /// 
  /// Assumes the column values are non-null strings.

  List<String> extractStringColumn(String columnName) {
    return rowsData!.rows.map((row) {
      return row.assoc()[columnName]!;
    }).toList();
  }

  /// Extracts a list of [int] values from the specified [columnName].
  /// 
  /// Parses string values to integers, defaulting to 0 if parsing fails.
   
  List<int> extractIntColumn(String columnName) {
    return rowsData!.rows.map((row) {
      final value = row.assoc()[columnName]!;
      return int.tryParse(value) ?? 0;
    }).toList();
  }

  /// Returns all values for [header] from [data] as a List<T>.

  List<T> extractColumn<T>(String header) {

    if (data == null || data!.isEmpty) {
      return <T>[];
    }

    return data!
      .map((value) => (value as Map<String, dynamic>)[header] as T)
      .toList();
      
  }
  
}