import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/model/user/user_follow_actions.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/search/search_accounts_provider.dart';
import 'package:revent/shared/widgets/account_profile.dart';

class SearchAccountsListView extends StatefulWidget {

  const SearchAccountsListView({super.key});

  @override
  State<SearchAccountsListView> createState() => _SearchAccountsListViewState();

}

class _SearchAccountsListViewState extends State<SearchAccountsListView> {

  final profileActionTextNotifier = ValueNotifier<List<String>>([]);

  Future<void> _followOnPressed(int index, String username, bool follow) async {

    await UserFollowActions(username: username).followUser(follow: follow).then((_) {

      final updatedList = List<String>.from(profileActionTextNotifier.value);

      updatedList[index] = follow ? 'Unfollow' : 'Follow';
      profileActionTextNotifier.value = updatedList;

    });

  }

  Widget _buildListView(SearchAccountsData accountsData) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.5, right: 10, top: 10),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: accountsData.usernames.length,
        itemBuilder: (_, index) {

          final username = accountsData.usernames[index];
          final pfpData = accountsData.profilePictures[index];

          return ValueListenableBuilder(
            valueListenable: profileActionTextNotifier,
            builder: (_, text, __) {
              final currentText = text[index];
              return AccountProfileWidget(
                customText: currentText,
                username: username,
                pfpData: pfpData,
                onPressed: () async {
                  currentText == 'Follow' 
                    ? await _followOnPressed(index, username, true)
                    : await _followOnPressed(index, username, false);
                },
              );
            },
          );

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
  void dispose() {
    profileActionTextNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchAccountsProvider>(
      builder: (_, accountsData, __) {

        final accountsDataList = accountsData.accounts;

        if(accountsDataList.usernames.isNotEmpty) {
          profileActionTextNotifier.value = List.generate(
            accountsDataList.usernames.length, (index) => 'Follow'
          ); 
        }

        return accountsDataList.usernames.isEmpty 
          ? _buildOnEmpty()
          : _buildListView(accountsDataList);

      },
    );
  }

}