part of 'watchlist_tv_series_bloc.dart';

class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState({
    required this.watchlistTvSeries,
    required this.watchlistState,
    required this.message,
  });

  factory WatchlistTvSeriesState.initial() => const WatchlistTvSeriesState(
        watchlistTvSeries: [],
        watchlistState: RequestState.Empty,
        message: '',
      );

  final List<TvSeries> watchlistTvSeries;
  final RequestState watchlistState;
  final String message;

  WatchlistTvSeriesState copyWith({
    List<TvSeries>? watchlistTvSeries,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistTvSeriesState(
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistTvSeries, watchlistState, message];
}

