import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pages_state.dart';

class PagesCubit extends Cubit<int> {
  PagesCubit() : super(0);

  void setCurrentPage(int currentPage) => emit(currentPage);
}
