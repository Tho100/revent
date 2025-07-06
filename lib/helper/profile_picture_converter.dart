import 'dart:convert';
import 'dart:typed_data';

class ProfilePictureConverter {

  /// Converts a list of Base64 string into list of Uint8List.
  ///
  /// [profilePictures] A list of Base64 string representing the pfp original data.
    
  static List<Uint8List> convertToPfp(List<String> profilePictures) {
    return profilePictures.map((pfp) => base64Decode(pfp)).toList();
  }

}