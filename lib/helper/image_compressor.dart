import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';

class ImageCompressor {

  static Future<List<int>> compressedByteImage({
    required String path,
    required int quality,
  }) async {

    File? compressedFile = await _processImageCompression(path: path, quality: quality);

    return await compressedFile.readAsBytes();

  }

  static Future<File> _processImageCompression({
    required String path, 
    required int quality
    }) async {

    final compressedFile = await FlutterNativeImage.compressImage(
      path,
      quality: quality,
    );
    
    return Future.value(compressedFile);
    
  }
  
}