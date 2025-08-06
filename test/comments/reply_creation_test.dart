import 'package:revent/helper/test_helper.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:test/test.dart';

void main() {

  late RepliesProvider repliesProvider;

  setUp(() {
    repliesProvider = RepliesProvider();
  });

  group('Reply Create/Delete', () {

    test('Should have more than 0 replies when user sent a reply', () {

      repliesProvider.addReply(TestHelper.dummyReplyData());

      expect(repliesProvider.replies.length, greaterThan(0));

    });

    test('Should have less than 1 replies when user deleted a reply', () {

      repliesProvider.addReply(TestHelper.dummyReplyData());
      repliesProvider.deleteReply(0);

      expect(repliesProvider.replies.length, lessThan(1));

    });

  });

}