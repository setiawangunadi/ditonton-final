part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieQueryChanged extends MovieSearchEvent {
  MovieQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

