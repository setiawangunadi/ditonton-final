part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {}

