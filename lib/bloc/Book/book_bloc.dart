import 'package:bloc/bloc.dart';
import 'package:library_app/models/Books.dart';
import 'package:library_app/repository/BookRepository.dart';
import 'package:meta/meta.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookState()) {
    on<GetBooksHomeEvent>(_onGetBooksHomeEvent);
    on<GetDetailBookEvent>(_onGetDetailBookEvent);
  }

  void _onGetBooksHomeEvent(GetBooksHomeEvent event, Emitter<BookState> emit) async {
    try {
      BookRepository bookRepository = BookRepository();

      emit(GetBooksLoadingState());

      final recommendationBooks = await bookRepository.getRecommendations();
      final trendBooks = await bookRepository.getTrends();
      final newBooks = await bookRepository.getNewBooks();

      if (trendBooks != null && recommendationBooks != null && newBooks != null) {
        emit(GetBooksSuccessedState()
            .copyWith(trendBooks: trendBooks, recommendationBooks: recommendationBooks, newBooks: newBooks));
      }
    } catch (e) {
      print(e);
    }
  }

  void _onGetDetailBookEvent(GetDetailBookEvent event, Emitter<BookState> emit) async {
    try {
      emit(GetDetailBookLoadingState());
      BookRepository bookRepository = BookRepository();
      Books book = await bookRepository.getDetailBook(id: event.id);
      emit(GetDetailBookSuccessedState(detailBook: book));
    } catch (e) {}
  }
}
