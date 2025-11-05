import 'dart:typed_data';

import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/search/profiles_service.dart';
import 'package:revent/shared/provider/search/profiles_provider.dart';
import 'package:revent/model/setup/vents_setup.dart';

class SearchResultsSetup with SearchProviderService {

  final String searchText;

  SearchResultsSetup({required this.searchText});

  Future<void> setupPostsResults() async {

    await VentsSetup().setupSearch(
      searchText: searchText
    );

  }

  Future<void> setupProfilesResults() async {

    if (searchProfilesProvider.profiles.usernames.isEmpty) {

      final accountsData = await SearchProfilesService().getProfiles(searchUsername: searchText);

      final usernames = accountsData['username'] as List<String>;
      final profilePictures = accountsData['profile_pic'] as List<Uint8List>;

      final setupProfiles = SearchProfilesData(
        usernames: usernames, 
        profilePictures: profilePictures
      );

      searchProfilesProvider.setProfiles(setupProfiles);

    }

  }

}