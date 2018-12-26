import 'package:http/http.dart' show Client;
import 'package:lyrics_pal/models/search_source.dart';
import 'package:lyrics_pal/models/youtube_source.dart';
import '../models/youtube_response.dart';
import 'dart:convert';

final String _baseUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&key=';
final String _apiKey = 'AIzaSyCbS_9gcgFNop0nSaV9bBddviOXUUQShAc';


class YoutubeApi implements YoutubeSource {

  Client client = Client();

  @override
  Future<YoutubeResponse> getYoutubeResponse(String artist, String title) async {
    final url = '$_baseUrl$_apiKey&q=$artist $title';
    print('Attempting to request $url');
    final response = await client.get(url);
    final jsonResponse = json.decode(response.body);

    return YoutubeResponse.fromJson(jsonResponse);
  }

}