import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:mockito/annotations.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv_series/tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListTvSeriesStatus,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListTvSeriesStatus mockGetWatchListTvSeriesStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  const tId = 1;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListTvSeriesStatus = MockGetWatchListTvSeriesStatus();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();

    bloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatus: mockGetWatchListTvSeriesStatus,
      saveWatchlist: mockSaveWatchlistTvSeries,
      removeWatchlist: mockRemoveWatchlistTvSeries,
    );
  });

  tearDown(() => bloc.close());

  group('fetch detail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits loading -> loaded detail -> loaded recommendations on success',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loading,
          message: '',
        ),
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loading,
        ),
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          recommendations: testTvSeriesList,
          message: '',
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits loading -> error when detail fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('error')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loading,
          message: '',
        ),
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Error,
          message: 'error',
        ),
      ],
    );
  });

  group('watchlist status', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits updated watchlist status when loaded',
      build: () {
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTvSeriesWatchlistStatus(tId)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits success message and status on add watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => Right(TvSeriesDetailBloc.watchlistAddSuccessMessage));
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        ),
        TvSeriesDetailState.initial().copyWith(
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'emits success message and status on remove watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right(TvSeriesDetailBloc.watchlistRemoveSuccessMessage));
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(
          watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
          isAddedToWatchlist: false,
        ),
      ],
    );
  });
}
