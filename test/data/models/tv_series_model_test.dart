import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final tFirstAirDate = DateTime.parse('2025-10-18 10:57:15.140834');
  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: tFirstAirDate,
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    originCountry: ["originCountry"],
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: tFirstAirDate,
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    originCountry: ["originCountry"],
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Tv Series entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}