import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class TvSeriesDetailEventFake extends Fake implements TvSeriesDetailEvent {}

class TvSeriesDetailStateFake extends Fake implements TvSeriesDetailState {}

void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockAnalyticsService mockAnalyticsService;
  late StreamController<TvSeriesDetailState> tvSeriesDetailStateController;

  setUpAll(() {
    registerFallbackValue(TvSeriesDetailEventFake());
    registerFallbackValue(TvSeriesDetailStateFake());
  });

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockAnalyticsService = MockAnalyticsService();
    tvSeriesDetailStateController =
        StreamController<TvSeriesDetailState>.broadcast();
    when(() => mockTvSeriesDetailBloc.stream)
        .thenAnswer((_) => tvSeriesDetailStateController.stream);
    if (di.locator.isRegistered<AnalyticsService>()) {
      di.locator.unregister<AnalyticsService>();
    }
    di.locator.registerLazySingleton<AnalyticsService>(() => mockAnalyticsService);
    when(() => mockAnalyticsService.logScreenView(
          screenName: any(named: 'screenName'),
          screenClass: any(named: 'screenClass'),
        )).thenAnswer((_) async => {});
    when(() => mockAnalyticsService.logTvSeriesView(
          tvSeriesId: any(named: 'tvSeriesId'),
          tvSeriesTitle: any(named: 'tvSeriesTitle'),
        )).thenAnswer((_) async => {});
    when(() => mockAnalyticsService.logAddTvSeriesToWatchlist(
          tvSeriesId: any(named: 'tvSeriesId'),
          tvSeriesTitle: any(named: 'tvSeriesTitle'),
        )).thenAnswer((_) async => {});
    when(() => mockAnalyticsService.logRemoveTvSeriesFromWatchlist(
          tvSeriesId: any(named: 'tvSeriesId'),
          tvSeriesTitle: any(named: 'tvSeriesTitle'),
        )).thenAnswer((_) async => {});
  });

  tearDown(() {
    tvSeriesDetailStateController.close();
    mockTvSeriesDetailBloc.close();
    if (di.locator.isRegistered<AnalyticsService>()) {
      di.locator.unregister<AnalyticsService>();
    }
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockTvSeriesDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when TvSeries not added to watchlist',
          (WidgetTester tester) async {
        final state = TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        );
        when(() => mockTvSeriesDetailBloc.state).thenReturn(state);
        tvSeriesDetailStateController.add(state);

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should dispay check icon when tvSeries is added to wathclist',
          (WidgetTester tester) async {
        final state = TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: true,
        );
        when(() => mockTvSeriesDetailBloc.state).thenReturn(state);
        tvSeriesDetailStateController.add(state);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        final initialState = TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        );
        final successState = initialState.copyWith(
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        );

        when(() => mockTvSeriesDetailBloc.state).thenReturn(initialState);

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
        tvSeriesDetailStateController.add(initialState);

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        tvSeriesDetailStateController.add(successState);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(TvSeriesDetailBloc.watchlistAddSuccessMessage),
            findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        final initialState = TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        );
        final errorState = initialState.copyWith(watchlistMessage: 'Failed');

        when(() => mockTvSeriesDetailBloc.state).thenReturn(initialState);

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
        tvSeriesDetailStateController.add(initialState);

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        tvSeriesDetailStateController.add(errorState);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}