part of 'tv_series_list_bloc.dart';

class TvSeriesListState extends Equatable {
  const TvSeriesListState({
    required this.nowPlayingTvSeries,
    required this.nowPlayingState,
    required this.popularTvSeries,
    required this.popularTvSeriesState,
    required this.topRatedTvSeries,
    required this.topRatedTvSeriesState,
    required this.message,
  });

  factory TvSeriesListState.initial() => const TvSeriesListState(
        nowPlayingTvSeries: [],
        nowPlayingState: RequestState.Empty,
        popularTvSeries: [],
        popularTvSeriesState: RequestState.Empty,
        topRatedTvSeries: [],
        topRatedTvSeriesState: RequestState.Empty,
        message: '',
      );

  final List<TvSeries> nowPlayingTvSeries;
  final RequestState nowPlayingState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularTvSeriesState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedTvSeriesState;
  final String message;

  TvSeriesListState copyWith({
    List<TvSeries>? nowPlayingTvSeries,
    RequestState? nowPlayingState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularTvSeriesState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedTvSeriesState,
    String? message,
  }) {
    return TvSeriesListState(
      nowPlayingTvSeries: nowPlayingTvSeries ?? this.nowPlayingTvSeries,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularTvSeriesState: popularTvSeriesState ?? this.popularTvSeriesState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedTvSeriesState: topRatedTvSeriesState ?? this.topRatedTvSeriesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        nowPlayingTvSeries,
        nowPlayingState,
        popularTvSeries,
        popularTvSeriesState,
        topRatedTvSeries,
        topRatedTvSeriesState,
        message,
      ];
}

