import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState>
    implements MovieListBloc {}

class MovieListStateFake extends Fake implements MovieListState {}

class MovieListEventFake extends Fake implements MovieListEvent {}

void main() {
  late MockMovieListBloc mockMovieListBloc;

  setUpAll(() {
    registerFallbackValue(MovieListEventFake());
    registerFallbackValue(MovieListStateFake());
  });

  setUp(() {
    mockMovieListBloc = MockMovieListBloc();
  });

  tearDown(() {
    mockMovieListBloc.close();
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 5.0,
    posterPath: '/poster.jpg',
    releaseDate: '2023-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.0,
    voteCount: 1000,
  );

  final tMovieList = [tMovie];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieListBloc>(
      create: (_) => mockMovieListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('should display CircularProgressIndicator when state is Loading',
          (tester) async {
        // arrange
        final state = MovieListState.initial().copyWith(
          popularMoviesState: RequestState.Loading,
        );
        when(() => mockMovieListBloc.state).thenReturn(state);
        when(() => mockMovieListBloc.stream).thenAnswer((_) => Stream.value(state));

        // act
        await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

        // assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('should display ListView with MovieCard when data is loaded',
          (tester) async {
        // arrange
        final state = MovieListState.initial().copyWith(
          popularMoviesState: RequestState.Loaded,
          popularMovies: tMovieList,
        );
        when(() => mockMovieListBloc.state).thenReturn(state);
        when(() => mockMovieListBloc.stream).thenAnswer((_) => Stream.value(state));

        // act
        await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

        // assert
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(MovieCard), findsOneWidget);
        expect(find.text('Test Movie'), findsOneWidget);
      });

  testWidgets('should display error message when state is Error', (tester) async {
    // arrange
    final state = MovieListState.initial().copyWith(
      popularMoviesState: RequestState.Error,
      message: 'Something went wrong',
    );
    when(() => mockMovieListBloc.state).thenReturn(state);
    when(() => mockMovieListBloc.stream).thenAnswer((_) => Stream.value(state));

    // act
    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    // assert
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should trigger FetchPopularMovies on initState', (tester) async {
    // arrange
    when(() => mockMovieListBloc.state).thenReturn(MovieListState.initial());
    when(() => mockMovieListBloc.stream)
        .thenAnswer((_) => Stream.value(MovieListState.initial()));
    when(() => mockMovieListBloc.add(any())).thenReturn(null);

    // act
    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    await tester.pumpAndSettle(); // Let microtask run

    // assert
    verify(() => mockMovieListBloc.add(FetchPopularMovies())).called(1);
  });
}