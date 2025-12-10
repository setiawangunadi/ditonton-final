import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  tearDown(() => bloc.close());

  const tQuery = 'spiderman';

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Loading, Loaded] on successful search',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(MovieQueryChanged(tQuery)),
    expect: () => [
      MovieSearchState.initial().copyWith(state: RequestState.Loading),
      MovieSearchState.initial().copyWith(
        state: RequestState.Loaded,
        searchResult: testMovieList,
        message: '',
      ),
    ],
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Loading, Error] on failed search',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('error')));
      return bloc;
    },
    act: (bloc) => bloc.add(MovieQueryChanged(tQuery)),
    expect: () => [
      MovieSearchState.initial().copyWith(state: RequestState.Loading),
      MovieSearchState.initial().copyWith(
        state: RequestState.Error,
        message: 'error',
      ),
    ],
  );
}

