import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';

part 'select_session_bloc_event.dart';
part 'select_session_bloc_state.dart';

class SelectSessionBloc
    extends Bloc<SelectSessionBlocEvent, SelectSessionBlocState> {
  SelectSessionBloc() : super(SelectSessionBlocInitial()) {
    on<SelectSessionBlocFetch>((event, emit) async {
      try {
        emit(SelectSessionBlocLoading());

        final get = await pairSessionWithConverterCollection
            .orderBy('createdAt', descending: true)
            .limit(5)
            .get();
        final pairSessionModel = get.docs.map((e) => e.data()).toList();
        emit(SelectSessionBlocLoaded(pairSessionModel));
      } catch (e) {
        emit(SelectSessionBlocError(e.toString()));
      }
    });
  }
}
