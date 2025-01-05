part of 'pair_session_history_cubit.dart';

sealed class PairSessionHistoryState extends Equatable {
  const PairSessionHistoryState();

  @override
  List<Object> get props => [];
}

final class PairSessionHistoryLoading extends PairSessionHistoryState {}

final class PairSessionHistoryLoaded extends PairSessionHistoryState {
  final PairSessionModel pairSession;
  final List<PairModel> pairHistory;

  const PairSessionHistoryLoaded(this.pairSession, this.pairHistory);
}

final class PairSessionHistoryError extends PairSessionHistoryState {
  final String error;

  const PairSessionHistoryError(this.error);
}
