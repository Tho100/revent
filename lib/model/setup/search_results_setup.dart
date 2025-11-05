import 'dart:typed_data';

import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/search/profiles_service.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/model/setup/vents_setup.dart';

class SearchResultsSetup with SearchProviderService {

  final String searchText;

  SearchResultsSetup({required this.searchText});

  Future<void> setupPostsResults() async {

    await VentsSetup().setupSearch(
      searchText: searchText
    );

  }
// TODO: Rename to profiles
  Future<void> setupAccountsResults() async {

    if (searchAccountsProvider.accounts.usernames.isEmpty) {

      final accountsData = await SearchProfilesService().getProfiles(searchUsername: searchText);

      final usernames = accountsData['username'] as List<String>;
      final profilePictures = accountsData['profile_pic'] as List<Uint8List>;

      final setupAccounts = SearchAccountsData(
        usernames: usernames, 
        profilePictures: profilePictures
      );

      searchAccountsProvider.setAccounts(setupAccounts);

    }

  }

}