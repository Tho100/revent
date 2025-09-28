import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class VaultVentDataGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, dynamic>> getMetadata() async {

    final response = await ApiClient.post(ApiPath.vaultVentsGetter, {
      'username': userProvider.user.username
    });

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

    const query = 
      'SELECT body_text FROM ${TableNames.vaultVentInfo} WHERE post_id = :post_id';
      
    final params = {'post_id': postId};

    final results = await executeQuery(query, params); 

    final extractedData = ExtractData(rowsData: results); 

    return extractedData.extractStringColumn('body_text')[0];

  }

}