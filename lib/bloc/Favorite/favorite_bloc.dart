import 'package:bloc/bloc.dart';
import 'package:library_app/repository/FavoriteRepository.dart';
import 'package:meta/meta.dart';

import '../../helpers/users.dart';
import '../../models/Books.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  UsersHelper usersHelper = UsersHelper();
  FavoriteRepository favoriteRepository = FavoriteRepository();

  FavoriteBloc() : super(FavoriteState()) {
    on<GetFavoriteByBookIDEvent>((event, emit) async {
      try {
        emit(GetFavoriteLoadingState());
        var currentUser = usersHelper.getCurrentUser();
        var isFavorite =
            await favoriteRepository.getFavoriteBookByUserID(userID: currentUser!.uid, bookID: event.bookID);
        emit(GetFavoriteSuccessedState(isFavorite: isFavorite));
      } catch (e) {
        emit(GetFavoriteFailedState(e.toString()));
      }
    });

    on<GetAllFavoriteByUserIDEvent>((event, emit) async {
      try {
        emit(GetAllFavoriteLoadingState());

        var currentUser = usersHelper.getCurrentUser();
        var books = await favoriteRepository.getAllFavoriteBooksByUserID(userID: currentUser!.uid);

        emit(GetAllFavoriteSuccessedState().copyWith(books: books));
      } catch (e) {
        emit(GetAllFavoriteFailedState(e.toString()));
      }
    });

    on<AddFavoriteEvent>((event, emit) async {
      try {
        emit(AddFavoriteLoadingState());
        var currentUser = usersHelper.getCurrentUser();
        var isFavorite = await favoriteRepository.addFavoriteBook(userID: currentUser!.uid, bookID: event.bookID);
        emit(AddFavoriteSuccessedState(isFavorite: isFavorite));
        state.copyWith(isFavorite: true);
      } catch (e) {
        emit(AddFavoriteFailedState("Gagal tambah ke favorite."));
      }
    });

    on<DeleteFavoriteEvent>((event, emit) async {
      try {
        emit(DeleteFavoriteLoadingState());
        var currentUser = usersHelper.getCurrentUser();
        var isSuccessDelete =
            await favoriteRepository.deleteFavoriteBook(userID: currentUser!.uid, bookID: event.bookID);

        if (isSuccessDelete) {
          emit(DeleteFavoriteSuccessedState(isFavorite: false));
        }
      } catch (e) {
        emit(DeleteFavoriteFailedState("Terjadi kesalahan, gagal hapus favorite."));
      }
    });
  }
}
