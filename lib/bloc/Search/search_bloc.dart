import 'package:bloc/bloc.dart';
import 'package:library_app/repository/SearchRepository.dart';

import '../../models/Books.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    on<SearchEvent>((event, emit) async {
      SearchRepository searchRepository = SearchRepository();
      try {
        emit(SearchBookLoadingState());
        List<Books>? books =
            await searchRepository.searchBooks(keyword: event.keyword);
        emit(SearchBookSuccessedState(books));
      } catch (e) {
        print(e);
        emit(SearchBookFailedState());
      }
    });
  }
}
