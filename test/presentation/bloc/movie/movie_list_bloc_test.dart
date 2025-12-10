import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  tearDown(() => bloc.close());

  group('now playing', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Loaded] when fetch now playing succeeds',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        MovieListState.initial().copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: testMovieList,
          message: '',
        ),
      ],
      verify: (_) => verify(mockGetNowPlayingMovies.execute()).called(1),
    );

    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Error] when fetch now playing fails',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
          (_) async => Left(ServerFailure('fail')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        MovieListState.initial().copyWith(
          nowPlayingState: RequestState.Error,
          message: 'fail',
        ),
      ],
    );
  });

  group('popular', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Loaded] when fetch popular succeeds',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(popularMoviesState: RequestState.Loading),
        MovieListState.initial().copyWith(
          popularMoviesState: RequestState.Loaded,
          popularMovies: testMovieList,
          message: '',
        ),
      ],
    );
  });

  group('top rated', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits [Loading, Loaded] when fetch top rated succeeds',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(topRatedMoviesState: RequestState.Loading),
        MovieListState.initial().copyWith(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: testMovieList,
          message: '',
        ),
      ],
    );
  });
}

