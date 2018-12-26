import '../models/youtube_response.dart';

abstract class YoutubeSource {
  Future<YoutubeResponse> getYoutubeResponse(String artist, String title);
}