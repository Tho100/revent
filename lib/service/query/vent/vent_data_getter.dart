import 'package:revent/helper/data/extract_data.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/helper/data/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class VentDataGetter {

  final int postId;

  VentDataGetter({required this.postId});

  Future<String> getBodyText() async {

    final response = await ApiClient.get(ApiPath.ventBodyTextGetter, postId);

    return response.body!['body_text'];

  }

  Future<Map<String, dynamic>> getMetadata() async {

    final response = await ApiClient.get(ApiPath.ventMetadataGetter, postId);

    final metadata = ExtractData(data: response.body!['metadata']);

    final tags = metadata.extractColumn<String>('tags');
    final totalLikes = metadata.extractColumn<int>('total_likes');

    final isNsfw = DataConverter.convertToBools(
      metadata.extractColumn<int>('marked_nsfw')
    );

    final postTimestamp = FormatDate().formatToPostDate(
      metadata.extractColumn<String>('created_at')
    );

    return {
      'tags': tags[0],
      'post_timestamp': postTimestamp[0],
      'total_likes': totalLikes[0],
      'is_nsfw': isNsfw[0]
    };
    
  }

}