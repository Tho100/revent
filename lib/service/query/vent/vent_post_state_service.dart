import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class VentPostStateService extends BaseQueryService with UserProfileProviderService {

  /// Returns a list of booleans indicating whether each post ID
  /// has been liked or saved by the current user based on [stateType].

  Future<List<bool>> getVentPostState({
    required List<int> postIds,
    required String stateType,
  }) async {

    final queryBasedOnType = {
      'liked': 'SELECT post_id FROM ${TableNames.likedVentInfo} WHERE liked_by = :username',
      'saved': 'SELECT post_id FROM ${TableNames.savedVentInfo} WHERE saved_by = :username'
    };

    final param = {'username': userProvider.user.username};

    final retrievedIds = await executeQuery(
      queryBasedOnType[stateType]!, param
    );

    final extractIds = ExtractData(rowsData: retrievedIds).extractIntColumn('post_id');

    final statePostIds = extractIds.toSet();

    return postIds.map((postId) => statePostIds.contains(postId)).toList();

  }

}