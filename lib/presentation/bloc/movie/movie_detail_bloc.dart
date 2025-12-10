import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<LoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddMovieWatchlist>(_onAddWatchlist);
    on<RemoveMovieWatchlist>(_onRemoveWatchlist);
  }

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        movieState: RequestState.Loading,
        message: '',
      ),
    );

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(event.id);

    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            movieState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (movie) async {
        emit(
          state.copyWith(
            movieState: RequestState.Loaded,
            movie: movie,
            recommendationState: RequestState.Loading,
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ),
          ),
          (recommendations) => emit(
            state.copyWith(
              recommendationState: RequestState.Loaded,
              recommendations: recommendations,
              message: '',
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddWatchlist(
    AddMovieWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movieDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
          ),
        );
      },
    );

    final status = await getWatchListStatus.execute(event.movieDetail.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onRemoveWatchlist(
    RemoveMovieWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movieDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
          ),
        );
      },
    );

    final status = await getWatchListStatus.execute(event.movieDetail.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }
}

