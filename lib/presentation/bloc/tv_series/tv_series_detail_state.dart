part of 'tv_series_detail_bloc.dart';

class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState({
    required this.tvSeries,
    required this.tvSeriesState,
    required this.recommendations,
    required this.recommendationState,
    required this.message,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  factory TvSeriesDetailState.initial() => const TvSeriesDetailState(
        tvSeries: null,
        tvSeriesState: RequestState.Empty,
        recommendations: [],
        recommendationState: RequestState.Empty,
        message: '',
        isAddedToWatchlist: false,
        watchlistMessage: '',
      );

  final TvSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TvSeries> recommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeries,
    RequestState? tvSeriesState,
    List<TvSeries>? recommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeries: tvSeries ?? this.tvSeries,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      recommendations: recommendations ?? this.recommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeries,
        tvSeriesState,
        recommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

