part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  FetchMovieDetail(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  LoadMovieWatchlistStatus(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class AddMovieWatchlist extends MovieDetailEvent {
  AddMovieWatchlist(this.movieDetail);

  final MovieDetail movieDetail;

  @override
  List<Object?> get props => [movieDetail];
}

class RemoveMovieWatchlist extends MovieDetailEvent {
  RemoveMovieWatchlist(this.movieDetail);

  final MovieDetail movieDetail;

  @override
  List<Object?> get props => [movieDetail];
}

