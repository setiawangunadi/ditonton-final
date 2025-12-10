part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  FetchTvSeriesDetail(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class LoadTvSeriesWatchlistStatus extends TvSeriesDetailEvent {
  LoadTvSeriesWatchlistStatus(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class AddTvSeriesWatchlist extends TvSeriesDetailEvent {
  AddTvSeriesWatchlist(this.tvSeriesDetail);

  final TvSeriesDetail tvSeriesDetail;

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class RemoveTvSeriesWatchlist extends TvSeriesDetailEvent {
  RemoveTvSeriesWatchlist(this.tvSeriesDetail);

  final TvSeriesDetail tvSeriesDetail;

  @override
  List<Object?> get props => [tvSeriesDetail];
}

