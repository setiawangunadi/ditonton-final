import 'package:ditonton/data/models/tv_series/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tFirstAirDate = DateTime.parse('2025-10-18');
  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3, 4],
    id: 1,
    name: 'Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: tFirstAirDate,
    originalLanguage: "en",
    originalName: "Original Title",
    originCountry: [],
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvSeriesResponseModel =
  TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);
  
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "origin_country": [],
            "original_language": "en",
            "original_name": "Original Title",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "first_air_date": "2025-10-18",
            "name": "Title",
            "vote_average": 1.0,
            "vote_count": 1
          }
        ]
      };
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "origin_country": [],
            "original_language": "en",
            "original_name": "Original Title",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "first_air_date": "2025-10-18",
            "name": "Title",
            "vote_average": 1.0,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}