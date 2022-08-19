import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/models/movie_info_model.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

import 'movie_info_event.dart';
import 'movie_info_state.dart';

class MovieInfoBloc extends Bloc<MovieInfoEvent, MovieInfoState> {
  final TMDBRepository tmdbRepository;
  int initialPage = 1;
  late MovieInfo movieInfo;

  MovieInfoBloc({required this.tmdbRepository})
      : assert(tmdbRepository != null),
        super(MovieInfoLoading());

  @override
  MovieInfoState get initialState => MovieInfoEmpty();

  @override
  Stream<MovieInfoState> mapEventToState(MovieInfoEvent event) async* {
    if (event is FetchMovieInfo) {
      yield MovieInfoLoading();
      try {
        movieInfo = await tmdbRepository.fetchMovieInfo(id: event.id);
        yield MovieInfoLoaded(movieInfo: movieInfo);
      } catch (e) {
        yield MovieInfoError();
      }
    }
  }
}
