import 'dart:typed_data';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/search/search_accounts_getter.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class SearchSetup with SearchProviderService {

  final String searchText;

  SearchSetup({required this.searchText});

  Future<void> setupPosts() async {

    await VentDataSetup().setupSearch(
      searchText: searchText
    );

  }

  Future<void> setupAccounts() async {

    if(searchAccountsProvider.accounts.usernames.isEmpty) {

      final accountsData = await SearchAccountsGetter().getAccounts(searchText: searchText);

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