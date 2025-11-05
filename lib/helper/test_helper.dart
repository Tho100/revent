import 'dart:typed_data';

import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/provider/vent/latest_provider.dart';

class TestHelper {

  static VentLatestData dummyVentData({
    int? totalLikes = 0, 
    bool? isPostSaved = false
  }) {
    return VentLatestData(
      postId: 0,
      title: '', 
      bodyText: '', 
      tags: '', 
      postTimestamp: '', 
      creator: '', 
      profilePic: Uint8List(0),
      totalLikes: totalLikes!,
      isPostSaved: isPostSaved!
    );
  }

  static CommentsData dummyCommentData() {
    return CommentsData(
      commentedBy: '', 
      comment: '', 
      commentTimestamp: '', 
      pfpData: Uint8List(0),
    );
  }

  static ReplyData dummyReplyData() {
    return ReplyData(
      repliedBy: '', 
      reply: '', 
      replyTimestamp: '', 
      pfpData: Uint8List(0),
    );
  }

  static UserData dummyProfile({
    required String username, 
    required String email
  }) {
    return UserData(
      username: username, 
      email: email
    );
  }

}