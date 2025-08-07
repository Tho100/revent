import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:revent/shared/themes/theme_color.dart';

class ProfilePicturePicker {

  Future<SelectedImagesDetails?> imagePicker(BuildContext context) async {

    final picker = ImagePickerPlus(context);

    return await picker.pickImage(
      source: ImageSource.both,
      multiImages: false,
      galleryDisplaySettings: _buildGalleryDisplaySettings(),
    );

  }

  GalleryDisplaySettings _buildGalleryDisplaySettings() {
    return GalleryDisplaySettings(
    showImagePreview: true,
    tabsTexts: TabsTexts(
      videoText: '',
      photoText: '',
      noImagesFounded: 'Gallery Is Empty',
      acceptAllPermissions: 'Permission Denied',
      clearImagesText: 'Clear Selections',
    ),
    maximumSelection: 1,
      appTheme: AppTheme(
        focusColor: ThemeColor.contentPrimary,
        primaryColor: ThemeColor.backgroundPrimary,
      ),
    );
  }

}