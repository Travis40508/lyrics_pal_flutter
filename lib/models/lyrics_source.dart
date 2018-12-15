
import 'package:lyrics_pal/models/lyrics_response.dart';

abstract class LyricsSource {
  Future<LyricsResponse> fetchLyrics(String artistName, String songTitle);
}