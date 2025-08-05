import 'dart:typed_data';

import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

class TestHelper {

  static VentLatestData dummyVentData({
    int? totalLikes = 0, 
    bool? isPostSaved = false
  }) {
    return VentLatestData(
      title: '', 
      bodyText: '', 
      tags: '', 
      postTimestamp: '', 
      creator: '', 
      profilePic: Uint8List(0),
      totalLikes: totalLikes!,
      isPostSaved: isPostSaved!
    );
  }

}