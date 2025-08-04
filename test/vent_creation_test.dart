import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';
// TODO: Create test_helpers and store this dummy data there

VentLatestData _dummyVentData({
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

void main() {

  final ventProvider = VentLatestProvider();  

  group('Vent Create/Delete', () {

    test('Should have more than 0 vents when user created a post', () {

      ventProvider.addVent(_dummyVentData());

      expect(ventProvider.vents.length, greaterThan(0));

    });

    test('Should have less than 1 vents when user deleted a post', () {

      ventProvider.deleteVent(0);

      expect(ventProvider.vents.length, lessThan(1));

    });

  });


}