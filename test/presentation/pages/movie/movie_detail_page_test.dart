import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockAnalyticsService mockAnalyticsService;
  late StreamController<MovieDetailState> movieDetailStateController;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockAnalyticsService = MockAnalyticsService();
    movieDetailStateController = StreamController<MovieDetailState>.broadcast();
    when(() => mockMovieDetailBloc.stream)
        .thenAnswer((_) => movieDetailStateController.stream);
    if (di.locator.isRegistered<AnalyticsService>()) {
      di.locator.unregister<AnalyticsService>();
    }
    di.locator.registerLazySingleton<AnalyticsService>(() => mockAnalyticsService);
    when(() => mockAnalyticsService.logScreenView(
          screenName: any(named: 'screenName'),
          screenClass: any(named: 'screenClass'),
        )).thenAnswer((_) async => {});
    when(() => mockAnalyticsService.logMovieView(
          movieId: any(named: 'movieId'),
          movieTitle: any(named: 'movieTitle'),
        )).thenAnswer((_) async => {});
    when(() => mockAnalyticsService.logAddMovieToWatchlist(
          movieId: any(named: 'movieId'),
          movieTitle: any(named: 'movieTitle'),
        )).thenAnswer((_) async => {});
    when(() => mockAnalyticsService.logRemoveMovieFromWatchlist(
          movieId: any(named: 'movieId'),
          movieTitle: any(named: 'movieTitle'),
        )).thenAnswer((_) async => {});
  });

  tearDown(() {
    movieDetailStateController.close();
    mockMovieDetailBloc.close();
    if (di.locator.isRegistered<AnalyticsService>()) {
      di.locator.unregister<AnalyticsService>();
    }
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    );
    when(() => mockMovieDetailBloc.state).thenReturn(state);
    movieDetailStateController.add(state);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final state = MovieDetailState.initial().copyWith(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      recommendations: <Movie>[],
      isAddedToWatchlist: true,
    );
    when(() => mockMovieDetailBloc.state).thenReturn(state);
    movieDetailStateController.add(state);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    );
    final successState = initialState.copyWith(
      watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
    );

    when(() => mockMovieDetailBloc.state).thenReturn(initialState);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    movieDetailStateController.add(initialState);

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    movieDetailStateController.add(successState);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(MovieDetailBloc.watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final initialState = MovieDetailState.initial().copyWith(
      movieState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.Loaded,
      recommendations: <Movie>[],
      isAddedToWatchlist: false,
    );
    final errorState = initialState.copyWith(
      watchlistMessage: 'Failed',
    );

    when(() => mockMovieDetailBloc.state).thenReturn(initialState);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    movieDetailStateController.add(initialState);

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    movieDetailStateController.add(errorState);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
