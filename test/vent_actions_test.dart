import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

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

  late VentLatestProvider ventProvider;

  const postIndex = 0;

  setUp(() {
    getIt.reset();
    getIt.registerLazySingleton<VentLatestProvider>(() => VentLatestProvider());
    ventProvider = getIt<VentLatestProvider>();
    ventProvider.setVents([_dummyVentData()]);
  });

  group('Vent Like/Dislike', () {

    test('Should increment totalLikes when user likes a post', () {

      const isUserLikedPost = false;

      ventProvider.setVents([_dummyVentData()]);
      ventProvider.likeVent(postIndex, isUserLikedPost);    

      expect(ventProvider.vents[postIndex].totalLikes, equals(1));

    });

    test('Should decrement totalLikes when user unlikes a post', () {

      const isUserLikedPost = true;

      ventProvider.setVents([_dummyVentData()]);
      ventProvider.likeVent(postIndex, isUserLikedPost);    

      expect(ventProvider.vents[postIndex].totalLikes, equals(-1));

    });

  });

  group('Vent Save/Unsave', () {

    test('Should set isPostSaved to true when user saves a post', () {

      const isUserSavedPost = false;

      ventProvider.setVents([_dummyVentData(isPostSaved: isUserSavedPost)]);
      ventProvider.saveVent(postIndex, isUserSavedPost);

      expect(ventProvider.vents[postIndex].isPostSaved, equals(true));

    });

    test('Should set isPostSaved to false when user unsaves a post', () {

      const isUserSavedPost = true;

      ventProvider.setVents([_dummyVentData(isPostSaved: isUserSavedPost)]);
      ventProvider.saveVent(postIndex, isUserSavedPost);

      expect(ventProvider.vents[postIndex].isPostSaved, equals(false));

    });

  });

}