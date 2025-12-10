part of 'tv_series_search_bloc.dart';

class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState({
    required this.state,
    required this.searchResult,
    required this.message,
  });

  factory TvSeriesSearchState.initial() => const TvSeriesSearchState(
        state: RequestState.Empty,
        searchResult: [],
        message: '',
      );

  final RequestState state;
  final List<TvSeries> searchResult;
  final String message;

  TvSeriesSearchState copyWith({
    RequestState? state,
    List<TvSeries>? searchResult,
    String? message,
  }) {
    return TvSeriesSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}

