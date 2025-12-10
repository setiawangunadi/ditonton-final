import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesListBloc
    extends MockBloc<TvSeriesListEvent, TvSeriesListState>
    implements TvSeriesListBloc {}

class TvSeriesListStateFake extends Fake implements TvSeriesListState {}

class TvSeriesListEventFake extends Fake implements TvSeriesListEvent {}

void main() {
  late MockTvSeriesListBloc mockTvSeriesListBloc;

  setUpAll(() {
    registerFallbackValue(TvSeriesListEventFake());
    registerFallbackValue(TvSeriesListStateFake());
  });

  setUp(() {
    mockTvSeriesListBloc = MockTvSeriesListBloc();
  });

  tearDown(() {
    mockTvSeriesListBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesListBloc>.value(
      value: mockTvSeriesListBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final state = TvSeriesListState.initial()
        .copyWith(popularTvSeriesState: RequestState.Loading);
    when(() => mockTvSeriesListBloc.state).thenReturn(state);
    when(() => mockTvSeriesListBloc.stream)
        .thenAnswer((_) => Stream.value(state));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final state = TvSeriesListState.initial().copyWith(
      popularTvSeriesState: RequestState.Loaded,
      popularTvSeries: <TvSeries>[
        TvSeries(
          backdropPath: '/path.jpg',
          genreIds: const [1, 2],
          id: 1,
          name: 'Test',
          originCountry: const ['US'],
          originalLanguage: 'en',
          originalName: 'Test Original',
          overview: 'Overview',
          popularity: 1,
          posterPath: '/poster.jpg',
          voteAverage: 8.0,
          voteCount: 100,
          firstAirDate: DateTime.now(),
        )
      ],
    );
    when(() => mockTvSeriesListBloc.state).thenReturn(state);
    when(() => mockTvSeriesListBloc.stream)
        .thenAnswer((_) => Stream.value(state));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final state = TvSeriesListState.initial().copyWith(
      popularTvSeriesState: RequestState.Error,
      message: 'Error message',
    );
    when(() => mockTvSeriesListBloc.state).thenReturn(state);
    when(() => mockTvSeriesListBloc.stream)
        .thenAnswer((_) => Stream.value(state));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(textFinder, findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should trigger FetchPopularTvSeries on initState',
      (tester) async {
    when(() => mockTvSeriesListBloc.state)
        .thenReturn(TvSeriesListState.initial());
    when(() => mockTvSeriesListBloc.stream)
        .thenAnswer((_) => Stream.value(TvSeriesListState.initial()));
    when(() => mockTvSeriesListBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
    await tester.pumpAndSettle();

    verify(() => mockTvSeriesListBloc.add(FetchPopularTvSeries())).called(1);
  });
}
