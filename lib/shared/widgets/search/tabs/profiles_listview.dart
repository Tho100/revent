import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/search/profiles_provider.dart';
import 'package:revent/shared/widgets/profile/title_widget.dart';

class SearchProfilesListView extends StatelessWidget {

  const SearchProfilesListView({super.key});

  Widget _buildListView(SearchProfilesData accountsData) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.5, right: 10),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: accountsData.usernames.length + 1,
        itemBuilder: (_, index) {

          if (index == 0) {
            return const SizedBox(height: 20);
          }

          final adjustedIndex = index - 1;

          final username = accountsData.usernames[adjustedIndex];
          final pfpData = accountsData.profilePictures[adjustedIndex];

          if (index >= 0) {
            return UserProfileTitleWidget(
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

  Widget _buildNoResults() {
    return NoContentMessage().customMessage(
      message: 'No results.'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProfilesProvider>(
      builder: (_, accountsData, __) {

        final accounts = accountsData.profiles;

        return accounts.usernames.isEmpty 
          ? _buildNoResults()
          : _buildListView(accounts);

      },
    );
  }

}