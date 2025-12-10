part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvSeriesQueryChanged extends TvSeriesSearchEvent {
  TvSeriesQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

