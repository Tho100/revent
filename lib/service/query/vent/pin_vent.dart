import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class PinVent extends BaseQueryService with UserProfileProviderService {

  final String title;
  
  PinVent({required this.title});

  Future<void> pin() async {

    final postId = await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    const query = 'INSERT INTO pinned_vent_info (pinned_by, post_id) VALUES (:pinned_by, :post_id)';

    final params = {
      'pinned_by': userProvider.user.username,
      'post_id': postId
    };

    await executeQuery(query, params);

  }

}