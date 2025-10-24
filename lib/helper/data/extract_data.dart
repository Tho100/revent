class ExtractData {

  List<dynamic>? data;

  ExtractData({this.data});

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