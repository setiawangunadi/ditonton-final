import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  MovieSearchBloc({required this.searchMovies})
      : super(MovieSearchState.initial()) {
    on<MovieQueryChanged>(_onQueryChanged);
  }

  final SearchMovies searchMovies;

  Future<void> _onQueryChanged(
    MovieQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading, message: ''));

    final result = await searchMovies.execute(event.query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          searchResult: data,
          message: '',
        ),
      ),
    );
  }
}

