part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {}

