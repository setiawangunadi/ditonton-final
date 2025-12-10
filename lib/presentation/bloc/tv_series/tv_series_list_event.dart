part of 'tv_series_list_bloc.dart';

abstract class TvSeriesListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNowPlayingTvSeries extends TvSeriesListEvent {}

class FetchPopularTvSeries extends TvSeriesListEvent {}

class FetchTopRatedTvSeries extends TvSeriesListEvent {}

