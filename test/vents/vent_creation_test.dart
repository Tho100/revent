import 'package:test/test.dart';
import 'package:revent/helper/test_helper.dart';
import 'package:revent/shared/provider/vent/latest_provider.dart';

void main() {
  
  late VentLatestProvider ventProvider;

  setUp(() {
    ventProvider = VentLatestProvider();
  });
  
  group('Vent Create/Delete', () {

    test('Should have more than 0 vents when user created a post', () {

      ventProvider.addVent(TestHelper.dummyVentData());

      expect(ventProvider.vents.length, greaterThan(0));

    });

    test('Should have less than 1 vents when user deleted a post', () {

      ventProvider.addVent(TestHelper.dummyVentData());
      ventProvider.deleteVent(0);

      expect(ventProvider.vents.length, lessThan(1));

    });

  });

}