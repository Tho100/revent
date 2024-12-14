import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/search/search_accounts_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/buttons/sub_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class SearchAccountsListView extends StatelessWidget {

  const SearchAccountsListView({super.key});
  // TODO: Create separated widget for this function
  Widget _buildProfile(String username, Uint8List pfpData) {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: username, pfpData: pfpData),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
      
            ProfilePictureWidget(
              customWidth: 45,
              customHeight: 45,
              pfpData: pfpData
            ),
      
            const SizedBox(width: 10),
      
            Text(
              username,
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
      
            const Spacer(),

            SubButton(
              customHeight: 40,
              text: 'Follow',
              onPressed: () => {}
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _buildListView(SearchAccountsData accountsData) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()
        ),
        itemCount: accountsData.usernames.length,
        itemBuilder: (_, index) {
          return _buildProfile(
            accountsData.usernames[index], 
            accountsData.profilePictures[index]
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