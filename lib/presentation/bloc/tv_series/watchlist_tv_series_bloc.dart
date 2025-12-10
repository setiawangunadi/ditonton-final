import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  WatchlistTvSeriesBloc({required this.getWatchlistTvSeries})
      : super(WatchlistTvSeriesState.initial()) {
    on<FetchWatchlistTvSeries>(_onFetchWatchlistTvSeries);
  }

  final GetWatchlistTvSeries getWatchlistTvSeries;

  Future<void> _onFetchWatchlistTvSeries(
    FetchWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(state.copyWith(watchlistState: RequestState.Loading));

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistTvSeries: data,
          message: '',
        ),
      ),
    );
  }
}

