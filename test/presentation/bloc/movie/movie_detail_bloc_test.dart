import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const tId = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() => bloc.close());

  group('fetch detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits loading -> loaded detail -> loaded recommendations on success',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieState: RequestState.Loading,
          message: '',
        ),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          recommendations: testMovieList,
          message: '',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits loading -> error when detail fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('error')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieState: RequestState.Loading,
          message: '',
        ),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.Error,
          message: 'error',
        ),
      ],
    );
  });

  group('watchlist status', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated watchlist status when loaded',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMovieWatchlistStatus(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits success message and status on add watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right(MovieDetailBloc.watchlistAddSuccessMessage));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        ),
        MovieDetailState.initial().copyWith(
          watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits success message and status on remove watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right(MovieDetailBloc.watchlistRemoveSuccessMessage));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
        ),
        MovieDetailState.initial().copyWith(
          watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
          isAddedToWatchlist: false,
        ),
      ],
    );
  });
}

