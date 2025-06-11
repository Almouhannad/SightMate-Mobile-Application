class StringUtils {
  /// Computes the Levenshtein distance between [s1] and [s2]
  /// If [caseSensitive] is false, the comparison ignores case
  static int levenshteinDistance(
    String s1,
    String s2, {
    bool caseSensitive = true,
  }) {
    if (!caseSensitive) {
      s1 = s1.toLowerCase();
      s2 = s2.toLowerCase();
    }

    int len1 = s1.length;
    int len2 = s2.length;

    if (len1 == 0) return len2;
    if (len2 == 0) return len1;

    List<int> prevRow = List.generate(len2 + 1, (i) => i);
    List<int> currRow = List.filled(len2 + 1, 0);

    for (int i = 1; i <= len1; i++) {
      currRow[0] = i;
      for (int j = 1; j <= len2; j++) {
        int cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        currRow[j] = [
          prevRow[j] + 1,
          currRow[j - 1] + 1,
          prevRow[j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
      // Swap the rows
      List<int> temp = prevRow;
      prevRow = currRow;
      currRow = temp;
    }

    return prevRow[len2];
  }
}
