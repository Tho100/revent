import 'package:test/test.dart';
import 'package:revent/helper/test_helper.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

void main() {

  late VentLatestProvider ventProvider;

  setUp(() {
    ventProvider = VentLatestProvider();
  });

  const postIndex = 0;

  group('Vent Like/Dislike', () {

    test('Should increment totalLikes when user likes a post', () {

      const isUserLikedPost = false;

      ventProvider.setVents([TestHelper.dummyVentData()]);
      ventProvider.likeVent(postIndex, isUserLikedPost);    

      expect(ventProvider.vents[postIndex].totalLikes, equals(1));

    });

    test('Should decrement totalLikes when user unlikes a post', () {

      const isUserLikedPost = true;

      ventProvider.setVents([TestHelper.dummyVentData()]);
      ventProvider.likeVent(postIndex, isUserLikedPost);    

      expect(ventProvider.vents[postIndex].totalLikes, equals(-1));

    });

  });

  group('Vent Save/Unsave', () {

    test('Should set isPostSaved to true when user saves a post', () {

      const isUserSavedPost = false;

      ventProvider.setVents([TestHelper.dummyVentData()]);
      ventProvider.saveVent(postIndex, isUserSavedPost);

      expect(ventProvider.vents[postIndex].isPostSaved, equals(true));

    });

    test('Should set isPostSaved to false when user unsaves a post', () {

      const isUserSavedPost = true;

      ventProvider.setVents([TestHelper.dummyVentData()]);
      ventProvider.saveVent(postIndex, isUserSavedPost);

      expect(ventProvider.vents[postIndex].isPostSaved, equals(false));

    });

  });

}