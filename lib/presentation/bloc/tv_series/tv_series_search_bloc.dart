import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  TvSeriesSearchBloc({required this.searchTvSeries})
      : super(TvSeriesSearchState.initial()) {
    on<TvSeriesQueryChanged>(_onQueryChanged);
  }

  final SearchTvSeries searchTvSeries;

  Future<void> _onQueryChanged(
    TvSeriesQueryChanged event,
    Emitter<TvSeriesSearchState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading, message: ''));

    final result = await searchTvSeries.execute(event.query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          searchResult: data,
          message: '',
        ),
      ),
    );
  }
}

