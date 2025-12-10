import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  tearDown(() => bloc.close());

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [Loading, Loaded] when fetch watchlist succeeds',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial()
          .copyWith(watchlistState: RequestState.Loading),
      WatchlistMovieState.initial().copyWith(
        watchlistState: RequestState.Loaded,
        watchlistMovies: testMovieList,
        message: '',
      ),
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [Loading, Error] when fetch watchlist fails',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('fail')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial()
          .copyWith(watchlistState: RequestState.Loading),
      WatchlistMovieState.initial().copyWith(
        watchlistState: RequestState.Error,
        message: 'fail',
      ),
    ],
  );
}

