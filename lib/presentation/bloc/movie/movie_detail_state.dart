part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    required this.movie,
    required this.movieState,
    required this.recommendations,
    required this.recommendationState,
    required this.message,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  factory MovieDetailState.initial() => const MovieDetailState(
        movie: null,
        movieState: RequestState.Empty,
        recommendations: [],
        recommendationState: RequestState.Empty,
        message: '',
        isAddedToWatchlist: false,
        watchlistMessage: '',
      );

  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> recommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  MovieDetailState copyWith({
    MovieDetail? movie,
    RequestState? movieState,
    List<Movie>? recommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      movieState: movieState ?? this.movieState,
      recommendations: recommendations ?? this.recommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movie,
        movieState,
        recommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

