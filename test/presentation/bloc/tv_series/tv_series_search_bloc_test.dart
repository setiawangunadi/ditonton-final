import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([
  SearchTvSeries
])
void main() {
  late TvSeriesSearchBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(searchTvSeries: mockSearchTvSeries);
  });

  tearDown(() => bloc.close());

  const tQuery = 'loki';

  blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
    'emits [Loading, Loaded] on successful search',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(TvSeriesQueryChanged(tQuery)),
    expect: () => [
      TvSeriesSearchState.initial().copyWith(state: RequestState.Loading),
      TvSeriesSearchState.initial().copyWith(
        state: RequestState.Loaded,
        searchResult: testTvSeriesList,
        message: '',
      ),
    ],
  );

  blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
    'emits [Loading, Error] on failed search',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(TvSeriesQueryChanged(tQuery)),
    expect: () => [
      TvSeriesSearchState.initial().copyWith(state: RequestState.Loading),
      TvSeriesSearchState.initial().copyWith(
        state: RequestState.Error,
        message: 'error',
      ),
    ],
  );
}

