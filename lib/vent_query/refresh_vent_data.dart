import 'package:get_it/get_it.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class RefreshVentData {

  final ventData = GetIt.instance<VentDataProvider>();
  // TODO: Move to home-page class
  Future<void> refresh() async {

    ventData.deleteVentData();
    
    await VentDataSetup().setup();

  }

}