import 'package:revent/helper/test_helper.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:test/test.dart';

void main() {

  late CommentsProvider commentsProvider;

  setUp(() {
    commentsProvider = CommentsProvider();
  });

  group('Comment Create/Delete', () {

    test('Should have more than 0 comments when user sent a comment', () {

      commentsProvider.addComment(TestHelper.dummyCommentData());

      expect(commentsProvider.comments.length, greaterThan(0));

    });

    test('Should have less than 1 comments when user deleted a comment', () {

      commentsProvider.addComment(TestHelper.dummyCommentData());
      commentsProvider.deleteComment(0);

      expect(commentsProvider.comments.length, lessThan(1));

    });

  });

}