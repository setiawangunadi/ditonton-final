import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:mockito/annotations.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv_series/tv_series_list_notifier.mocks.dart';
@GenerateMocks([
  GetNowPlayingTvSeries,
  GetPopularTvSeries,
  GetTopRatedTvSeries,
])
void main() {
  late TvSeriesListBloc bloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TvSeriesListBloc(
      getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  tearDown(() => bloc.close());

  group('now playing', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Loaded] when fetch now playing succeeds',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        TvSeriesListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        TvSeriesListState.initial().copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingTvSeries: testTvSeriesList,
          message: '',
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Error] when fetch now playing fails',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        TvSeriesListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        TvSeriesListState.initial().copyWith(
          nowPlayingState: RequestState.Error,
          message: 'fail',
        ),
      ],
    );
  });

  group('popular', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Loaded] when fetch popular succeeds',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        TvSeriesListState.initial()
            .copyWith(popularTvSeriesState: RequestState.Loading),
        TvSeriesListState.initial().copyWith(
          popularTvSeriesState: RequestState.Loaded,
          popularTvSeries: testTvSeriesList,
          message: '',
        ),
      ],
    );
  });

  group('top rated', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'emits [Loading, Loaded] when fetch top rated succeeds',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TvSeriesListState.initial()
            .copyWith(topRatedTvSeriesState: RequestState.Loading),
        TvSeriesListState.initial().copyWith(
          topRatedTvSeriesState: RequestState.Loaded,
          topRatedTvSeries: testTvSeriesList,
          message: '',
        ),
      ],
    );
  });
}

