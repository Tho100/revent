import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/shared/widgets/account_profile.dart';

class SearchAccountsListView extends StatelessWidget {

  const SearchAccountsListView({super.key});

  Widget _buildListView(SearchAccountsData accountsData) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.5, right: 10),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: accountsData.usernames.length + 1,
        itemBuilder: (_, index) {

          if(index == 0) {
            return const SizedBox(height: 20);
          }

          final adjustedIndex = index - 1;

          final username = accountsData.usernames[adjustedIndex];
          final pfpData = accountsData.profilePictures[adjustedIndex];

          if(index >= 0) {
            return AccountProfileWidget(
              username: username,
              pfpData: pfpData,
              hideActionButton: true,
            );
          }

          return const SizedBox.shrink();

        },
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'No results.'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchAccountsProvider>(
      builder: (_, accountsData, __) {

        final accountsDataList = accountsData.accounts;

        return accountsDataList.usernames.isEmpty 
          ? _buildOnEmpty()
          : _buildListView(accountsDataList);

      },
    );
  }

}