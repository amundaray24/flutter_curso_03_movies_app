import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_curso_03_movies_app/helpers/debounce.dart';
import 'package:flutter_curso_03_movies_app/models/models.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {

  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey  = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int,List<Cast>> movieCast = {};
  int _popularPage = 0;

  final debounce = Debounce(
    duration: const Duration( milliseconds: 500 ),
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;
  
  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final response = await _getJsonData('3/movie/now_playing');
    final decodedData = NowPlayingResponse.fromJson(response);
    onDisplayMovies = decodedData.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final response = await _getJsonData('3/movie/popular', _popularPage);
    final decodedData = PopularResponse.fromJson(response);
    popularMovies = [...popularMovies, ...decodedData.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)){
      return movieCast[movieId]!;
    }
    final response = await _getJsonData('3/movie/$movieId/credits');
    final decodedData = CreditsResponse.fromJson(response);
    movieCast[movieId] = decodedData.cast;
    return decodedData.cast;
  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );
    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ) {

    debounce.value = '';
    debounce.onValue = ( value ) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add( results );
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), ( _ ) { 
      debounce.value = searchTerm;
    });

    Future.delayed(const Duration( milliseconds: 301)).then(( _ ) => timer.cancel());
  }
}