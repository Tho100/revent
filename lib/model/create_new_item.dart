import 'package:get_it/get_it.dart';
import 'package:revent/provider/vent_data_provider.dart';

class CreateNewItem {

  final ventData = GetIt.instance<VentDataProvider>();

  void newVent({required String ventTitle}) {
    ventData.ventTitles.add(ventTitle);
  }

  void newForum() {

  }

}