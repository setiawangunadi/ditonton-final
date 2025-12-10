import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  TvSeriesListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(TvSeriesListState.initial()) {
    on<FetchNowPlayingTvSeries>(_onFetchNowPlayingTvSeries);
    on<FetchPopularTvSeries>(_onFetchPopularTvSeries);
    on<FetchTopRatedTvSeries>(_onFetchTopRatedTvSeries);
  }

  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> _onFetchNowPlayingTvSeries(
    FetchNowPlayingTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading));

    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingTvSeries: data,
          message: '',
        ),
      ),
    );
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(popularTvSeriesState: RequestState.Loading));

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularTvSeriesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          popularTvSeriesState: RequestState.Loaded,
          popularTvSeries: data,
          message: '',
        ),
      ),
    );
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(topRatedTvSeriesState: RequestState.Loading));

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedTvSeriesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          topRatedTvSeriesState: RequestState.Loaded,
          topRatedTvSeries: data,
          message: '',
        ),
      ),
    );
  }
}

