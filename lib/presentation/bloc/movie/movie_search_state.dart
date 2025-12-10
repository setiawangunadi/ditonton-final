part of 'movie_search_bloc.dart';

class MovieSearchState extends Equatable {
  const MovieSearchState({
    required this.state,
    required this.searchResult,
    required this.message,
  });

  factory MovieSearchState.initial() => const MovieSearchState(
        state: RequestState.Empty,
        searchResult: [],
        message: '',
      );

  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}

