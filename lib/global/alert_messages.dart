class AlertMessages {

  /// Alert-Dialog messages title must be in capitalized,
  /// the sub-messagge OR single-message dialog must starts with only the initial capitalized.
  /// 
  /// Snack-Dialog messages must starts with only the initial capitalzed.

  /// Alert-Dialog messages

  static const failedSignUp = 'Sign Up Failed';
  static const failedSignIn = 'Sign In Failed';

  static const postFailed = 'Post Failed';

  static const passwordUpdated = 'Password Updated';

  static const deletePost = 'Delete Post?';

  static const discardPost = 'Discard Post?';
  static const discardComment = 'Discard Comment?';
  static const discardReply = 'Discard Reply?';
  static const discardEdit = 'Discard Edit?';

  static const signOut = 'Confirm Sign Out?';
  static const deactivateAccount = 'Deactivate Account?';

  static const registrationFieldsEmpty = 'Please fill all the fields';

  static const invalidUsername = 'Username is invalid';

  static const emptyEmailAddr = 'Please enter your email address';
  static const invalidEmailAddr = 'Email address is invalid';

  static const emptyPassword = 'Please enter your password';
  static const incorrectPassword = 'Password is incorrect';
  static const invalidPasswordLength = 'Password must be at least 6 characters';
  static const emptyPasswordFields = 'Please fill in both password fields';
  static const passwordHasBeenUpdated = 'Your account password has been updated';
  static const matchingPasswordFields = "New password can't be the same as the old one";

  static const emptyVentTitle = 'Please enter post title';
  static const invalidVentTtitleLength = 'Title must be at least 5 characters';
  static const ventTitleAlreadyExists = 'You already have a post with this title';
  
  static const similarCommentFound = 'You have already posted similar comment';

  static const accountNotFound = 'Account not found';

  /// Snack-Dialog messages

  static const defaultError = 'Something went wrong.';
  static const changesFailed = 'Changes not saved.';
  static const postsFailedToLoad = 'Posts not loaded.';
  static const archivesFailedToLoad = 'Archies not loaded.';
  static const repliesFailedToLoad = 'Replies not loaded.';
  static const commentsFailedToLoad = 'Comments not loaded.';
  static const profilesFailedToLoad = 'Failed to load profiles.';

  static const ventArchived = 'Vent archived.';
  static const ventPosted = 'Vent posted.';
  static const ventPostFailed = 'Vent post failed.';

  static const commentPosted = 'Comment posted.';
  static const commentFailed = 'Comment failed.';
  static const replyPosted = 'Reply posted.';
  static const replyFailed = 'Reply failed.';

  static const commentDeleted = 'Comment deleted.';
  static const replyDeleted = 'Reply deleted.';

  static const commentPinned = 'Pinned comment.';
  static const pinnedCommentExists = 'You already have a pinned comment.';
  static const unpinnedComment = 'Removed comment from pinned.';
  static const editedComment = 'This comment was edited.';

  static const savedChanges = 'Saved changes.';
  static const textCopied = 'Text copied.';
  static const nothingToCopy = 'Nothing to copy.';
  static const noTextSelected = 'No text selected.';

  static const avatarUpdated = 'Avatar updated.';
  static const userNotFound = 'User not found.';

  static const savedPostsHidden = 'Saved posts hidden.';
  static const followingHidden = 'Following is hidden.';

}