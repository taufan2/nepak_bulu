part of 'select_session_bloc_bloc.dart';

sealed class SelectSessionBlocState extends Equatable {
  const SelectSessionBlocState();

  @override
  List<Object> get props => [];
}

final class SelectSessionBlocInitial extends SelectSessionBlocState {}

final class SelectSessionBlocLoading extends SelectSessionBlocState {}

class SelectSessionBlocError extends SelectSessionBlocState {
  final String message;

  const SelectSessionBlocError(this.message);

  @override
  List<Object> get props => [message];
}

final class SelectSessionBlocLoaded extends SelectSessionBlocState {
  final List<PairSessionModel> sessions;

  const SelectSessionBlocLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}
