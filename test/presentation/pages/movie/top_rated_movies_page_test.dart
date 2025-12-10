import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
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

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieListBloc>.value(
      value: mockMovieListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    final state = MovieListState.initial()
        .copyWith(topRatedMoviesState: RequestState.Loading);
    when(() => mockMovieListBloc.state).thenReturn(state);
    when(() => mockMovieListBloc.stream).thenAnswer((_) => Stream.value(state));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final state = MovieListState.initial().copyWith(
      topRatedMoviesState: RequestState.Loaded,
      topRatedMovies: <Movie>[],
    );
    when(() => mockMovieListBloc.state).thenReturn(state);
    when(() => mockMovieListBloc.stream).thenAnswer((_) => Stream.value(state));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final state = MovieListState.initial().copyWith(
      topRatedMoviesState: RequestState.Error,
      message: 'Error message',
    );
    when(() => mockMovieListBloc.state).thenReturn(state);
    when(() => mockMovieListBloc.stream).thenAnswer((_) => Stream.value(state));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
