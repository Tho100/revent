class NsfwConverter {

  /// Converts a list of integer NSFW flags into a list of boolean values.
  ///
  /// Each non-zero integer is interpreted as [True], zero as [False].
  /// 
  /// [nsfwMarks] A list of integers representing NSFW flags.
    
  static List<bool> convertToBools(List<int> nsfwMarks) {
    return nsfwMarks.map((isNsfw) => isNsfw != 0).toList();
  }

}