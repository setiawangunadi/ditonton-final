part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends MovieListEvent {}

class FetchPopularMovies extends MovieListEvent {}

class FetchTopRatedMovies extends MovieListEvent {}

