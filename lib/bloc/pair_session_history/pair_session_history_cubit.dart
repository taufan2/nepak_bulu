import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepak_bulu_2/models/pair_session_model.dart';

import 'package:nepak_bulu_2/models/player_pair_model.dart';

part 'pair_session_history_state.dart';

class PairSessionHistoryCubit extends Cubit<PairSessionHistoryState> {
  PairSessionHistoryCubit() : super(PairSessionHistoryLoading());

  Future<void> fetchPairSessionHistory(PairSessionModel pairSession) async {
    emit(PairSessionHistoryLoading());

    try {
      final histories = PairModel.withCollectionConverter(
          pairSession.docRef.collection('pairs'));
      final historiesData =
          await histories.orderBy('createdAt', descending: false).get();

      final List<PairModel> historiesDataList = historiesData.docs.map((doc) {
        final data = doc.data();
        return data;
      }).toList();

      emit(PairSessionHistoryLoaded(pairSession, historiesDataList));
    } catch (e) {
      emit(PairSessionHistoryError(e.toString()));
    }
  }
}
