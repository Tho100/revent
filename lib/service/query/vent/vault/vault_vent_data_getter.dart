import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class VaultVentDataGetter with UserProfileProviderService {

  Future<Map<String, dynamic>> getMetadata() async {

    final response = await ApiClient.get(ApiPath.vaultVentsGetter, userProvider.user.username);

    final vents = response.body!['vents'] as List<dynamic>;

    final ventsData = ExtractData(data: vents);

    final postIds = ventsData.extractColumn<int>('post_id');
    final titles = ventsData.extractColumn<String>('title');
    final tags = ventsData.extractColumn<String>('tags');
    final postTimestamp = ventsData.extractColumn<String>('created_at');

    return {
      'status_code': response.statusCode,
      'post_id': postIds,
      'title': titles,
      'tags': tags,
      'post_timestamp': postTimestamp
    };
  
  }

  Future<String> getBodyText({required int postId}) async {

    final response = await ApiClient.get(ApiPath.vaultBodyTextGetter, postId);

    return response.body!['body_text'];

  }

}