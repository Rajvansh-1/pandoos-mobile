class ApiEndpoints {
  static const String base = 'https://pandoos.vercel.app';

  // Stream resolution
  static String stream(String videoId, int quality) =>
    '$base/api/stream?videoId=$videoId&quality=$quality';

  // Search
  static String search(String query, String type) =>
    '$base/api/search?q=${Uri.encodeComponent(query)}&type=$type';

  // Track metadata
  static String track(String videoId) => '$base/api/track?videoId=$videoId';

  // Artist browse
  static String artist(String browseId) => '$base/api/artist?browseId=$browseId';

  // Album browse
  static String album(String browseId) => '$base/api/album?browseId=$browseId';

  // Trending / Home feed
  static String get trending => '$base/api/trending';

  // Lyrics (proxied LRCLIB)
  static String lyrics(String title, String artist, int duration) =>
    '$base/api/lyrics?title=${Uri.encodeComponent(title)}&artist=${Uri.encodeComponent(artist)}&duration=$duration';
}
