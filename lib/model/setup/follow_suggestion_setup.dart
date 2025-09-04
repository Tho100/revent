import 'dart:typed_data';

import 'package:revent/service/query/general/follow_suggestion_getter.dart';
import 'package:revent/shared/provider/follow_suggestion_provider.dart';
import 'package:revent/shared/provider_mixins.dart';

class FollowSuggestionSetup with FollowSuggestionProviderService {

  Future<void> setup() async {

    if (followSuggestionProvider.suggestions.isEmpty) {

      final followSuggestions = await FollowSuggestionGetter().getSuggestion();

      final usernames = followSuggestions['usernames'] as List<String>;
      final profilePic = followSuggestions['profile_pic'] as List<Uint8List>;

      final suggestions = List.generate(usernames.length, (index) {
        return FollowSuggestionData(
          username: usernames[index], 
          profilePic: profilePic[index]
        );
      });

      followSuggestionProvider.setSuggestions(suggestions);

    }

  }

}