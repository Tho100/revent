import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/data_query/search/search_accounts_getter.dart';
import 'package:revent/provider/search/search_accounts_provider.dart';
import 'package:revent/helper/setup/vent_data_setup.dart';

class SetupSearch {

  final String searchText;

  SetupSearch({required this.searchText});

  Future<void> setupPosts() async {

    await VentDataSetup().setupSearch(
      searchText: searchText
    );

  }

  // TODO: Only call when the data is empty (do it on the setup not here, check for home For you/Following too)
  Future<void> setupAccounts() async {

    final accountsData = await SearchAccountsGetter().getAccounts(searchText: searchText);

    final usernames = accountsData['username'] as List<String>;
    final profilePictures = accountsData['profile_pic'] as List<Uint8List>;

    final setupAccounts = SearchAccountsData(
      usernames: usernames, 
      profilePictures: profilePictures
    );

    GetIt.instance<SearchAccountsProvider>().setAccounts(setupAccounts);

  }

}