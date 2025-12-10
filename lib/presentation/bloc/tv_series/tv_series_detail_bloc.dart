import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvSeriesDetailState.initial()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<LoadTvSeriesWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddTvSeriesWatchlist>(_onAddWatchlist);
    on<RemoveTvSeriesWatchlist>(_onRemoveWatchlist);
  }

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListTvSeriesStatus getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        tvSeriesState: RequestState.Loading,
        message: '',
      ),
    );

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTvSeriesRecommendations.execute(event.id);

    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            tvSeriesState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (tvSeries) async {
        emit(
          state.copyWith(
            tvSeriesState: RequestState.Loaded,
            tvSeries: tvSeries,
            recommendationState: RequestState.Loading,
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ),
          ),
          (data) => emit(
            state.copyWith(
              recommendationState: RequestState.Loaded,
              recommendations: data,
              message: '',
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadTvSeriesWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddWatchlist(
    AddTvSeriesWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeriesDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
          ),
        );
      },
    );

    final status = await getWatchListStatus.execute(event.tvSeriesDetail.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onRemoveWatchlist(
    RemoveTvSeriesWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeriesDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
          ),
        );
      },
    );

    final status = await getWatchListStatus.execute(event.tvSeriesDetail.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }
}

