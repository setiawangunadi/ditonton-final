import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/analytics_service.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesListBloc
    extends MockBloc<TvSeriesListEvent, TvSeriesListState>
    implements TvSeriesListBloc {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class TvSeriesListStateFake extends Fake implements TvSeriesListState {}

class TvSeriesListEventFake extends Fake implements TvSeriesListEvent {}

void main() {
  late MockTvSeriesListBloc mockTvSeriesListBloc;
  late MockAnalyticsService mockAnalyticsService;

  setUpAll(() {
    registerFallbackValue(TvSeriesListEventFake());
    registerFallbackValue(TvSeriesListStateFake());
  });

  setUp(() {
    mockTvSeriesListBloc = MockTvSeriesListBloc();
    mockAnalyticsService = MockAnalyticsService();
    if (di.locator.isRegistered<AnalyticsService>()) {
      di.locator.unregister<AnalyticsService>();
    }
    di.locator.registerLazySingleton<AnalyticsService>(() => mockAnalyticsService);
    when(() => mockAnalyticsService.logViewTopRatedTvSeries())
        .thenAnswer((_) async => {});
  });

  tearDown(() {
    mockTvSeriesListBloc.close();
    if (di.locator.isRegistered<AnalyticsService>()) {
      di.locator.unregister<AnalyticsService>();
    }
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesListBloc>.value(
      value: mockTvSeriesListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        final state = TvSeriesListState.initial()
            .copyWith(topRatedTvSeriesState: RequestState.Loading);
        when(() => mockTvSeriesListBloc.state).thenReturn(state);
        when(() => mockTvSeriesListBloc.stream)
            .thenAnswer((_) => Stream.value(state));

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        final state = TvSeriesListState.initial().copyWith(
          topRatedTvSeriesState: RequestState.Loaded,
          topRatedTvSeries: <TvSeries>[],
        );
        when(() => mockTvSeriesListBloc.state).thenReturn(state);
        when(() => mockTvSeriesListBloc.stream)
            .thenAnswer((_) => Stream.value(state));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        final state = TvSeriesListState.initial().copyWith(
          topRatedTvSeriesState: RequestState.Error,
          message: 'Error message',
        );
        when(() => mockTvSeriesListBloc.state).thenReturn(state);
        when(() => mockTvSeriesListBloc.stream)
            .thenAnswer((_) => Stream.value(state));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}