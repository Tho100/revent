import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

VentLatestData _dummyVentData() {
  return VentLatestData(
    title: '', 
    bodyText: '', 
    tags: '', 
    postTimestamp: '', 
    creator: '', 
    profilePic: Uint8List(0),
    totalLikes: 0
  );
}

void main() {

  late VentLatestProvider ventProvider;

  const postIndex = 0;

  setUp(() {
    getIt.reset();
    getIt.registerLazySingleton<VentLatestProvider>(() => VentLatestProvider());
    ventProvider = getIt<VentLatestProvider>();
    ventProvider.setVents([_dummyVentData()]);
  });

  group('Vent Like/Dislike', () {

    test('Like count increment test', () {

      const isUserLikedPost = false;

      ventProvider.setVents([_dummyVentData()]);

      ventProvider.likeVent(postIndex, isUserLikedPost);    

      expect(ventProvider.vents[postIndex].totalLikes, equals(1));

    });

    test('Like count decrement test', () {

      const isUserLikedPost = true;

      ventProvider.setVents([_dummyVentData()]);

      ventProvider.likeVent(postIndex, isUserLikedPost);    

      expect(ventProvider.vents[postIndex].totalLikes, equals(-1));

    });

  });

}