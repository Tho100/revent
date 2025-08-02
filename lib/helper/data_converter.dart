import 'dart:convert';
import 'dart:typed_data';

class DataConverter {
  
  /// Converts a list of Base64 string into list of Uint8List.
  ///
  /// [profilePictures] A list of Base64 string representing the pfp original data.
  
  static List<Uint8List> convertToPfp(List<String> profilePictures) {
    return profilePictures.map((pfp) => base64Decode(pfp)).toList();
  }

  /// Converts a list of integer NSFW flags into a list of boolean values.
  ///
  /// Each non-zero integer is interpreted as [True], zero as [False].
  /// 
  /// [nsfwMarks] A list of integers representing NSFW flags.
 // TODO: Make it more general e.g name rename the parameter to values
  static List<bool> convertToBools(List<int> nsfwMarks) {    
    return nsfwMarks.map((isNsfw) => isNsfw != 0).toList();
  }

  static int convertBoolToInt(bool value) => value ? 1 : 0;

}
