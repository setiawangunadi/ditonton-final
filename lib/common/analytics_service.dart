import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

/// Service class for Firebase Analytics
/// Provides methods to log events and track user behavior
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  /// Get the FirebaseAnalytics instance
  FirebaseAnalytics get analytics => _analytics;

  /// Get the FirebaseAnalyticsObserver for route tracking
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log a screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  /// Log when a movie is viewed
  Future<void> logMovieView({
    required int movieId,
    String? movieTitle,
  }) async {
    await _analytics.logEvent(
      name: 'view_movie',
      parameters: {
        'movie_id': movieId,
        if (movieTitle != null) 'movie_title': movieTitle,
      },
    );
  }

  /// Log when a TV series is viewed
  Future<void> logTvSeriesView({
    required int tvSeriesId,
    String? tvSeriesTitle,
  }) async {
    await _analytics.logEvent(
      name: 'view_tv_series',
      parameters: {
        'tv_series_id': tvSeriesId,
        if (tvSeriesTitle != null) 'tv_series_title': tvSeriesTitle,
      },
    );
  }

  /// Log when a movie is added to watchlist
  Future<void> logAddMovieToWatchlist({
    required int movieId,
    String? movieTitle,
  }) async {
    await _analytics.logEvent(
      name: 'add_movie_to_watchlist',
      parameters: {
        'movie_id': movieId,
        if (movieTitle != null) 'movie_title': movieTitle,
      },
    );
  }

  /// Log when a movie is removed from watchlist
  Future<void> logRemoveMovieFromWatchlist({
    required int movieId,
    String? movieTitle,
  }) async {
    await _analytics.logEvent(
      name: 'remove_movie_from_watchlist',
      parameters: {
        'movie_id': movieId,
        if (movieTitle != null) 'movie_title': movieTitle,
      },
    );
  }

  /// Log when a TV series is added to watchlist
  Future<void> logAddTvSeriesToWatchlist({
    required int tvSeriesId,
    String? tvSeriesTitle,
  }) async {
    await _analytics.logEvent(
      name: 'add_tv_series_to_watchlist',
      parameters: {
        'tv_series_id': tvSeriesId,
        if (tvSeriesTitle != null) 'tv_series_title': tvSeriesTitle,
      },
    );
  }

  /// Log when a TV series is removed from watchlist
  Future<void> logRemoveTvSeriesFromWatchlist({
    required int tvSeriesId,
    String? tvSeriesTitle,
  }) async {
    await _analytics.logEvent(
      name: 'remove_tv_series_from_watchlist',
      parameters: {
        'tv_series_id': tvSeriesId,
        if (tvSeriesTitle != null) 'tv_series_title': tvSeriesTitle,
      },
    );
  }

  /// Log a search event
  Future<void> logSearch({
    required String searchTerm,
    String? contentType, // 'movie' or 'tv_series'
  }) async {
    await _analytics.logSearch(
      searchTerm: searchTerm,
    );
    await _analytics.logEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        if (contentType != null) 'content_type': contentType,
      },
    );
  }

  /// Log when user views popular movies
  Future<void> logViewPopularMovies() async {
    await _analytics.logEvent(name: 'view_popular_movies');
  }

  /// Log when user views top rated movies
  Future<void> logViewTopRatedMovies() async {
    await _analytics.logEvent(name: 'view_top_rated_movies');
  }

  /// Log when user views popular TV series
  Future<void> logViewPopularTvSeries() async {
    await _analytics.logEvent(name: 'view_popular_tv_series');
  }

  /// Log when user views top rated TV series
  Future<void> logViewTopRatedTvSeries() async {
    await _analytics.logEvent(name: 'view_top_rated_tv_series');
  }

  /// Log when user views watchlist
  Future<void> logViewWatchlist({
    String? contentType, // 'movie' or 'tv_series'
  }) async {
    await _analytics.logEvent(
      name: 'view_watchlist',
      parameters: {
        if (contentType != null) 'content_type': contentType,
      },
    );
  }

  /// Log a custom event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Set user property
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }
}

