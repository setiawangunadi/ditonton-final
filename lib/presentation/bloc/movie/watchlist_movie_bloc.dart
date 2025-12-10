import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  WatchlistMovieBloc({required this.getWatchlistMovies})
      : super(WatchlistMovieState.initial()) {
    on<FetchWatchlistMovies>(_onFetchWatchlistMovies);
  }

  final GetWatchlistMovies getWatchlistMovies;

  Future<void> _onFetchWatchlistMovies(
    FetchWatchlistMovies event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(state.copyWith(watchlistState: RequestState.Loading));

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (movies) => emit(
        state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistMovies: movies,
          message: '',
        ),
      ),
    );
  }
}

