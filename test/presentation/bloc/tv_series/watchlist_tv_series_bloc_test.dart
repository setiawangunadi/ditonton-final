import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetWatchlistTvSeries extends Mock
    implements GetWatchlistTvSeries {}

void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  tearDown(() => bloc.close());

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'emits [Loading, Loaded] when fetch watchlist succeeds',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesState.initial()
          .copyWith(watchlistState: RequestState.Loading),
      WatchlistTvSeriesState.initial().copyWith(
        watchlistState: RequestState.Loaded,
        watchlistTvSeries: testTvSeriesList,
        message: '',
      ),
    ],
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'emits [Loading, Error] when fetch watchlist fails',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('fail')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesState.initial()
          .copyWith(watchlistState: RequestState.Loading),
      WatchlistTvSeriesState.initial().copyWith(
        watchlistState: RequestState.Error,
        message: 'fail',
      ),
    ],
  );
}

