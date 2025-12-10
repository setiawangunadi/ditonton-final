part of 'watchlist_movie_bloc.dart';

class WatchlistMovieState extends Equatable {
  const WatchlistMovieState({
    required this.watchlistMovies,
    required this.watchlistState,
    required this.message,
  });

  factory WatchlistMovieState.initial() => const WatchlistMovieState(
        watchlistMovies: [],
        watchlistState: RequestState.Empty,
        message: '',
      );

  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistMovies, watchlistState, message];
}

