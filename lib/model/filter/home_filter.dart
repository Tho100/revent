import 'package:revent/helper/current_provider.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/provider/vent/vent_for_you_provider.dart';
import 'package:revent/provider/vent/vent_following_provider.dart';

class HomeFilter {

  final formatTimestamp = FormatDate();
  final currentProvider = CurrentProvider();

  void filterHomeToTrending() {

    final ventData = currentProvider.getProviderOnly();

    if (ventData.vents is List<VentForYouData>) {

      final filteredVents = <VentForYouData>[];
      final unfilteredVents = <VentForYouData>[];

      for (var vent in ventData.vents) {
        vent.totalLikes >= 5 && vent.totalComments >= 1 
          ? filteredVents.add(vent)
          : unfilteredVents.add(vent);
      }

      filteredVents.sort((a, b) => a.totalLikes.compareTo(b.totalLikes));
      unfilteredVents.sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

      final vents = [...filteredVents, ...unfilteredVents];

      ventData.setVents(vents);

    } else if (ventData.vents is List<VentFollowingData>) {

      final filteredVents = <VentFollowingData>[];
      final unfilteredVents = <VentFollowingData>[];

      for (var vent in ventData.vents) {
        vent.totalLikes >= 5 && vent.totalComments >= 1 
          ? filteredVents.add(vent)
          : unfilteredVents.add(vent);
      }

      filteredVents.sort((a, b) => a.totalLikes.compareTo(b.totalLikes));
      unfilteredVents.sort((a, b) => a.totalLikes.compareTo(b.totalLikes));

      final vents = [...filteredVents, ...unfilteredVents];

      ventData.setVents(vents);

    } 

  }

  void filterHomeToLatest() {

    final ventData = currentProvider.getProviderOnly();

    final sortedVents = ventData.vents
      .toList()
      ..sort((a, b) => formatTimestamp.parseFormattedTimestamp(b.postTimestamp)
        .compareTo(formatTimestamp.parseFormattedTimestamp(a.postTimestamp)));

    ventData.setVents(sortedVents);

  }

}