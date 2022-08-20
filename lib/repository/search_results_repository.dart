import 'dart:convert';

import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/builder/filter_builder.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/uri_generator.dart';

abstract class SearchResultsRepository<T> {
  final UriLoader uriLoader;
  final http.Client client;

  SearchResultsRepository(this.uriLoader, this.client);
  String get type;
  Future<List<T>> searchMovies(String? query, int? page);
}

// movie results
class MovieSearchResults extends SearchResultsRepository<GenericMoviesModel> {
  MovieSearchResults(UriLoader uriLoader, http.Client client)
      : super(uriLoader, client);

  @override
  Future<List<GenericMoviesModel>> searchMovies(
      String? query, int? page) async {
    final filters = FilterBuilder().query(query).page(page);
    final uri = uriLoader.generateUri(
      '/search/$type',
      filters.toJson(),
    );
    final response = await client.get(uri);
    final decodeJson = jsonDecode(response.body);
    List<GenericMoviesModel> searchedMovies = [];
    if (decodeJson['results'] == null) {
      return [];
    }
    decodeJson['results'].forEach(
        (movie) => searchedMovies.add(GenericMoviesModel.fromJson(movie)));
    return searchedMovies;
  }

  @override
  String get type => 'movie';
}

// person results
class PersonSearchResults extends SearchResultsRepository<ActorInfoModel> {
  PersonSearchResults(UriLoader uriLoader, http.Client client)
      : super(uriLoader, client);

  @override
  Future<List<ActorInfoModel>> searchMovies(String? query, int? page) async {
    final filters = FilterBuilder().query(query).page(page);
    final uri = uriLoader.generateUri(
      '/search/$type',
      filters.toJson(),
    );
    final response = await client.get(uri);
    final decodeJson = jsonDecode(response.body);
    List<ActorInfoModel> actorsInfo = [];
    if (decodeJson['results'] == null) {
      return [];
    }
    decodeJson['results']
        .forEach((actor) => actorsInfo.add(ActorInfoModel.fromJson(actor)));
    return actorsInfo;
  }

  @override
  String get type => 'person';
}

// tv results
class TvSearchResults extends SearchResultsRepository<TVShowModel> {
  TvSearchResults(UriLoader uriLoader, http.Client client)
      : super(uriLoader, client);

  @override
  Future<List<TVShowModel>> searchMovies(String? query, int? page) async {
    final url = '/search/$type&query=$query&page=$page';
    final response = await client.get(uriLoader.generateUri(url));
    final decodeJson = jsonDecode(response.body);
    List<TVShowModel> searchedTvShows = [];
    if (decodeJson['results'] == null) {
      return [];
    }
    decodeJson['results']
        .forEach((tvShow) => searchedTvShows.add(TVShowModel.fromJson(tvShow)));
    return searchedTvShows;
  }

  @override
  String get type => 'tv';
}

class DefaultSearchResults extends SearchResultsRepository {
  DefaultSearchResults(UriLoader uriLoader, http.Client client)
      : super(uriLoader, client);

  @override
  Future<List> searchMovies(String? query, int? page) async {
    return [];
  }

  @override
  String get type => 'clear';
}