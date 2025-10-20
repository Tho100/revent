import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class CommentSettings extends BaseQueryService with VentProviderService {

  Future<Map<String, dynamic>> toggleComment({required bool enableComment}) async {

    final response = await ApiClient.post(ApiPath.toggleComment, {
      'post_id': activeVentProvider.ventData.postId,
      'new_value': DataConverter.convertBoolToInt(enableComment)
    });

    return {'status_code': response.statusCode};

  }
  
  Future<Map<String, int>> getCurrentOptions() async {

    final response = await ApiClient.get(ApiPath.getCommentStatus, activeVentProvider.ventData.postId);

    final commentEnabled = response.body!['status'] as int;

    return {'comment_enabled': commentEnabled};

  }

}